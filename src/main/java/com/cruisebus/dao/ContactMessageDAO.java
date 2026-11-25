package com.cruisebus.dao;

import com.cruisebus.model.ContactMessage;
import com.cruisebus.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ContactMessageDAO {

    public boolean saveMessage(ContactMessage message) {
        String sql = "INSERT INTO CONTACT_MESSAGE (name, email, phone, subject, message) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, message.getName());
            ps.setString(2, message.getEmail());
            ps.setString(3, message.getPhone());
            ps.setString(4, message.getSubject());
            ps.setString(5, message.getMessage());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        message.setMessageId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<ContactMessage> getAllMessages() {
        List<ContactMessage> list = new ArrayList<>();
        String sql = "SELECT * FROM CONTACT_MESSAGE ORDER BY submitted_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new ContactMessage(
                    rs.getInt("message_id"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("phone"),
                    rs.getString("subject"),
                    rs.getString("message"),
                    rs.getTimestamp("submitted_at")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
