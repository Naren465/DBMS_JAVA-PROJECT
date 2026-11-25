package com.cruisebus.model;

public class BookingSeat {
    private int bookingSeatId;
    private int bookingId;
    private int seatId;
    private String passengerName;
    private int passengerAge;
    private String passengerGender;

    private Seat seat;

    public BookingSeat() {}

    public BookingSeat(int bookingSeatId, int bookingId, int seatId, String passengerName, int passengerAge, String passengerGender) {
        this.bookingSeatId = bookingSeatId;
        this.bookingId = bookingId;
        this.seatId = seatId;
        this.passengerName = passengerName;
        this.passengerAge = passengerAge;
        this.passengerGender = passengerGender;
    }

    public int getBookingSeatId() { return bookingSeatId; }
    public void setBookingSeatId(int bookingSeatId) { this.bookingSeatId = bookingSeatId; }

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public int getSeatId() { return seatId; }
    public void setSeatId(int seatId) { this.seatId = seatId; }

    public String getPassengerName() { return passengerName; }
    public void setPassengerName(String passengerName) { this.passengerName = passengerName; }

    public int getPassengerAge() { return passengerAge; }
    public void setPassengerAge(int passengerAge) { this.passengerAge = passengerAge; }

    public String getPassengerGender() { return passengerGender; }
    public void setPassengerGender(String passengerGender) { this.passengerGender = passengerGender; }

    public Seat getSeat() { return seat; }
    public void setSeat(Seat seat) { this.seat = seat; }
}
