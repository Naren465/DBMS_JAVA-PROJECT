<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Messages – CruiseBus Admin</title>
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
            <a href="${pageContext.request.contextPath}/admin?view=bookings" class="admin-nav-item">Reservations & PNRs</a>
            <a href="${pageContext.request.contextPath}/admin?view=customers" class="admin-nav-item">Registered Customers</a>
            <a href="${pageContext.request.contextPath}/admin?view=messages" class="admin-nav-item active">Customer Messages</a>
            <div style="margin-top: auto; padding-top: 1rem; border-top: 1px solid rgba(255, 255, 255, 0.1);">
                <a href="${pageContext.request.contextPath}/home" class="admin-nav-item" style="color: #38bdf8;">&larr; Exit to Public Website</a>
            </div>
        </aside>

        <main class="admin-content">
            <h1 style="font-family: var(--font-heading); font-size: 2rem; font-weight: 800; color: #fff; margin-bottom: 1.5rem;">Incoming Customer Inquiries</h1>

            <div class="admin-table-card">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Msg ID</th>
                            <th>Sender Name</th>
                            <th>Contact Email / Phone</th>
                            <th>Subject</th>
                            <th>Message Content</th>
                            <th>Submitted At</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="msg" items="${messages}">
                            <tr>
                                <td>#${msg.messageId}</td>
                                <td style="font-weight: 700; color: #fff;">${msg.name}</td>
                                <td>${msg.email}<br><span style="font-size: 0.75rem; color: var(--text-muted);">${msg.phone}</span></td>
                                <td style="font-weight: 600; color: #38bdf8;">${msg.subject}</td>
                                <td style="max-width: 320px; line-height: 1.4;">${msg.message}</td>
                                <td>${msg.submittedAt}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty messages}">
                            <tr>
                                <td colspan="6" style="text-align: center; padding: 2rem;">No messages submitted yet.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</body>
</html>
