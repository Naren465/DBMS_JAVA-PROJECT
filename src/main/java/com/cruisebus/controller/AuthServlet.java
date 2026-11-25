package com.cruisebus.controller;

import com.cruisebus.dao.CustomerDAO;
import com.cruisebus.model.Customer;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "AuthServlet", urlPatterns = {"/auth", "/login", "/signup", "/logout"})
public class AuthServlet extends HttpServlet {
    private final CustomerDAO customerDAO = new CustomerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/logout".equalsIgnoreCase(path)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/home?msg=logged_out");
            return;
        }

        String tab = request.getParameter("tab");
        if (tab == null) tab = "/signup".equalsIgnoreCase(path) ? "signup" : "login";
        request.setAttribute("activeTab", tab);
        request.setAttribute("activeNav", "auth");

        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "login";

        HttpSession session = request.getSession();

        if ("login".equalsIgnoreCase(action)) {
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Email and Password are required.");
                request.setAttribute("activeTab", "login");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
                return;
            }

            Customer user = customerDAO.validateLogin(email.trim(), password.trim());
            if (user != null) {
                session.setAttribute("user", user);
                session.setAttribute("userName", user.getName());
                session.setAttribute("userEmail", user.getEmail());
                session.setAttribute("userRole", user.getRole());

                // Check for pending redirect
                String redirect = (String) session.getAttribute("redirectAfterLogin");
                if (redirect != null) {
                    session.removeAttribute("redirectAfterLogin");
                    response.sendRedirect(redirect);
                } else if (user.isAdmin()) {
                    response.sendRedirect(request.getContextPath() + "/admin");
                } else {
                    response.sendRedirect(request.getContextPath() + "/home");
                }
            } else {
                request.setAttribute("errorMessage", "Invalid email or password. Please try again.");
                request.setAttribute("emailValue", email);
                request.setAttribute("activeTab", "login");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            }

        } else if ("signup".equalsIgnoreCase(action)) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");

            // Validations
            if (name == null || email == null || phone == null || password == null ||
                name.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
                request.setAttribute("errorMessage", "All required fields must be filled.");
                request.setAttribute("activeTab", "signup");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
                return;
            }

            if (!password.equals(confirmPassword)) {
                request.setAttribute("errorMessage", "Passwords do not match. Please re-enter.");
                request.setAttribute("signupName", name);
                request.setAttribute("signupEmail", email);
                request.setAttribute("signupPhone", phone);
                request.setAttribute("activeTab", "signup");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
                return;
            }

            if (password.length() < 6) {
                request.setAttribute("errorMessage", "Password must be at least 6 characters long.");
                request.setAttribute("signupName", name);
                request.setAttribute("signupEmail", email);
                request.setAttribute("signupPhone", phone);
                request.setAttribute("activeTab", "signup");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
                return;
            }

            Customer newCustomer = new Customer();
            newCustomer.setName(name);
            newCustomer.setEmail(email);
            newCustomer.setPhone(phone);
            newCustomer.setPassword(password);
            newCustomer.setRole("CUSTOMER");

            boolean created = customerDAO.register(newCustomer);
            if (created) {
                session.setAttribute("user", newCustomer);
                session.setAttribute("userName", newCustomer.getName());
                session.setAttribute("userEmail", newCustomer.getEmail());
                session.setAttribute("userRole", newCustomer.getRole());

                response.sendRedirect(request.getContextPath() + "/home?msg=registered");
            } else {
                request.setAttribute("errorMessage", "An account with this email address already exists.");
                request.setAttribute("signupName", name);
                request.setAttribute("signupPhone", phone);
                request.setAttribute("activeTab", "signup");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            }
        }
    }
}
