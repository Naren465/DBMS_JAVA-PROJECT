<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Select Seats – ${schedule.bus.busName} | CruiseBus</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/seat-selection.css">
</head>
<body>

    <div class="cinematic-bg" style="background-image: url('${pageContext.request.contextPath}/assets/images/ref_search.jpg'); background-position: center top;"></div>

    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="seat-page-container">

        <!-- Error Notification -->
        <c:if test="${not empty errorMessage}">
            <div class="flash-message flash-error">
                <span>${errorMessage}</span>
            </div>
        </c:if>

        <!-- Seat Layout Row -->
        <div class="seat-layout-wrapper">

            <!-- Left Bus Layout -->
            <div class="bus-seat-card">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                    <div>
                        <h2 style="font-family: var(--font-heading); font-size: 1.5rem; color: #fff;">${schedule.bus.busName}</h2>
                        <div style="color: var(--text-muted); font-size: 0.85rem;">${schedule.bus.operator} • ${schedule.bus.busType} • ${schedule.bus.busNumber}</div>
                    </div>
                    <div style="text-align: right;">
                        <div style="font-size: 0.8rem; color: var(--text-muted);">Fare / Seat</div>
                        <div style="font-size: 1.35rem; font-weight: 800; color: #38bdf8;">₹ <fmt:formatNumber value="${schedule.fare}" pattern="#,##0" /></div>
                    </div>
                </div>

                <!-- Deck Tabs -->
                <div class="bus-deck-tabs">
                    <button type="button" class="btn-deck-tab active" data-deck="ALL">All Decks</button>
                    <button type="button" class="btn-deck-tab" data-deck="LOWER">Lower Deck</button>
                    <button type="button" class="btn-deck-tab" data-deck="UPPER">Upper Deck</button>
                </div>

                <!-- Bus Cabin -->
                <div class="bus-cabin">
                    <!-- Front Cabin with Driver Steering -->
                    <div class="bus-front-header">
                        <span style="font-size: 0.75rem; letter-spacing: 0.1em; color: var(--text-muted); text-transform: uppercase;">FRONT / ENTRANCE</span>
                        <div class="bus-driver-wheel" title="Driver Cabin">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor">
                                <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8 0-1.85.63-3.55 1.69-4.9L12 11.5l6.31-4.4C19.37 8.45 20 10.15 20 12c0 4.41-3.59 8-8 8zm-1-8.5V6.08c.33-.05.66-.08 1-.08s.67.03 1 .08v5.42L11 11.5z"/>
                            </svg>
                        </div>
                    </div>

                    <!-- Seats Grid -->
                    <div class="seats-grid">
                        <c:forEach var="seat" items="${seats}">
                            <div class="seat-node ${seat.seatStatus == 'BOOKED' ? 'booked' : 'available'} ${seat.seatType == 'SLEEPER' ? 'sleeper' : ''}"
                                 data-seat-id="${seat.seatId}"
                                 data-seat-number="${seat.seatNumber}"
                                 data-deck="${seat.deck}"
                                 title="Seat ${seat.seatNumber} (${seat.deck} - ${seat.seatType})">
                                <span>${seat.seatNumber}</span>
                                <span style="font-size: 0.6rem; opacity: 0.7;">${seat.deck == 'UPPER' ? 'U' : 'L'}</span>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Legend -->
                    <div class="seat-legend">
                        <div class="legend-item">
                            <div class="legend-swatch swatch-avail"></div>
                            <span>Available</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-swatch swatch-select"></div>
                            <span>Selected</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-swatch swatch-booked"></div>
                            <span>Booked</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Checkout Summary & Form -->
            <div class="checkout-summary-card">
                <h3 style="font-family: var(--font-heading); font-size: 1.25rem; color: #fff; margin-bottom: 1rem;">Booking Summary</h3>

                <!-- Trip overview -->
                <div class="trip-overview-box">
                    <div style="font-size: 1.15rem; font-weight: 700; color: #fff; margin-bottom: 0.35rem;">
                        ${schedule.route.source} &rarr; ${schedule.route.destination}
                    </div>
                    <div style="font-size: 0.85rem; color: var(--text-muted);">
                        Date: <span style="color: #fff;">${schedule.departureDate}</span> • Dep: <span style="color: #fff;">${schedule.departureTime}</span>
                    </div>
                </div>

                <!-- Form to Submit to BookingServlet -->
                <form action="${pageContext.request.contextPath}/book" method="POST" id="booking-checkout-form">
                    <input type="hidden" name="scheduleId" value="${schedule.scheduleId}">
                    <input type="hidden" name="seatIds" id="input-seat-ids" value="">

                    <!-- Selected Seats Badges -->
                    <div style="margin-bottom: 1.25rem;">
                        <label class="form-label" style="display: block; margin-bottom: 0.5rem;">Selected Seats</label>
                        <div id="selected-seats-badges" style="display: flex; flex-wrap: wrap; gap: 0.5rem;">
                            <span class="text-muted" style="font-size: 0.85rem;">No seats selected yet</span>
                        </div>
                    </div>

                    <!-- Dynamic Passenger Info Inputs -->
                    <div style="margin-bottom: 1.25rem;">
                        <label class="form-label" style="display: block; margin-bottom: 0.5rem;">Passenger Details</label>
                        <div id="passenger-form-list" class="passenger-form-list">
                            <p class="text-muted" style="font-size: 0.85rem;">Please click on available seats in the bus layout to proceed.</p>
                        </div>
                    </div>

                    <!-- Payment Method -->
                    <div style="margin-bottom: 1.5rem;">
                        <label class="form-label" style="display: block; margin-bottom: 0.5rem;">Select Payment Method</label>
                        <div class="payment-methods-grid">
                            <label>
                                <input type="radio" name="paymentMethod" value="CARD" class="payment-method-radio" checked>
                                <div class="payment-method-card">Debit/Credit Card</div>
                            </label>
                            <label>
                                <input type="radio" name="paymentMethod" value="UPI" class="payment-method-radio">
                                <div class="payment-method-card">Instant UPI</div>
                            </label>
                            <label>
                                <input type="radio" name="paymentMethod" value="NET_BANKING" class="payment-method-radio">
                                <div class="payment-method-card">Net Banking</div>
                            </label>
                        </div>
                    </div>

                    <!-- Total Row -->
                    <div style="display: flex; justify-content: space-between; align-items: center; padding: 1rem 0; border-top: 1px dashed rgba(255, 255, 255, 0.15); margin-bottom: 1.5rem;">
                        <span style="font-size: 1.1rem; color: #cbd5e1;">Total Amount:</span>
                        <span id="summary-total-amount" style="font-family: var(--font-heading); font-size: 1.5rem; font-weight: 800; color: #38bdf8;">₹ 0.00</span>
                    </div>

                    <!-- Confirm Booking Button -->
                    <button type="submit" id="btn-confirm-booking" class="btn-glow" style="width: 100%;" disabled>
                        Confirm & Reserve Seats
                    </button>
                </form>

            </div>

        </div>

    </main>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <script src="${pageContext.request.contextPath}/assets/js/seat-selection.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            initSeatSelection(${schedule.fare});
        });
    </script>
</body>
</html>
