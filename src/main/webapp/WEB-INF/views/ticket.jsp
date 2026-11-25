<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Download Ticket – CruiseBus Reservation</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ticket.css">
</head>
<body>

    <!-- Cinematic Backdrop from Reference Image 4 -->
    <div class="cinematic-bg" style="background-image: url('${pageContext.request.contextPath}/assets/images/ref_ticket.jpg');"></div>

    <!-- Header Navigation -->
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="ticket-page-container">

        <!-- Title Box (Matching Image 4) -->
        <div class="ticket-header-box">
            <h1 class="ticket-main-title">Download Ticket</h1>
            <p class="ticket-sub-title">Ready for your journey? Access and download your travel ticket here.</p>
        </div>

        <!-- Quick PNR Lookup Bar -->
        <form action="${pageContext.request.contextPath}/ticket" method="GET" class="ticket-search-box">
            <input type="text" name="pnr" class="ticket-search-input" placeholder="Search by Ticket ID / PNR (e.g. LA325478)..." value="${param.pnr}">
            <button type="submit" class="btn-glow" style="padding: 0.75rem 1.5rem; font-size: 0.85rem;">Track Ticket</button>
        </form>

        <!-- Flash messages -->
        <c:if test="${param.success == 'booked'}">
            <div class="flash-message flash-success" style="max-width: 820px; width: 100%;">
                <span>Booking confirmed successfully! Your seat reservation and ticket QR code are ready below.</span>
            </div>
        </c:if>
        <c:if test="${param.msg == 'cancelled'}">
            <div class="flash-message flash-error" style="max-width: 820px; width: 100%;">
                <span>Ticket has been cancelled. Your refund has been initiated to original payment source.</span>
            </div>
        </c:if>
        <c:if test="${not empty notFoundError}">
            <div class="flash-message flash-error" style="max-width: 820px; width: 100%;">
                <span>${notFoundError}</span>
            </div>
        </c:if>

        <c:choose>
            <c:when test="${not empty booking}">
                <!-- Main Reservation Details Card (Exact Image 4 reproduction) -->
                <div class="reservation-card-wrapper">
                    <div class="reservation-card" id="printable-ticket-card">

                        <!-- Left Info Column -->
                        <div class="reservation-info-col">
                            <div class="res-header-title">Reservation Details</div>

                            <!-- Source - Destination -->
                            <div class="res-route">
                                <c:choose>
                                    <c:when test="${not empty booking.schedule and not empty booking.schedule.route}">
                                        ${booking.schedule.route.source} - ${booking.schedule.route.destination}
                                    </c:when>
                                    <c:otherwise>Chennai - Bengaluru</c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Journey Date & Day -->
                            <div class="res-date">
                                <c:choose>
                                    <c:when test="${not empty booking.schedule and not empty booking.schedule.departureDate}">
                                        ${booking.schedule.departureDate}
                                    </c:when>
                                    <c:otherwise>14 Dec 2021, Monday</c:otherwise>
                                </c:choose>
                                <c:if test="${booking.bookingStatus == 'CANCELLED'}">
                                    <span class="badge-pill" style="background: rgba(239, 68, 68, 0.2); border: 1px solid #ef4444; color: #fca5a5; margin-left: 0.5rem;">CANCELLED</span>
                                </c:if>
                            </div>

                            <!-- 2-Column Grid -->
                            <div class="res-details-grid">
                                <!-- Bus Name -->
                                <div class="res-detail-item">
                                    <span class="res-detail-label">Bus Name</span>
                                    <span class="res-detail-value">
                                        ${not empty booking.schedule && not empty booking.schedule.bus ? booking.schedule.bus.busName : 'Bengaluru Express'}
                                    </span>
                                </div>

                                <!-- Seat Number -->
                                <div class="res-detail-item">
                                    <span class="res-detail-label">Seat Number</span>
                                    <span class="res-detail-value">${booking.seatsSummary}</span>
                                </div>

                                <!-- Ticket ID -->
                                <div class="res-detail-item">
                                    <span class="res-detail-label">Ticket ID</span>
                                    <span class="res-detail-value" style="color: #38bdf8;">${booking.ticketPnr}</span>
                                </div>

                                <!-- Bus Number -->
                                <div class="res-detail-item">
                                    <span class="res-detail-label">Bus Number</span>
                                    <span class="res-detail-value">
                                        ${not empty booking.schedule && not empty booking.schedule.bus ? booking.schedule.bus.busNumber : 'KA 01 FB 1234'}
                                    </span>
                                </div>

                                <!-- Arrival -->
                                <div class="res-detail-item">
                                    <span class="res-detail-label">Arrival</span>
                                    <span class="res-detail-value">
                                        ${not empty booking.schedule ? booking.schedule.departureTime : '04:59 pm'}
                                    </span>
                                </div>

                                <!-- Drop -->
                                <div class="res-detail-item">
                                    <span class="res-detail-label">Drop</span>
                                    <span class="res-detail-value">
                                        ${not empty booking.schedule ? booking.schedule.arrivalTime : '11:00 pm'}
                                    </span>
                                </div>
                            </div>

                            <!-- Total -->
                            <div class="res-total-row">
                                <span class="res-total-label">Total:</span>
                                <span class="res-total-amount">
                                    ₹ <fmt:formatNumber value="${booking.totalAmount}" pattern="#,##0.00" />
                                </span>
                            </div>

                            <!-- Actions Row -->
                            <div class="res-actions-row">
                                <c:choose>
                                    <c:when test="${booking.bookingStatus != 'CANCELLED'}">
                                        <form action="${pageContext.request.contextPath}/ticket" method="POST" onsubmit="return confirm('Are you sure you want to cancel Ticket ${booking.ticketPnr}? A full refund will be processed to your account.');" style="flex: 1;">
                                            <input type="hidden" name="action" value="cancel">
                                            <input type="hidden" name="pnr" value="${booking.ticketPnr}">
                                            <button type="submit" class="btn-card-cancel" style="width: 100%;">Cancel</button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="btn-card-cancel" disabled style="opacity: 0.5; cursor: not-allowed; flex: 1;">Cancelled</button>
                                    </c:otherwise>
                                </c:choose>

                                <button type="button" onclick="downloadTicketPDF()" class="btn-card-download">Download</button>
                            </div>
                        </div>

                        <!-- Right QR Column -->
                        <div class="reservation-qr-col">
                            <div class="qr-box" id="qr-code-container">
                                <!-- Sharp dynamic QR code rendered via JS -->
                            </div>
                            <div class="qr-caption">Note: Just show your QR code while boarding the bus.</div>
                        </div>

                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="reservation-card-wrapper">
                    <div class="reservation-card" style="text-align: center; justify-content: center; padding: 3rem;">
                        <p class="card-text">Enter your Ticket ID above or select a booking to view reservation voucher.</p>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>

    </main>

    <!-- Footer -->
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <script src="${pageContext.request.contextPath}/assets/js/ticket.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const qrData = "${not empty booking && not empty booking.ticket ? booking.ticket.qrCodeData : 'CRUISEBUS-TICKET:LA325478|SEATS:06,07|BUS:KA01FB1234|ROUTE:Chennai-Bengaluru|FARE:4020.00'}";
            renderQRCode('qr-code-container', qrData);
        });
    </script>
</body>
</html>
