package com.cruisebus.model;

import java.sql.Date;
import java.sql.Time;

public class Schedule {
    private int scheduleId;
    private int busId;
    private int routeId;
    private Date departureDate;
    private Time departureTime;
    private Time arrivalTime;
    private double fare;

    // Joined fields for view display
    private Bus bus;
    private Route route;

    public Schedule() {}

    public Schedule(int scheduleId, int busId, int routeId, Date departureDate, Time departureTime, Time arrivalTime, double fare) {
        this.scheduleId = scheduleId;
        this.busId = busId;
        this.routeId = routeId;
        this.departureDate = departureDate;
        this.departureTime = departureTime;
        this.arrivalTime = arrivalTime;
        this.fare = fare;
    }

    public int getScheduleId() { return scheduleId; }
    public void setScheduleId(int scheduleId) { this.scheduleId = scheduleId; }

    public int getBusId() { return busId; }
    public void setBusId(int busId) { this.busId = busId; }

    public int getRouteId() { return routeId; }
    public void setRouteId(int routeId) { this.routeId = routeId; }

    public Date getDepartureDate() { return departureDate; }
    public void setDepartureDate(Date departureDate) { this.departureDate = departureDate; }

    public Time getDepartureTime() { return departureTime; }
    public void setDepartureTime(Time departureTime) { this.departureTime = departureTime; }

    public Time getArrivalTime() { return arrivalTime; }
    public void setArrivalTime(Time arrivalTime) { this.arrivalTime = arrivalTime; }

    public double getFare() { return fare; }
    public void setFare(double fare) { this.fare = fare; }

    public Bus getBus() { return bus; }
    public void setBus(Bus bus) { this.bus = bus; }

    public Route getRoute() { return route; }
    public void setRoute(Route route) { this.route = route; }
}
