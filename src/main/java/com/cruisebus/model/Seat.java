package com.cruisebus.model;

public class Seat {
    private int seatId;
    private int busId;
    private String seatNumber;
    private String seatStatus; // 'AVAILABLE', 'BOOKED', 'LOCKED'
    private String seatType;   // 'SEATER', 'SLEEPER'
    private String deck;       // 'LOWER', 'UPPER'

    public Seat() {}

    public Seat(int seatId, int busId, String seatNumber, String seatStatus, String seatType, String deck) {
        this.seatId = seatId;
        this.busId = busId;
        this.seatNumber = seatNumber;
        this.seatStatus = seatStatus;
        this.seatType = seatType;
        this.deck = deck;
    }

    public int getSeatId() { return seatId; }
    public void setSeatId(int seatId) { this.seatId = seatId; }

    public int getBusId() { return busId; }
    public void setBusId(int busId) { this.busId = busId; }

    public String getSeatNumber() { return seatNumber; }
    public void setSeatNumber(String seatNumber) { this.seatNumber = seatNumber; }

    public String getSeatStatus() { return seatStatus; }
    public void setSeatStatus(String seatStatus) { this.seatStatus = seatStatus; }

    public String getSeatType() { return seatType; }
    public void setSeatType(String seatType) { this.seatType = seatType; }

    public String getDeck() { return deck; }
    public void setDeck(String deck) { this.deck = deck; }

    public boolean isAvailable() {
        return "AVAILABLE".equalsIgnoreCase(this.seatStatus);
    }
}
