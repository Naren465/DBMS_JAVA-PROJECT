package com.cruisebus.util;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * QRCodeUtil generates data URIs and QR code URLs.
 */
public class QRCodeUtil {
    public static String generateQRCodeData(String pnr, String route, String busNumber, String seats, double amount) {
        return "CRUISEBUS-TICKET:PNR=" + pnr + "|ROUTE=" + route + "|BUS=" + busNumber + "|SEATS=" + seats + "|FARE=" + amount;
    }

    public static String getQuickQRCodeUrl(String data, int size) {
        try {
            return "https://api.qrserver.com/v1/create-qr-code/?size=" + size + "x" + size + "&data=" + URLEncoder.encode(data, StandardCharsets.UTF_8.toString());
        } catch (Exception e) {
            return "";
        }
    }
}
