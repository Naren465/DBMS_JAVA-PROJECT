package com.cruisebus.model;

import java.sql.Timestamp;

public class Ticket {
    private int ticketId;
    private int bookingId;
    private Integer seatId;
    private String qrCodeData;
    private Timestamp issuedDate;

    public Ticket() {}

    public Ticket(int ticketId, int bookingId, Integer seatId, String qrCodeData, Timestamp issuedDate) {
        this.ticketId = ticketId;
        this.bookingId = bookingId;
        this.seatId = seatId;
        this.qrCodeData = qrCodeData;
        this.issuedDate = issuedDate;
    }

    public int getTicketId() { return ticketId; }
    public void setTicketId(int ticketId) { this.ticketId = ticketId; }

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public Integer getSeatId() { return seatId; }
    public void setSeatId(Integer seatId) { this.seatId = seatId; }

    public String getQrCodeData() { return qrCodeData; }
    public void setQrCodeData(String qrCodeData) { this.qrCodeData = qrCodeData; }

    public Timestamp getIssuedDate() { return issuedDate; }
    public void setIssuedDate(Timestamp issuedDate) { this.issuedDate = issuedDate; }
}
