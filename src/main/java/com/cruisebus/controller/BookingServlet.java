package com.cruisebus.controller;

import com.cruisebus.dao.BookingDAO;
import com.cruisebus.dao.CustomerDAO;
import com.cruisebus.model.Booking;
import com.cruisebus.model.Customer;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "BookingServlet", urlPatterns = {"/book", "/confirm-booking"})
public class BookingServlet extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Customer user = (Customer) session.getAttribute("user");

        String scheduleIdStr = request.getParameter("scheduleId");
        String seatIdsStr = request.getParameter("seatIds");
        String paymentMethod = request.getParameter("paymentMethod");

        if (scheduleIdStr == null || seatIdsStr == null || seatIdsStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/search?error=missing_booking_params");
            return;
        }

        // Check authentication
        if (user == null) {
            // Save state in session to redirect back after login
            session.setAttribute("redirectAfterLogin", request.getContextPath() + "/seats?scheduleId=" + scheduleIdStr);
            response.sendRedirect(request.getContextPath() + "/auth?tab=login&msg=login_required");
            return;
        }

        try {
            int scheduleId = Integer.parseInt(scheduleIdStr.trim());
            String[] seatIdParts = seatIdsStr.split(",");
            List<Integer> seatIds = new ArrayList<>();
            for (String s : seatIdParts) {
                if (!s.trim().isEmpty()) {
                    seatIds.add(Integer.parseInt(s.trim()));
                }
            }

            if (seatIds.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/seats?scheduleId=" + scheduleId + "&error=no_seats_selected");
                return;
            }

            List<String> passengerNames = new ArrayList<>();
            List<Integer> passengerAges = new ArrayList<>();
            List<String> passengerGenders = new ArrayList<>();

            for (int i = 0; i < seatIds.size(); i++) {
                String pName = request.getParameter("passengerName_" + i);
                String pAge = request.getParameter("passengerAge_" + i);
                String pGender = request.getParameter("passengerGender_" + i);

                passengerNames.add((pName != null && !pName.trim().isEmpty()) ? pName.trim() : user.getName());
                passengerAges.add((pAge != null && !pAge.trim().isEmpty()) ? Integer.parseInt(pAge.trim()) : 25);
                passengerGenders.add((pGender != null && !pGender.trim().isEmpty()) ? pGender.trim() : "MALE");
            }

            // Execute atomic transaction in MySQL
            Booking booking = bookingDAO.createBookingTransactional(
                user.getCustomerId(),
                scheduleId,
                seatIds,
                passengerNames,
                passengerAges,
                passengerGenders,
                paymentMethod != null ? paymentMethod : "CARD"
            );

            // Redirect to ticket page
            response.sendRedirect(request.getContextPath() + "/ticket?pnr=" + booking.getTicketPnr() + "&success=booked");

        } catch (IllegalStateException e) {
            // Concurrency seat collision
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/seats?scheduleId=" + scheduleIdStr).forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Booking failed: " + e.getMessage());
            request.getRequestDispatcher("/seats?scheduleId=" + scheduleIdStr).forward(request, response);
        }
    }
}
