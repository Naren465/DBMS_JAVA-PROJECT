package com.cruisebus.controller;

import com.cruisebus.dao.ScheduleDAO;
import com.cruisebus.dao.SeatDAO;
import com.cruisebus.model.Schedule;
import com.cruisebus.model.Seat;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "SeatSelectionServlet", urlPatterns = {"/seats", "/select-seat"})
public class SeatSelectionServlet extends HttpServlet {
    private final ScheduleDAO scheduleDAO = new ScheduleDAO();
    private final SeatDAO seatDAO = new SeatDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String scheduleIdParam = request.getParameter("scheduleId");
        if (scheduleIdParam == null || scheduleIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/search");
            return;
        }

        try {
            int scheduleId = Integer.parseInt(scheduleIdParam.trim());
            Schedule schedule = scheduleDAO.getScheduleById(scheduleId);
            if (schedule == null) {
                response.sendRedirect(request.getContextPath() + "/search?error=schedule_not_found");
                return;
            }

            List<Seat> seats = seatDAO.getSeatsByBusAndSchedule(schedule.getBusId(), scheduleId);

            request.setAttribute("schedule", schedule);
            request.setAttribute("seats", seats);
            request.setAttribute("activeNav", "browse");

            request.getRequestDispatcher("/WEB-INF/views/seat-selection.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/search");
        }
    }
}
