package com.cruisebus.dao;

import com.cruisebus.model.Bus;
import com.cruisebus.model.Route;
import com.cruisebus.model.Schedule;
import com.cruisebus.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ScheduleDAO {

    public List<Schedule> getAllSchedules() {
        List<Schedule> list = new ArrayList<>();
        String sql = "SELECT s.*, b.bus_name, b.operator, b.bus_number, b.bus_type, b.total_seats, b.fuel_type, b.transmission, b.image_url, " +
                     "r.source, r.destination, r.distance " +
                     "FROM SCHEDULE s " +
                     "JOIN BUS b ON s.bus_id = b.bus_id " +
                     "JOIN ROUTE r ON s.route_id = r.route_id " +
                     "ORDER BY s.departure_date ASC, s.departure_time ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapScheduleJoined(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Schedule getScheduleById(int scheduleId) {
        String sql = "SELECT s.*, b.bus_name, b.operator, b.bus_number, b.bus_type, b.total_seats, b.fuel_type, b.transmission, b.image_url, " +
                     "r.source, r.destination, r.distance " +
                     "FROM SCHEDULE s " +
                     "JOIN BUS b ON s.bus_id = b.bus_id " +
                     "JOIN ROUTE r ON s.route_id = r.route_id " +
                     "WHERE s.schedule_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapScheduleJoined(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Schedule> searchSchedules(String source, String destination, String departureDate,
                                          List<String> operators, List<String> busTypes,
                                          Double minPrice, Double maxPrice,
                                          String modelQuery, String sortBy) {
        List<Schedule> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT s.*, b.bus_name, b.operator, b.bus_number, b.bus_type, b.total_seats, b.fuel_type, b.transmission, b.image_url, " +
            "r.source, r.destination, r.distance " +
            "FROM SCHEDULE s " +
            "JOIN BUS b ON s.bus_id = b.bus_id " +
            "JOIN ROUTE r ON s.route_id = r.route_id " +
            "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (source != null && !source.trim().isEmpty()) {
            sql.append("AND LOWER(r.source) LIKE LOWER(?) ");
            params.add("%" + source.trim() + "%");
        }
        if (destination != null && !destination.trim().isEmpty()) {
            sql.append("AND LOWER(r.destination) LIKE LOWER(?) ");
            params.add("%" + destination.trim() + "%");
        }
        if (departureDate != null && !departureDate.trim().isEmpty()) {
            sql.append("AND s.departure_date = ? ");
            params.add(departureDate.trim());
        }
        if (operators != null && !operators.isEmpty()) {
            sql.append("AND b.operator IN (");
            for (int i = 0; i < operators.size(); i++) {
                if (i > 0) sql.append(",");
                sql.append("?");
                params.add(operators.get(i).trim());
            }
            sql.append(") ");
        }
        if (busTypes != null && !busTypes.isEmpty()) {
            sql.append("AND b.bus_type IN (");
            for (int i = 0; i < busTypes.size(); i++) {
                if (i > 0) sql.append(",");
                sql.append("?");
                params.add(busTypes.get(i).trim());
            }
            sql.append(") ");
        }
        if (minPrice != null) {
            sql.append("AND s.fare >= ? ");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            sql.append("AND s.fare <= ? ");
            params.add(maxPrice);
        }
        if (modelQuery != null && !modelQuery.trim().isEmpty()) {
            sql.append("AND (LOWER(b.bus_name) LIKE LOWER(?) OR LOWER(b.operator) LIKE LOWER(?)) ");
            String q = "%" + modelQuery.trim() + "%";
            params.add(q);
            params.add(q);
        }

        // Sorting
        if ("price_asc".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY s.fare ASC ");
        } else if ("price_desc".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY s.fare DESC ");
        } else if ("departure_asc".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY s.departure_time ASC ");
        } else {
            // Default: Most popular / schedule sequence
            sql.append("ORDER BY s.schedule_id ASC ");
        }

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapScheduleJoined(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addSchedule(Schedule schedule) {
        String sql = "INSERT INTO SCHEDULE (bus_id, route_id, departure_date, departure_time, arrival_time, fare) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, schedule.getBusId());
            ps.setInt(2, schedule.getRouteId());
            ps.setDate(3, schedule.getDepartureDate());
            ps.setTime(4, schedule.getDepartureTime());
            ps.setTime(5, schedule.getArrivalTime());
            ps.setDouble(6, schedule.getFare());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        schedule.setScheduleId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteSchedule(int scheduleId) {
        String sql = "DELETE FROM SCHEDULE WHERE schedule_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Schedule mapScheduleJoined(ResultSet rs) throws SQLException {
        Schedule s = new Schedule(
            rs.getInt("schedule_id"),
            rs.getInt("bus_id"),
            rs.getInt("route_id"),
            rs.getDate("departure_date"),
            rs.getTime("departure_time"),
            rs.getTime("arrival_time"),
            rs.getDouble("fare")
        );

        Bus b = new Bus(
            rs.getInt("bus_id"),
            rs.getString("bus_name"),
            rs.getString("operator"),
            rs.getString("bus_number"),
            rs.getString("bus_type"),
            rs.getInt("total_seats"),
            rs.getString("fuel_type"),
            rs.getString("transmission"),
            rs.getString("image_url")
        );
        s.setBus(b);

        Route r = new Route(
            rs.getInt("route_id"),
            rs.getString("source"),
            rs.getString("destination"),
            rs.getInt("distance")
        );
        s.setRoute(r);

        return s;
    }
}
