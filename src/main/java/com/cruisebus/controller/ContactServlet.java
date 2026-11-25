package com.cruisebus.controller;

import com.cruisebus.dao.ContactMessageDAO;
import com.cruisebus.model.ContactMessage;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "ContactServlet", urlPatterns = {"/contact"})
public class ContactServlet extends HttpServlet {
    private final ContactMessageDAO messageDAO = new ContactMessageDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("activeNav", "contact");
        request.getRequestDispatcher("/WEB-INF/views/contact.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        if (name == null || email == null || message == null ||
            name.trim().isEmpty() || email.trim().isEmpty() || message.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Name, Email and Message are required.");
            request.setAttribute("activeNav", "contact");
            request.getRequestDispatcher("/WEB-INF/views/contact.jsp").forward(request, response);
            return;
        }

        ContactMessage msg = new ContactMessage();
        msg.setName(name.trim());
        msg.setEmail(email.trim());
        msg.setPhone(phone != null ? phone.trim() : "");
        msg.setSubject(subject != null ? subject.trim() : "Website Inquiry");
        msg.setMessage(message.trim());

        boolean saved = messageDAO.saveMessage(msg);
        if (saved) {
            request.setAttribute("successMessage", "Thank you! Your message has been received by our 24/7 concierge support team.");
        } else {
            request.setAttribute("errorMessage", "Failed to submit message. Please try again.");
        }

        request.setAttribute("activeNav", "contact");
        request.getRequestDispatcher("/WEB-INF/views/contact.jsp").forward(request, response);
    }
}
