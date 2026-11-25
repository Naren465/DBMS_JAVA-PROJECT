package com.cruisebus.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * PasswordUtil provides secure SHA-256 password hashing with salt.
 */
public class PasswordUtil {
    private static final String SALT = "CruiseBus@SecureSalt2026";

    public static String hashPassword(String password) {
        if (password == null || password.trim().isEmpty()) {
            return "";
        }
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            String salted = password + SALT;
            byte[] hash = md.digest(salted.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }

    public static boolean checkPassword(String plainPassword, String storedHashOrPassword) {
        if (plainPassword == null || storedHashOrPassword == null) {
            return false;
        }
        // Direct match for legacy / seeded demo passwords
        if (plainPassword.equals(storedHashOrPassword)) {
            return true;
        }
        // Hash comparison
        return hashPassword(plainPassword).equalsIgnoreCase(storedHashOrPassword);
    }
}
