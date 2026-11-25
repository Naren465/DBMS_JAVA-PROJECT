package com.cruisebus.controller;

import com.cruisebus.dao.BusDAO;
import com.cruisebus.dao.RouteDAO;
import com.cruisebus.dao.ScheduleDAO;
import com.cruisebus.model.Schedule;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@WebServlet(name = "SearchBusServlet", urlPatterns = {"/search", "/buses"})
public class SearchBusServlet extends HttpServlet {
    private final ScheduleDAO scheduleDAO = new ScheduleDAO();
    private final BusDAO busDAO = new BusDAO();
    private final RouteDAO routeDAO = new RouteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processSearch(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processSearch(request, response);
    }

    private void processSearch(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String source = request.getParameter("from");
        String destination = request.getParameter("to");
        String date = request.getParameter("date");
        String modelQuery = request.getParameter("model");
        String sortBy = request.getParameter("sort");

        // Multi-value filters
        String[] operatorArr = request.getParameterValues("operator");
        List<String> operators = (operatorArr != null && operatorArr.length > 0) ? Arrays.asList(operatorArr) : new ArrayList<>();

        String[] busTypeArr = request.getParameterValues("busType");
        List<String> busTypes = (busTypeArr != null && busTypeArr.length > 0) ? Arrays.asList(busTypeArr) : new ArrayList<>();

        String[] priceRanges = request.getParameterValues("priceRange");
        Double minPrice = null;
        Double maxPrice = null;

        if (priceRanges != null && priceRanges.length > 0) {
            for (String pr : priceRanges) {
                if ("0-500".equals(pr)) {
                    if (minPrice == null || minPrice > 0) minPrice = 0.0;
                    if (maxPrice == null || maxPrice < 500) maxPrice = 500.0;
                } else if ("500-1000".equals(pr)) {
                    if (minPrice == null || minPrice > 500) minPrice = 500.0;
                    if (maxPrice == null || maxPrice < 1000) maxPrice = 1000.0;
                } else if ("1000-1500".equals(pr)) {
                    if (minPrice == null || minPrice > 1000) minPrice = 1000.0;
                    if (maxPrice == null || maxPrice < 1500) maxPrice = 1500.0;
                } else if ("1500+".equals(pr)) {
                    if (minPrice == null || minPrice > 1500) minPrice = 1500.0;
                    // no max limit
                }
            }
        }

        List<Schedule> schedules = scheduleDAO.searchSchedules(
            source, destination, date, operators, busTypes, minPrice, maxPrice, modelQuery, sortBy
        );

        // Reference / fallback: if specific filter returned empty because of date, fall back to route to show available buses
        if (schedules.isEmpty() && (date != null && !date.trim().isEmpty())) {
            schedules = scheduleDAO.searchSchedules(
                source, destination, null, operators, busTypes, minPrice, maxPrice, modelQuery, sortBy
            );
            request.setAttribute("dateFallbackNotice", true);
        }

        // Context data for filters
        request.setAttribute("schedules", schedules);
        request.setAttribute("totalCount", schedules.size());
        request.setAttribute("selectedFrom", source);
        request.setAttribute("selectedTo", destination);
        request.setAttribute("selectedDate", date);
        request.setAttribute("selectedModel", modelQuery);
        request.setAttribute("selectedSort", sortBy);
        request.setAttribute("selectedOperators", operators);
        request.setAttribute("selectedBusTypes", busTypes);
        request.setAttribute("selectedPriceRanges", priceRanges != null ? Arrays.asList(priceRanges) : new ArrayList<>());

        request.setAttribute("allOperators", busDAO.getDistinctOperators());
        request.setAttribute("allBusTypes", busDAO.getDistinctBusTypes());
        request.setAttribute("sources", routeDAO.getDistinctSources());
        request.setAttribute("destinations", routeDAO.getDistinctDestinations());
        request.setAttribute("activeNav", "browse");

        request.getRequestDispatcher("/WEB-INF/views/search.jsp").forward(request, response);
    }
}
