package com.cruisebus.dao;

import com.cruisebus.model.Bus;
import com.cruisebus.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BusDAO {

    public List<Bus> getAllBuses() {
        List<Bus> list = new ArrayList<>();
        String sql = "SELECT * FROM BUS ORDER BY bus_id ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapBus(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Bus getBusById(int busId) {
        String sql = "SELECT * FROM BUS WHERE bus_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, busId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapBus(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addBus(Bus bus) {
        String sql = "INSERT INTO BUS (bus_name, operator, bus_number, bus_type, total_seats, fuel_type, transmission, image_url) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, bus.getBusName());
            ps.setString(2, bus.getOperator());
            ps.setString(3, bus.getBusNumber());
            ps.setString(4, bus.getBusType());
            ps.setInt(5, bus.getTotalSeats());
            ps.setString(6, bus.getFuelType());
            ps.setString(7, bus.getTransmission());
            ps.setString(8, bus.getImageUrl());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        bus.setBusId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateBus(Bus bus) {
        String sql = "UPDATE BUS SET bus_name = ?, operator = ?, bus_number = ?, bus_type = ?, total_seats = ?, fuel_type = ?, transmission = ?, image_url = ? WHERE bus_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, bus.getBusName());
            ps.setString(2, bus.getOperator());
            ps.setString(3, bus.getBusNumber());
            ps.setString(4, bus.getBusType());
            ps.setInt(5, bus.getTotalSeats());
            ps.setString(6, bus.getFuelType());
            ps.setString(7, bus.getTransmission());
            ps.setString(8, bus.getImageUrl());
            ps.setInt(9, bus.getBusId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteBus(int busId) {
        String sql = "DELETE FROM BUS WHERE bus_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, busId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<String> getDistinctOperators() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT operator FROM BUS ORDER BY operator ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getString("operator"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<String> getDistinctBusTypes() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT bus_type FROM BUS ORDER BY bus_type ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getString("bus_type"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Bus mapBus(ResultSet rs) throws SQLException {
        return new Bus(
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
    }
}
