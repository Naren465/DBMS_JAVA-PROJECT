<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Transit Routes – CruiseBus Admin</title>
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
            <a href="${pageContext.request.contextPath}/admin?view=routes" class="admin-nav-item active">Transit Routes</a>
            <a href="${pageContext.request.contextPath}/admin?view=schedules" class="admin-nav-item">Schedules & Fares</a>
            <a href="${pageContext.request.contextPath}/admin?view=bookings" class="admin-nav-item">Reservations & PNRs</a>
            <a href="${pageContext.request.contextPath}/admin?view=customers" class="admin-nav-item">Registered Customers</a>
            <a href="${pageContext.request.contextPath}/admin?view=messages" class="admin-nav-item">Customer Messages</a>
            <div style="margin-top: auto; padding-top: 1rem; border-top: 1px solid rgba(255, 255, 255, 0.1);">
                <a href="${pageContext.request.contextPath}/home" class="admin-nav-item" style="color: #38bdf8;">&larr; Exit to Public Website</a>
            </div>
        </aside>

        <main class="admin-content">
            <h1 style="font-family: var(--font-heading); font-size: 2rem; font-weight: 800; color: #fff; margin-bottom: 1.5rem;">Transit Routes Network</h1>

            <!-- Add Route Form Card -->
            <div class="admin-table-card" style="margin-bottom: 2rem;">
                <h3 style="font-size: 1.15rem; color: #fff; margin-bottom: 1.25rem;">Create New Inter-City Route</h3>
                <form action="${pageContext.request.contextPath}/admin" method="POST" style="display: grid; grid-template-columns: repeat(3, 1fr) auto; gap: 1rem; align-items: flex-end;">
                    <input type="hidden" name="action" value="add_route">
                    <div class="form-group">
                        <label class="form-label">Departure Hub (Source)</label>
                        <input type="text" name="source" class="form-control" placeholder="e.g. Chennai" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Destination Hub</label>
                        <input type="text" name="destination" class="form-control" placeholder="e.g. Bengaluru" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Distance (km)</label>
                        <input type="number" name="distance" class="form-control" placeholder="e.g. 350" required>
                    </div>
                    <div>
                        <button type="submit" class="btn-glow" style="padding: 0.85rem 2rem;">Add Route</button>
                    </div>
                </form>
            </div>

            <!-- Existing Routes Table -->
            <div class="admin-table-card">
                <h3 style="font-size: 1.15rem; color: #fff; margin-bottom: 1rem;">Active Routes</h3>
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Route ID</th>
                            <th>Origin Source</th>
                            <th>Destination Hub</th>
                            <th>Distance</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="r" items="${routes}">
                            <tr>
                                <td>#${r.routeId}</td>
                                <td style="font-weight: 700; color: #fff;">${r.source}</td>
                                <td style="font-weight: 700; color: #fff;">${r.destination}</td>
                                <td>${r.distance} km</td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/admin" method="POST" onsubmit="return confirm('Delete route ${r.source} - ${r.destination}?');" style="display:inline;">
                                        <input type="hidden" name="action" value="delete_route">
                                        <input type="hidden" name="routeId" value="${r.routeId}">
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
