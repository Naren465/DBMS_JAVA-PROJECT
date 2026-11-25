package com.cruisebus.dao;

import com.cruisebus.model.*;
import com.cruisebus.util.DBUtil;
import com.cruisebus.util.QRCodeUtil;

import java.security.SecureRandom;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {
    private static final String CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
    private static final SecureRandom RANDOM = new SecureRandom();

    public static String generatePNR() {
        StringBuilder sb = new StringBuilder("CB");
        for (int i = 0; i < 6; i++) {
            sb.append(CHARS.charAt(RANDOM.nextInt(CHARS.length())));
        }
        return sb.toString();
    }

    /**
     * Atomically reserve seats using DB transaction and lock concurrency check.
     */
    public synchronized Booking createBookingTransactional(
            int customerId,
            int scheduleId,
            List<Integer> seatIds,
            List<String> passengerNames,
            List<Integer> passengerAges,
            List<String> passengerGenders,
            String paymentMethod) throws Exception {

        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // 1. Fetch schedule to calculate fare
            String schedSql = "SELECT s.*, b.bus_name, b.bus_number, r.source, r.destination " +
                              "FROM SCHEDULE s " +
                              "JOIN BUS b ON s.bus_id = b.bus_id " +
                              "JOIN ROUTE r ON s.route_id = r.route_id " +
                              "WHERE s.schedule_id = ?";
            double farePerSeat = 0;
            String busNumber = "";
            String routeName = "";
            try (PreparedStatement psSched = conn.prepareStatement(schedSql)) {
                psSched.setInt(1, scheduleId);
                try (ResultSet rsSched = psSched.executeQuery()) {
                    if (rsSched.next()) {
                        farePerSeat = rsSched.getDouble("fare");
                        busNumber = rsSched.getString("bus_number");
                        routeName = rsSched.getString("source") + " - " + rsSched.getString("destination");
                    } else {
                        throw new IllegalArgumentException("Schedule not found.");
                    }
                }
            }

            // 2. Concurrency Check: Check if any requested seat is already booked for this schedule
            StringBuilder checkSql = new StringBuilder(
                "SELECT bs.seat_id FROM BOOKING_SEAT bs " +
                "JOIN BOOKING b ON bs.booking_id = b.booking_id " +
                "WHERE b.schedule_id = ? AND b.booking_status = 'CONFIRMED' AND bs.seat_id IN ("
            );
            for (int i = 0; i < seatIds.size(); i++) {
                if (i > 0) checkSql.append(",");
                checkSql.append("?");
            }
            checkSql.append(") FOR UPDATE");

            try (PreparedStatement psCheck = conn.prepareStatement(checkSql.toString())) {
                psCheck.setInt(1, scheduleId);
                for (int i = 0; i < seatIds.size(); i++) {
                    psCheck.setInt(i + 2, seatIds.get(i));
                }
                try (ResultSet rsCheck = psCheck.executeQuery()) {
                    if (rsCheck.next()) {
                        throw new IllegalStateException("One or more selected seats (Seat ID: " + rsCheck.getInt("seat_id") + ") have just been booked by another passenger. Please select another seat.");
                    }
                }
            }

            // 3. Insert into BOOKING
            String pnr = generatePNR();
            double totalAmount = farePerSeat * seatIds.size();

            String bookingSql = "INSERT INTO BOOKING (ticket_pnr, customer_id, schedule_id, total_amount, booking_status) VALUES (?, ?, ?, ?, 'CONFIRMED')";
            int bookingId;
            try (PreparedStatement psBooking = conn.prepareStatement(bookingSql, Statement.RETURN_GENERATED_KEYS)) {
                psBooking.setString(1, pnr);
                psBooking.setInt(2, customerId);
                psBooking.setInt(3, scheduleId);
                psBooking.setDouble(4, totalAmount);
                psBooking.executeUpdate();

                try (ResultSet rsKeys = psBooking.getGeneratedKeys()) {
                    if (rsKeys.next()) {
                        bookingId = rsKeys.getInt(1);
                    } else {
                        throw new SQLException("Failed to obtain booking ID.");
                    }
                }
            }

            // 4. Insert each passenger into BOOKING_SEAT
            String seatSql = "INSERT INTO BOOKING_SEAT (booking_id, seat_id, passenger_name, passenger_age, passenger_gender) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement psSeat = conn.prepareStatement(seatSql)) {
                for (int i = 0; i < seatIds.size(); i++) {
                    psSeat.setInt(1, bookingId);
                    psSeat.setInt(2, seatIds.get(i));
                    psSeat.setString(3, (passengerNames != null && i < passengerNames.size()) ? passengerNames.get(i) : "Passenger " + (i + 1));
                    psSeat.setInt(4, (passengerAges != null && i < passengerAges.size()) ? passengerAges.get(i) : 25);
                    psSeat.setString(5, (passengerGenders != null && i < passengerGenders.size()) ? passengerGenders.get(i) : "MALE");
                    psSeat.addBatch();
                }
                psSeat.executeBatch();
            }

            // 5. Insert PAYMENT record
            String txnRef = "TXN_" + pnr + "_" + System.currentTimeMillis() % 100000;
            String paymentSql = "INSERT INTO PAYMENT (booking_id, payment_amount, payment_status, payment_method, transaction_ref) VALUES (?, ?, 'SUCCESS', ?, ?)";
            try (PreparedStatement psPay = conn.prepareStatement(paymentSql)) {
                psPay.setInt(1, bookingId);
                psPay.setDouble(2, totalAmount);
                psPay.setString(3, paymentMethod != null ? paymentMethod : "CARD");
                psPay.setString(4, txnRef);
                psPay.executeUpdate();
            }

            // 6. Insert TICKET record with QR Code
            String qrData = QRCodeUtil.generateQRCodeData(pnr, routeName, busNumber, seatIds.toString(), totalAmount);
            String ticketSql = "INSERT INTO TICKET (booking_id, seat_id, qr_code_data) VALUES (?, ?, ?)";
            try (PreparedStatement psTicket = conn.prepareStatement(ticketSql)) {
                psTicket.setInt(1, bookingId);
                psTicket.setInt(2, seatIds.get(0));
                psTicket.setString(3, qrData);
                psTicket.executeUpdate();
            }

            // Commit transaction
            conn.commit();

            return getBookingByPnr(pnr);

        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ignored) {}
            }
        }
    }

    public Booking getBookingByPnr(String pnr) {
        String sql = "SELECT b.*, c.name AS customer_name, c.email AS customer_email, c.phone AS customer_phone, " +
                     "s.departure_date, s.departure_time, s.arrival_time, s.fare, " +
                     "bu.bus_id, bu.bus_name, bu.operator, bu.bus_number, bu.bus_type, bu.fuel_type, bu.transmission, bu.image_url, " +
                     "r.source, r.destination, r.distance, " +
                     "p.payment_id, p.payment_amount, p.payment_status, p.payment_method, p.transaction_ref, p.payment_date, " +
                     "t.ticket_id, t.qr_code_data, t.issued_date " +
                     "FROM BOOKING b " +
                     "JOIN CUSTOMER c ON b.customer_id = c.customer_id " +
                     "JOIN SCHEDULE s ON b.schedule_id = s.schedule_id " +
                     "JOIN BUS bu ON s.bus_id = bu.bus_id " +
                     "JOIN ROUTE r ON s.route_id = r.route_id " +
                     "LEFT JOIN PAYMENT p ON b.booking_id = p.booking_id " +
                     "LEFT JOIN TICKET t ON b.booking_id = t.booking_id " +
                     "WHERE LOWER(b.ticket_pnr) = LOWER(?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, pnr.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Booking b = mapFullBooking(rs);
                    loadBookingSeats(conn, b);
                    return b;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Booking> getBookingsByCustomerId(int customerId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT ticket_pnr FROM BOOKING WHERE customer_id = ? ORDER BY booking_id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = getBookingByPnr(rs.getString("ticket_pnr"));
                    if (b != null) list.add(b);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Booking> getAllBookings() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT ticket_pnr FROM BOOKING ORDER BY booking_id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Booking b = getBookingByPnr(rs.getString("ticket_pnr"));
                if (b != null) list.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean cancelBooking(String pnr) {
        String sql = "UPDATE BOOKING SET booking_status = 'CANCELLED' WHERE LOWER(ticket_pnr) = LOWER(?)";
        String paySql = "UPDATE PAYMENT p JOIN BOOKING b ON p.booking_id = b.booking_id SET p.payment_status = 'REFUNDED' WHERE LOWER(b.ticket_pnr) = LOWER(?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             PreparedStatement psPay = conn.prepareStatement(paySql)) {
            ps.setString(1, pnr.trim());
            psPay.setString(1, pnr.trim());
            int affected = ps.executeUpdate();
            psPay.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateBookingStatus(int bookingId, String status) {
        String sql = "UPDATE BOOKING SET booking_status = ? WHERE booking_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private void loadBookingSeats(Connection conn, Booking b) throws SQLException {
        String sql = "SELECT bs.*, s.seat_number, s.seat_type, s.deck " +
                     "FROM BOOKING_SEAT bs " +
                     "JOIN SEAT s ON bs.seat_id = s.seat_id " +
                     "WHERE bs.booking_id = ? ORDER BY s.seat_number ASC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, b.getBookingId());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BookingSeat bs = new BookingSeat(
                        rs.getInt("booking_seat_id"),
                        rs.getInt("booking_id"),
                        rs.getInt("seat_id"),
                        rs.getString("passenger_name"),
                        rs.getInt("passenger_age"),
                        rs.getString("passenger_gender")
                    );
                    Seat seat = new Seat(
                        rs.getInt("seat_id"),
                        b.getSchedule() != null && b.getSchedule().getBus() != null ? b.getSchedule().getBus().getBusId() : 0,
                        rs.getString("seat_number"),
                        "BOOKED",
                        rs.getString("seat_type"),
                        rs.getString("deck")
                    );
                    bs.setSeat(seat);
                    b.getSeats().add(bs);
                }
            }
        }
    }

    private Booking mapFullBooking(ResultSet rs) throws SQLException {
        Booking b = new Booking(
            rs.getInt("booking_id"),
            rs.getString("ticket_pnr"),
            rs.getInt("customer_id"),
            rs.getInt("schedule_id"),
            rs.getTimestamp("booking_date"),
            rs.getDouble("total_amount"),
            rs.getString("booking_status")
        );

        Customer c = new Customer(
            rs.getInt("customer_id"),
            rs.getString("customer_name"),
            rs.getString("customer_email"),
            rs.getString("customer_phone"),
            "",
            "CUSTOMER",
            null
        );
        b.setCustomer(c);

        Bus bus = new Bus(
            rs.getInt("bus_id"),
            rs.getString("bus_name"),
            rs.getString("operator"),
            rs.getString("bus_number"),
            rs.getString("bus_type"),
            0,
            rs.getString("fuel_type"),
            rs.getString("transmission"),
            rs.getString("image_url")
        );

        Route route = new Route(
            0,
            rs.getString("source"),
            rs.getString("destination"),
            rs.getInt("distance")
        );

        Schedule sched = new Schedule(
            rs.getInt("schedule_id"),
            rs.getInt("bus_id"),
            0,
            rs.getDate("departure_date"),
            rs.getTime("departure_time"),
            rs.getTime("arrival_time"),
            rs.getDouble("fare")
        );
        sched.setBus(bus);
        sched.setRoute(route);
        b.setSchedule(sched);

        if (rs.getInt("payment_id") > 0) {
            Payment p = new Payment(
                rs.getInt("payment_id"),
                b.getBookingId(),
                rs.getDouble("payment_amount"),
                rs.getString("payment_status"),
                rs.getTimestamp("payment_date"),
                rs.getString("payment_method"),
                rs.getString("transaction_ref")
            );
            b.setPayment(p);
        }

        if (rs.getInt("ticket_id") > 0) {
            Ticket t = new Ticket(
                rs.getInt("ticket_id"),
                b.getBookingId(),
                null,
                rs.getString("qr_code_data"),
                rs.getTimestamp("issued_date")
            );
            b.setTicket(t);
        }

        return b;
    }
}
