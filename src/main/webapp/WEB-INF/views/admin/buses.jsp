<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Fleet & Buses Management – CruiseBus Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    <div class="admin-layout">
        <aside class="admin-sidebar">
            <div style="font-size: 0.75rem; letter-spacing: 0.1em; color: var(--text-muted); text-transform: uppercase; margin-bottom: 0.75rem;">SYSTEM MANAGEMENT</div>
            <a href="${pageContext.request.contextPath}/admin?view=dashboard" class="admin-nav-item">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin?view=buses" class="admin-nav-item active">Fleet & Buses</a>
            <a href="${pageContext.request.contextPath}/admin?view=routes" class="admin-nav-item">Transit Routes</a>
            <a href="${pageContext.request.contextPath}/admin?view=schedules" class="admin-nav-item">Schedules & Fares</a>
            <a href="${pageContext.request.contextPath}/admin?view=bookings" class="admin-nav-item">Reservations & PNRs</a>
            <a href="${pageContext.request.contextPath}/admin?view=customers" class="admin-nav-item">Registered Customers</a>
            <a href="${pageContext.request.contextPath}/admin?view=messages" class="admin-nav-item">Customer Messages</a>
            <div style="margin-top: auto; padding-top: 1rem; border-top: 1px solid rgba(255, 255, 255, 0.1);">
                <a href="${pageContext.request.contextPath}/home" class="admin-nav-item" style="color: #38bdf8;">&larr; Exit to Public Website</a>
            </div>
        </aside>

        <main class="admin-content">
            <h1 style="font-family: var(--font-heading); font-size: 2rem; font-weight: 800; color: #fff; margin-bottom: 1.5rem;">Bus Fleet Management</h1>

            <!-- Add Bus Form Card -->
            <div class="admin-table-card" style="margin-bottom: 2rem;">
                <h3 style="font-size: 1.15rem; color: #fff; margin-bottom: 1.25rem;">Register New Luxury Coach</h3>
                <form action="${pageContext.request.contextPath}/admin" method="POST" style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 1rem;">
                    <input type="hidden" name="action" value="add_bus">
                    <div class="form-group">
                        <label class="form-label">Bus Model Name</label>
                        <input type="text" name="busName" class="form-control" placeholder="e.g. Volvo 9600 Multi-Axle" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Operator</label>
                        <input type="text" name="operator" class="form-control" placeholder="e.g. Volvo Buses" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Registration Number</label>
                        <input type="text" name="busNumber" class="form-control" placeholder="e.g. KA 01 FB 9988" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Bus Type</label>
                        <select name="busType" class="form-control">
                            <option value="AC Sleeper">AC Sleeper</option>
                            <option value="AC Seater">AC Seater</option>
                            <option value="Non AC Seater">Non AC Seater</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Total Seats</label>
                        <input type="number" name="totalSeats" class="form-control" value="36" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Fuel Type</label>
                        <input type="text" name="fuelType" class="form-control" value="Diesel" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Transmission</label>
                        <select name="transmission" class="form-control">
                            <option value="Automatic">Automatic</option>
                            <option value="Manual">Manual</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Image URL</label>
                        <input type="text" name="imageUrl" class="form-control" value="assets/images/bus_volvo.jpg">
                    </div>
                    <div style="grid-column: span 4;">
                        <button type="submit" class="btn-glow" style="padding: 0.65rem 2rem;">Add Coach to Fleet</button>
                    </div>
                </form>
            </div>

            <!-- Existing Buses Table -->
            <div class="admin-table-card">
                <h3 style="font-size: 1.15rem; color: #fff; margin-bottom: 1rem;">Fleet Registry</h3>
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Model</th>
                            <th>Operator</th>
                            <th>Bus Number</th>
                            <th>Type</th>
                            <th>Seats</th>
                            <th>Specs</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="bus" items="${buses}">
                            <tr>
                                <td>#${bus.busId}</td>
                                <td style="font-weight: 700; color: #fff;">${bus.busName}</td>
                                <td>${bus.operator}</td>
                                <td style="color: #38bdf8;">${bus.busNumber}</td>
                                <td><span class="badge-pill badge-blue">${bus.busType}</span></td>
                                <td>${bus.totalSeats} seats</td>
                                <td>${bus.fuelType} • ${bus.transmission}</td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/admin" method="POST" onsubmit="return confirm('Delete bus ${bus.busName}?');" style="display:inline;">
                                        <input type="hidden" name="action" value="delete_bus">
                                        <input type="hidden" name="busId" value="${bus.busId}">
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
