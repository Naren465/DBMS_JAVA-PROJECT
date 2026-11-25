package com.cruisebus.dao;

import com.cruisebus.model.Seat;
import com.cruisebus.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class SeatDAO {

    public List<Seat> getSeatsByBusId(int busId) {
        List<Seat> list = new ArrayList<>();
        String sql = "SELECT * FROM SEAT WHERE bus_id = ? ORDER BY deck ASC, seat_id ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, busId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapSeat(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Seat> getSeatsByBusAndSchedule(int busId, int scheduleId) {
        List<Seat> allSeats = getSeatsByBusId(busId);
        if (allSeats.isEmpty()) {
            initSeatsForBus(busId, 36, "AC Sleeper");
            allSeats = getSeatsByBusId(busId);
        }

        // Find which seats are already booked for this specific schedule
        Set<Integer> bookedSeatIds = new HashSet<>();
        String sql = "SELECT bs.seat_id FROM BOOKING_SEAT bs " +
                     "JOIN BOOKING b ON bs.booking_id = b.booking_id " +
                     "WHERE b.schedule_id = ? AND b.booking_status = 'CONFIRMED'";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    bookedSeatIds.add(rs.getInt("seat_id"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Apply dynamic status
        for (Seat seat : allSeats) {
            if (bookedSeatIds.contains(seat.getSeatId())) {
                seat.setSeatStatus("BOOKED");
            } else {
                seat.setSeatStatus("AVAILABLE");
            }
        }

        return allSeats;
    }

    public void initSeatsForBus(int busId, int totalSeats, String busType) {
        String type = (busType != null && busType.toLowerCase().contains("sleeper")) ? "SLEEPER" : "SEATER";
        String checkSql = "SELECT COUNT(*) FROM SEAT WHERE bus_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(checkSql)) {
            ps.setInt(1, busId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    return; // Already initialized
                }
            }

            String insertSql = "INSERT INTO SEAT (bus_id, seat_number, seat_status, seat_type, deck) VALUES (?, ?, 'AVAILABLE', ?, ?)";
            try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                conn.setAutoCommit(false);
                int lowerCount = (totalSeats > 24) ? totalSeats / 2 : totalSeats;
                for (int i = 1; i <= totalSeats; i++) {
                    String seatNum = (i < 10 ? "0" : "") + i;
                    String deck = (i <= lowerCount) ? "LOWER" : "UPPER";
                    insertPs.setInt(1, busId);
                    insertPs.setString(2, seatNum);
                    insertPs.setString(3, type);
                    insertPs.setString(4, deck);
                    insertPs.addBatch();
                }
                insertPs.executeBatch();
                conn.commit();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Seat mapSeat(ResultSet rs) throws SQLException {
        return new Seat(
            rs.getInt("seat_id"),
            rs.getInt("bus_id"),
            rs.getString("seat_number"),
            rs.getString("seat_status"),
            rs.getString("seat_type"),
            rs.getString("deck")
        );
    }
}
