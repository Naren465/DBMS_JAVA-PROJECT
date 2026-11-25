package com.cruisebus.dao;

import com.cruisebus.model.Route;
import com.cruisebus.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RouteDAO {

    public List<Route> getAllRoutes() {
        List<Route> list = new ArrayList<>();
        String sql = "SELECT * FROM ROUTE ORDER BY source ASC, destination ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRoute(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Route getRouteById(int routeId) {
        String sql = "SELECT * FROM ROUTE WHERE route_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, routeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRoute(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<String> getDistinctSources() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT source FROM ROUTE ORDER BY source ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getString("source"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<String> getDistinctDestinations() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT destination FROM ROUTE ORDER BY destination ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getString("destination"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addRoute(Route route) {
        String sql = "INSERT INTO ROUTE (source, destination, distance) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, route.getSource());
            ps.setString(2, route.getDestination());
            ps.setInt(3, route.getDistance());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        route.setRouteId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteRoute(int routeId) {
        String sql = "DELETE FROM ROUTE WHERE route_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, routeId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Route mapRoute(ResultSet rs) throws SQLException {
        return new Route(
            rs.getInt("route_id"),
            rs.getString("source"),
            rs.getString("destination"),
            rs.getInt("distance")
        );
    }
}
