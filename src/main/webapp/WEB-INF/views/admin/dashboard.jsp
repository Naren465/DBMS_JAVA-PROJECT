<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard – CruiseBus Control Center</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>

    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <div class="admin-layout">
        
        <!-- Sidebar -->
        <aside class="admin-sidebar">
            <div style="font-size: 0.75rem; letter-spacing: 0.1em; color: var(--text-muted); text-transform: uppercase; margin-bottom: 0.75rem; padding-left: 0.5rem;">
                SYSTEM MANAGEMENT
            </div>
            <a href="${pageContext.request.contextPath}/admin?view=dashboard" class="admin-nav-item active">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin?view=buses" class="admin-nav-item">Fleet & Buses</a>
            <a href="${pageContext.request.contextPath}/admin?view=routes" class="admin-nav-item">Transit Routes</a>
            <a href="${pageContext.request.contextPath}/admin?view=schedules" class="admin-nav-item">Schedules & Fares</a>
            <a href="${pageContext.request.contextPath}/admin?view=bookings" class="admin-nav-item">Reservations & PNRs</a>
            <a href="${pageContext.request.contextPath}/admin?view=customers" class="admin-nav-item">Registered Customers</a>
            <a href="${pageContext.request.contextPath}/admin?view=messages" class="admin-nav-item">Customer Messages</a>
            <div style="margin-top: auto; padding-top: 1rem; border-top: 1px solid rgba(255, 255, 255, 0.1);">
                <a href="${pageContext.request.contextPath}/home" class="admin-nav-item" style="color: #38bdf8;">&larr; Exit to Public Website</a>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="admin-content">
            <div style="margin-bottom: 2rem;">
                <h1 style="font-family: var(--font-heading); font-size: 2.2rem; font-weight: 800; color: #fff;">System Overview</h1>
                <p style="color: var(--text-muted); font-size: 0.95rem;">Real-time metrics, fleet availability and reservation status.</p>
            </div>

            <!-- KPI Cards Grid -->
            <div class="kpi-cards-grid">
                <div class="kpi-card">
                    <span class="kpi-title">Active Fleet</span>
                    <span class="kpi-value">${totalBuses}</span>
                    <span style="font-size: 0.8rem; color: #38bdf8;">Across all operators</span>
                </div>
                <div class="kpi-card">
                    <span class="kpi-title">Active Routes</span>
                    <span class="kpi-value">${totalRoutes}</span>
                    <span style="font-size: 0.8rem; color: #38bdf8;">Interstate network</span>
                </div>
                <div class="kpi-card">
                    <span class="kpi-title">Total Bookings</span>
                    <span class="kpi-value">${totalBookings}</span>
                    <span style="font-size: 0.8rem; color: #4ade80;">${activeBookings} Confirmed</span>
                </div>
                <div class="kpi-card">
                    <span class="kpi-title">Total Revenue</span>
                    <span class="kpi-value" style="color: #38bdf8;">₹ <fmt:formatNumber value="${totalRevenue}" pattern="#,##0" /></span>
                    <span style="font-size: 0.8rem; color: #4ade80;">Processed successfully</span>
                </div>
            </div>

            <!-- Recent Bookings Table -->
            <div class="admin-table-card">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                    <h2 style="font-family: var(--font-heading); font-size: 1.35rem; color: #fff;">Recent Bookings</h2>
                    <a href="${pageContext.request.contextPath}/admin?view=bookings" class="btn-admin-action">View All Bookings</a>
                </div>

                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Ticket PNR</th>
                            <th>Passenger</th>
                            <th>Route</th>
                            <th>Date & Time</th>
                            <th>Seats</th>
                            <th>Amount</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="b" items="${recentBookings}">
                            <tr>
                                <td style="font-weight: 700; color: #38bdf8;">${b.ticketPnr}</td>
                                <td>${b.customer.name}</td>
                                <td>${b.schedule.route.source} &rarr; ${b.schedule.route.destination}</td>
                                <td>${b.schedule.departureDate} (${b.schedule.departureTime})</td>
                                <td>${b.seatsSummary}</td>
                                <td style="font-weight: 700; color: #fff;">₹ <fmt:formatNumber value="${b.totalAmount}" pattern="#,##0.00" /></td>
                                <td>
                                    <span class="badge-pill ${b.bookingStatus == 'CONFIRMED' ? 'badge-green' : 'badge-yellow'}">
                                        ${b.bookingStatus}
                                    </span>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/ticket?pnr=${b.ticketPnr}" target="_blank" class="btn-admin-action">View Ticket</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty recentBookings}">
                            <tr>
                                <td colspan="8" style="text-align: center; padding: 2rem;">No recent reservations.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

        </main>

    </div>

</body>
</html>
