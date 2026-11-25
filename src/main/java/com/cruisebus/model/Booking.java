package com.cruisebus.model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Booking {
    private int bookingId;
    private String ticketPnr;
    private int customerId;
    private int scheduleId;
    private Timestamp bookingDate;
    private double totalAmount;
    private String bookingStatus; // 'CONFIRMED', 'CANCELLED'

    // Joined objects for complete ticket display
    private Customer customer;
    private Schedule schedule;
    private List<BookingSeat> seats = new ArrayList<>();
    private Payment payment;
    private Ticket ticket;

    public Booking() {}

    public Booking(int bookingId, String ticketPnr, int customerId, int scheduleId, Timestamp bookingDate, double totalAmount, String bookingStatus) {
        this.bookingId = bookingId;
        this.ticketPnr = ticketPnr;
        this.customerId = customerId;
        this.scheduleId = scheduleId;
        this.bookingDate = bookingDate;
        this.totalAmount = totalAmount;
        this.bookingStatus = bookingStatus;
    }

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public String getTicketPnr() { return ticketPnr; }
    public void setTicketPnr(String ticketPnr) { this.ticketPnr = ticketPnr; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public int getScheduleId() { return scheduleId; }
    public void setScheduleId(int scheduleId) { this.scheduleId = scheduleId; }

    public Timestamp getBookingDate() { return bookingDate; }
    public void setBookingDate(Timestamp bookingDate) { this.bookingDate = bookingDate; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getBookingStatus() { return bookingStatus; }
    public void setBookingStatus(String bookingStatus) { this.bookingStatus = bookingStatus; }

    public Customer getCustomer() { return customer; }
    public void setCustomer(Customer customer) { this.customer = customer; }

    public Schedule getSchedule() { return schedule; }
    public void setSchedule(Schedule schedule) { this.schedule = schedule; }

    public List<BookingSeat> getSeats() { return seats; }
    public void setSeats(List<BookingSeat> seats) { this.seats = seats; }

    public Payment getPayment() { return payment; }
    public void setPayment(Payment payment) { this.payment = payment; }

    public Ticket getTicket() { return ticket; }
    public void setTicket(Ticket ticket) { this.ticket = ticket; }

    public String getSeatsSummary() {
        if (seats == null || seats.isEmpty()) return "N/A";
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < seats.size(); i++) {
            if (i > 0) sb.append(", ");
            BookingSeat bs = seats.get(i);
            sb.append(bs.getSeat() != null ? bs.getSeat().getSeatNumber() : "Seat " + bs.getSeatId());
        }
        return sb.toString();
    }
}
