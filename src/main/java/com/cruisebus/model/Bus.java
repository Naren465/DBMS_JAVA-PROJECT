package com.cruisebus.model;

public class Bus {
    private int busId;
    private String busName;
    private String operator;
    private String busNumber;
    private String busType; // 'AC Sleeper', 'AC Seater', 'Non AC Seater'
    private int totalSeats;
    private String fuelType;
    private String transmission;
    private String imageUrl;

    public Bus() {}

    public Bus(int busId, String busName, String operator, String busNumber, String busType, int totalSeats, String fuelType, String transmission, String imageUrl) {
        this.busId = busId;
        this.busName = busName;
        this.operator = operator;
        this.busNumber = busNumber;
        this.busType = busType;
        this.totalSeats = totalSeats;
        this.fuelType = fuelType;
        this.transmission = transmission;
        this.imageUrl = imageUrl;
    }

    public int getBusId() { return busId; }
    public void setBusId(int busId) { this.busId = busId; }

    public String getBusName() { return busName; }
    public void setBusName(String busName) { this.busName = busName; }

    public String getOperator() { return operator; }
    public void setOperator(String operator) { this.operator = operator; }

    public String getBusNumber() { return busNumber; }
    public void setBusNumber(String busNumber) { this.busNumber = busNumber; }

    public String getBusType() { return busType; }
    public void setBusType(String busType) { this.busType = busType; }

    public int getTotalSeats() { return totalSeats; }
    public void setTotalSeats(int totalSeats) { this.totalSeats = totalSeats; }

    public String getFuelType() { return fuelType; }
    public void setFuelType(String fuelType) { this.fuelType = fuelType; }

    public String getTransmission() { return transmission; }
    public void setTransmission(String transmission) { this.transmission = transmission; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
}
