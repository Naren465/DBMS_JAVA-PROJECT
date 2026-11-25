package com.cruisebus.controller;

import com.cruisebus.dao.RouteDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeServlet", urlPatterns = {"", "/home"})
public class HomeServlet extends HttpServlet {
    private final RouteDAO routeDAO = new RouteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<String> sources = routeDAO.getDistinctSources();
        List<String> destinations = routeDAO.getDistinctDestinations();

        request.setAttribute("sources", sources);
        request.setAttribute("destinations", destinations);
        request.setAttribute("activeNav", "home");

        request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);
    }
}
