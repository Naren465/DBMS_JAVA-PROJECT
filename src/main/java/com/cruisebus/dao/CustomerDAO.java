package com.cruisebus.dao;

import com.cruisebus.model.Customer;
import com.cruisebus.util.DBUtil;
import com.cruisebus.util.PasswordUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {

    public Customer findByEmail(String email) {
        String sql = "SELECT customer_id, name, email, phone, password, role, created_at FROM CUSTOMER WHERE email = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email.trim().toLowerCase());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapCustomer(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Customer findById(int id) {
        String sql = "SELECT customer_id, name, email, phone, password, role, created_at FROM CUSTOMER WHERE customer_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapCustomer(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean register(Customer customer) {
        if (findByEmail(customer.getEmail()) != null) {
            return false; // Email already exists
        }
        String sql = "INSERT INTO CUSTOMER (name, email, phone, password, role) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, customer.getName().trim());
            ps.setString(2, customer.getEmail().trim().toLowerCase());
            ps.setString(3, customer.getPhone().trim());
            ps.setString(4, PasswordUtil.hashPassword(customer.getPassword()));
            ps.setString(5, customer.getRole() != null ? customer.getRole() : "CUSTOMER");

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        customer.setCustomerId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Customer validateLogin(String email, String password) {
        Customer c = findByEmail(email);
        if (c != null && PasswordUtil.checkPassword(password, c.getPassword())) {
            return c;
        }
        return null;
    }

    public List<Customer> getAllCustomers() {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT customer_id, name, email, phone, password, role, created_at FROM CUSTOMER ORDER BY customer_id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapCustomer(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Customer mapCustomer(ResultSet rs) throws SQLException {
        return new Customer(
            rs.getInt("customer_id"),
            rs.getString("name"),
            rs.getString("email"),
            rs.getString("phone"),
            rs.getString("password"),
            rs.getString("role"),
            rs.getTimestamp("created_at")
        );
    }
}
