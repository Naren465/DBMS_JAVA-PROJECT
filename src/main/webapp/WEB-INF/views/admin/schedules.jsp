<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Schedules & Fares – CruiseBus Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    <div class="admin-layout">
        <aside class="admin-sidebar">
            <div style="font-size: 0.75rem; letter-spacing: 0.1em; color: var(--text-muted); text-transform: uppercase; margin-bottom: 0.75rem;">SYSTEM MANAGEMENT</div>
            <a href="${pageContext.request.contextPath}/admin?view=dashboard" class="admin-nav-item">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin?view=buses" class="admin-nav-item">Fleet & Buses</a>
            <a href="${pageContext.request.contextPath}/admin?view=routes" class="admin-nav-item">Transit Routes</a>
            <a href="${pageContext.request.contextPath}/admin?view=schedules" class="admin-nav-item active">Schedules & Fares</a>
            <a href="${pageContext.request.contextPath}/admin?view=bookings" class="admin-nav-item">Reservations & PNRs</a>
            <a href="${pageContext.request.contextPath}/admin?view=customers" class="admin-nav-item">Registered Customers</a>
            <a href="${pageContext.request.contextPath}/admin?view=messages" class="admin-nav-item">Customer Messages</a>
            <div style="margin-top: auto; padding-top: 1rem; border-top: 1px solid rgba(255, 255, 255, 0.1);">
                <a href="${pageContext.request.contextPath}/home" class="admin-nav-item" style="color: #38bdf8;">&larr; Exit to Public Website</a>
            </div>
        </aside>

        <main class="admin-content">
            <h1 style="font-family: var(--font-heading); font-size: 2rem; font-weight: 800; color: #fff; margin-bottom: 1.5rem;">Schedules & Pricing</h1>

            <!-- Add Schedule Form Card -->
            <div class="admin-table-card" style="margin-bottom: 2rem;">
                <h3 style="font-size: 1.15rem; color: #fff; margin-bottom: 1.25rem;">Deploy Coach to Route Schedule</h3>
                <form action="${pageContext.request.contextPath}/admin" method="POST" style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 1rem;">
                    <input type="hidden" name="action" value="add_schedule">
                    <div class="form-group">
                        <label class="form-label">Assign Bus</label>
                        <select name="busId" class="form-control" required>
                            <c:forEach var="b" items="${buses}">
                                <option value="${b.busId}">${b.busName} (${b.operator} - ${b.busNumber})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Assign Route</label>
                        <select name="routeId" class="form-control" required>
                            <c:forEach var="r" items="${routes}">
                                <option value="${r.routeId}">${r.source} &rarr; ${r.destination} (${r.distance} km)</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Departure Date</label>
                        <input type="date" name="departureDate" class="form-control" value="${java.time.LocalDate.now()}" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Departure Time</label>
                        <input type="time" name="departureTime" class="form-control" value="06:00" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Arrival Time</label>
                        <input type="time" name="arrivalTime" class="form-control" value="12:30" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Ticket Fare (₹)</label>
                        <input type="number" step="0.01" name="fare" class="form-control" value="1200.00" required>
                    </div>
                    <div style="grid-column: span 3;">
                        <button type="submit" class="btn-glow" style="padding: 0.65rem 2rem;">Publish Schedule</button>
                    </div>
                </form>
            </div>

            <!-- Existing Schedules Table -->
            <div class="admin-table-card">
                <h3 style="font-size: 1.15rem; color: #fff; margin-bottom: 1rem;">Live Operating Schedules</h3>
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Sched ID</th>
                            <th>Bus Model</th>
                            <th>Route</th>
                            <th>Departure Date</th>
                            <th>Timings (Dep - Arr)</th>
                            <th>Fare</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="s" items="${schedules}">
                            <tr>
                                <td>#${s.scheduleId}</td>
                                <td style="font-weight: 700; color: #fff;">${s.bus.busName} (${s.bus.operator})</td>
                                <td>${s.route.source} &rarr; ${s.route.destination}</td>
                                <td>${s.departureDate}</td>
                                <td>${s.departureTime} &rarr; ${s.arrivalTime}</td>
                                <td style="color: #38bdf8; font-weight: 700;">₹ <fmt:formatNumber value="${s.fare}" pattern="#,##0.00" /></td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/admin" method="POST" onsubmit="return confirm('Delete schedule #${s.scheduleId}?');" style="display:inline;">
                                        <input type="hidden" name="action" value="delete_schedule">
                                        <input type="hidden" name="scheduleId" value="${s.scheduleId}">
                                        <button type="submit" class="btn-admin-action btn-admin-danger">Delete</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</body>
</html>
