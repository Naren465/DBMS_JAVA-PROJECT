<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reservations & Bookings – CruiseBus Admin</title>
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
            <a href="${pageContext.request.contextPath}/admin?view=schedules" class="admin-nav-item">Schedules & Fares</a>
            <a href="${pageContext.request.contextPath}/admin?view=bookings" class="admin-nav-item active">Reservations & PNRs</a>
            <a href="${pageContext.request.contextPath}/admin?view=customers" class="admin-nav-item">Registered Customers</a>
            <a href="${pageContext.request.contextPath}/admin?view=messages" class="admin-nav-item">Customer Messages</a>
            <div style="margin-top: auto; padding-top: 1rem; border-top: 1px solid rgba(255, 255, 255, 0.1);">
                <a href="${pageContext.request.contextPath}/home" class="admin-nav-item" style="color: #38bdf8;">&larr; Exit to Public Website</a>
            </div>
        </aside>

        <main class="admin-content">
            <h1 style="font-family: var(--font-heading); font-size: 2rem; font-weight: 800; color: #fff; margin-bottom: 1.5rem;">All Passenger Reservations</h1>

            <div class="admin-table-card">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>PNR / Ticket ID</th>
                            <th>Customer Name</th>
                            <th>Contact</th>
                            <th>Route</th>
                            <th>Date</th>
                            <th>Seats</th>
                            <th>Amount</th>
                            <th>Status</th>
                            <th>Manage Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="b" items="${bookings}">
                            <tr>
                                <td style="font-weight: 700; color: #38bdf8;">${b.ticketPnr}</td>
                                <td style="font-weight: 600; color: #fff;">${b.customer.name}</td>
                                <td>${b.customer.phone}</td>
                                <td>${b.schedule.route.source} &rarr; ${b.schedule.route.destination}</td>
                                <td>${b.schedule.departureDate}</td>
                                <td>${b.seatsSummary}</td>
                                <td style="font-weight: 700; color: #fff;">₹ <fmt:formatNumber value="${b.totalAmount}" pattern="#,##0.00" /></td>
                                <td>
                                    <span class="badge-pill ${b.bookingStatus == 'CONFIRMED' ? 'badge-green' : 'badge-yellow'}">
                                        ${b.bookingStatus}
                                    </span>
                                </td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/admin" method="POST" style="display:inline-flex; gap: 0.35rem;">
                                        <input type="hidden" name="action" value="update_booking_status">
                                        <input type="hidden" name="bookingId" value="${b.bookingId}">
                                        <select name="status" class="form-control" style="padding: 0.25rem 0.5rem; font-size: 0.75rem;">
                                            <option value="CONFIRMED" ${b.bookingStatus == 'CONFIRMED' ? 'selected' : ''}>CONFIRMED</option>
                                            <option value="CANCELLED" ${b.bookingStatus == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                                        </select>
                                        <button type="submit" class="btn-admin-action">Update</button>
                                    </form>
                                    <a href="${pageContext.request.contextPath}/ticket?pnr=${b.ticketPnr}" target="_blank" class="btn-admin-action" style="margin-left: 0.35rem;">Voucher</a>
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
