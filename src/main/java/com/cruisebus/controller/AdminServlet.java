package com.cruisebus.controller;

import com.cruisebus.dao.*;
import com.cruisebus.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.util.List;

@WebServlet(name = "AdminServlet", urlPatterns = {"/admin", "/admin/*"})
public class AdminServlet extends HttpServlet {
    private final BusDAO busDAO = new BusDAO();
    private final RouteDAO routeDAO = new RouteDAO();
    private final ScheduleDAO scheduleDAO = new ScheduleDAO();
    private final BookingDAO bookingDAO = new BookingDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();
    private final ContactMessageDAO messageDAO = new ContactMessageDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Customer user = (Customer) session.getAttribute("user");

        // Allow demo primary admin auto-login if requested or check role
        if (user == null || !user.isAdmin()) {
            String auto = request.getParameter("demo_admin");
            if ("true".equalsIgnoreCase(auto)) {
                user = customerDAO.findByEmail("admin@cruisebus.in");
                if (user != null) {
                    session.setAttribute("user", user);
                    session.setAttribute("userName", user.getName());
                    session.setAttribute("userEmail", user.getEmail());
                    session.setAttribute("userRole", user.getRole());
                }
            } else {
                session.setAttribute("redirectAfterLogin", request.getContextPath() + "/admin");
                response.sendRedirect(request.getContextPath() + "/auth?tab=login&msg=admin_required");
                return;
            }
        }

        String action = request.getParameter("view");
        if (action == null) action = "dashboard";

        switch (action.toLowerCase()) {
            case "buses":
                request.setAttribute("buses", busDAO.getAllBuses());
                request.getRequestDispatcher("/WEB-INF/views/admin/buses.jsp").forward(request, response);
                break;
            case "routes":
                request.setAttribute("routes", routeDAO.getAllRoutes());
                request.getRequestDispatcher("/WEB-INF/views/admin/routes.jsp").forward(request, response);
                break;
            case "schedules":
                request.setAttribute("schedules", scheduleDAO.getAllSchedules());
                request.setAttribute("buses", busDAO.getAllBuses());
                request.setAttribute("routes", routeDAO.getAllRoutes());
                request.getRequestDispatcher("/WEB-INF/views/admin/schedules.jsp").forward(request, response);
                break;
            case "bookings":
                request.setAttribute("bookings", bookingDAO.getAllBookings());
                request.getRequestDispatcher("/WEB-INF/views/admin/bookings.jsp").forward(request, response);
                break;
            case "customers":
                request.setAttribute("customers", customerDAO.getAllCustomers());
                request.getRequestDispatcher("/WEB-INF/views/admin/customers.jsp").forward(request, response);
                break;
            case "messages":
                request.setAttribute("messages", messageDAO.getAllMessages());
                request.getRequestDispatcher("/WEB-INF/views/admin/messages.jsp").forward(request, response);
                break;
            case "dashboard":
            default:
                List<Bus> buses = busDAO.getAllBuses();
                List<Route> routes = routeDAO.getAllRoutes();
                List<Booking> bookings = bookingDAO.getAllBookings();
                List<Customer> customers = customerDAO.getAllCustomers();
                List<ContactMessage> messages = messageDAO.getAllMessages();

                double totalRevenue = 0;
                int activeBookings = 0;
                for (Booking b : bookings) {
                    if ("CONFIRMED".equalsIgnoreCase(b.getBookingStatus())) {
                        totalRevenue += b.getTotalAmount();
                        activeBookings++;
                    }
                }

                request.setAttribute("totalBuses", buses.size());
                request.setAttribute("totalRoutes", routes.size());
                request.setAttribute("totalBookings", bookings.size());
                request.setAttribute("activeBookings", activeBookings);
                request.setAttribute("totalRevenue", totalRevenue);
                request.setAttribute("totalCustomers", customers.size());
                request.setAttribute("totalMessages", messages.size());
                request.setAttribute("recentBookings", bookings.size() > 5 ? bookings.subList(0, 5) : bookings);

                request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Customer user = (Customer) session.getAttribute("user");
        if (user == null || !user.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin");
            return;
        }

        switch (action.toLowerCase()) {
            case "add_bus": {
                Bus b = new Bus();
                b.setBusName(request.getParameter("busName"));
                b.setOperator(request.getParameter("operator"));
                b.setBusNumber(request.getParameter("busNumber"));
                b.setBusType(request.getParameter("busType"));
                b.setTotalSeats(Integer.parseInt(request.getParameter("totalSeats")));
                b.setFuelType(request.getParameter("fuelType"));
                b.setTransmission(request.getParameter("transmission"));
                b.setImageUrl(request.getParameter("imageUrl"));
                busDAO.addBus(b);
                response.sendRedirect(request.getContextPath() + "/admin?view=buses&msg=bus_added");
                break;
            }
            case "delete_bus": {
                int busId = Integer.parseInt(request.getParameter("busId"));
                busDAO.deleteBus(busId);
                response.sendRedirect(request.getContextPath() + "/admin?view=buses&msg=bus_deleted");
                break;
            }
            case "add_route": {
                Route r = new Route();
                r.setSource(request.getParameter("source"));
                r.setDestination(request.getParameter("destination"));
                r.setDistance(Integer.parseInt(request.getParameter("distance")));
                routeDAO.addRoute(r);
                response.sendRedirect(request.getContextPath() + "/admin?view=routes&msg=route_added");
                break;
            }
            case "delete_route": {
                int routeId = Integer.parseInt(request.getParameter("routeId"));
                routeDAO.deleteRoute(routeId);
                response.sendRedirect(request.getContextPath() + "/admin?view=routes&msg=route_deleted");
                break;
            }
            case "add_schedule": {
                Schedule s = new Schedule();
                s.setBusId(Integer.parseInt(request.getParameter("busId")));
                s.setRouteId(Integer.parseInt(request.getParameter("routeId")));
                s.setDepartureDate(Date.valueOf(request.getParameter("departureDate")));
                s.setDepartureTime(Time.valueOf(request.getParameter("departureTime") + ":00"));
                s.setArrivalTime(Time.valueOf(request.getParameter("arrivalTime") + ":00"));
                s.setFare(Double.parseDouble(request.getParameter("fare")));
                scheduleDAO.addSchedule(s);
                response.sendRedirect(request.getContextPath() + "/admin?view=schedules&msg=schedule_added");
                break;
            }
            case "delete_schedule": {
                int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
                scheduleDAO.deleteSchedule(scheduleId);
                response.sendRedirect(request.getContextPath() + "/admin?view=schedules&msg=schedule_deleted");
                break;
            }
            case "update_booking_status": {
                int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                String status = request.getParameter("status");
                bookingDAO.updateBookingStatus(bookingId, status);
                response.sendRedirect(request.getContextPath() + "/admin?view=bookings&msg=status_updated");
                break;
            }
            default:
                response.sendRedirect(request.getContextPath() + "/admin");
                break;
        }
    }
}
