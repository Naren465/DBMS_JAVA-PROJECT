<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CruiseBus – Browse Fleet & Search Buses</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/search.css">
</head>
<body>

    <!-- Cinematic Backdrop from Reference Image 5 -->
    <div class="cinematic-bg" style="background-image: url('${pageContext.request.contextPath}/assets/images/ref_search.jpg'); background-position: center top;"></div>

    <!-- Header Navigation -->
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="search-page-container">

        <!-- Secondary Sub-Navbar (Exact Image 5 reproduction) -->
        <nav class="search-subnav">
            <!-- User Profile Badge -->
            <div class="subnav-user-badge">
                <div class="subnav-avatar">
                    ${not empty sessionScope.userName ? sessionScope.userName.substring(0, 2).toUpperCase() : 'PA'}
                </div>
                <div class="subnav-username">
                    ${not empty sessionScope.userName ? sessionScope.userName : 'Primary Admin'}
                </div>
            </div>

            <!-- Subnav Menu Links -->
            <div class="subnav-links">
                <a href="${pageContext.request.contextPath}/search" class="subnav-link active">BROWSE</a>
                <a href="${pageContext.request.contextPath}/ticket" class="subnav-link">MY BOOKINGS</a>
                <a href="javascript:void(0)" onclick="alert('Government ID Verification Active: Aadhaar / Driving License verified on boarding.');" class="subnav-link">ID VERIFICATION</a>
                <a href="${pageContext.request.contextPath}/contact" class="subnav-link">CUSTOMER CARE</a>
                <a href="${pageContext.request.contextPath}/admin?demo_admin=true" class="subnav-link">ADMIN</a>
            </div>

            <!-- Sign Out -->
            <a href="${pageContext.request.contextPath}/logout" class="subnav-signout">
                <svg viewBox="0 0 24 24">
                    <path d="M17 7l-1.41 1.41L18.17 11H8v2h10.17l-2.58 2.58L17 17l5-5zM4 5h8V3H4c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h8v-2H4V5z"/>
                </svg>
                <span>SIGN OUT</span>
            </a>
        </nav>

        <!-- Main Search Layout (Sidebar + Results) -->
        <div class="search-content-layout">

            <!-- Left Filter Sidebar (Matching Image 5) -->
            <aside class="filter-sidebar">
                <form id="filter-form" action="${pageContext.request.contextPath}/search" method="GET">
                    <!-- Preserve search inputs -->
                    <input type="hidden" name="from" value="${selectedFrom}">
                    <input type="hidden" name="to" value="${selectedTo}">
                    <input type="hidden" name="date" value="${selectedDate}">

                    <div class="filter-header">
                        <div class="filter-title-wrap">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor">
                                <path d="M10 18h4v-2h-4v2zM3 6v2h18V6H3zm3 7h12v-2H6v2z"/>
                            </svg>
                            <span>FILTER</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/search" class="filter-clear-link">Clear all</a>
                    </div>

                    <!-- Filter 1: Price Range -->
                    <div class="filter-group">
                        <div class="filter-group-header">
                            <span>PRICE RANGE</span>
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><path d="M7.41 8.59L12 13.17l4.59-4.58L18 10l-6 6-6-6 1.41-1.41z"/></svg>
                        </div>
                        <div class="filter-options-list">
                            <label class="filter-checkbox-item">
                                <input type="checkbox" name="priceRange" value="0-500" onchange="this.form.submit()" ${selectedPriceRanges.contains('0-500') ? 'checked' : ''}>
                                <span>₹0 – ₹500</span>
                            </label>
                            <label class="filter-checkbox-item">
                                <input type="checkbox" name="priceRange" value="500-1000" onchange="this.form.submit()" ${selectedPriceRanges.contains('500-1000') ? 'checked' : ''}>
                                <span>₹500 – ₹1,000</span>
                            </label>
                            <label class="filter-checkbox-item">
                                <input type="checkbox" name="priceRange" value="1000-1500" onchange="this.form.submit()" ${selectedPriceRanges.contains('1000-1500') ? 'checked' : ''}>
                                <span>₹1,000 – ₹1,500</span>
                            </label>
                            <label class="filter-checkbox-item">
                                <input type="checkbox" name="priceRange" value="1500+" onchange="this.form.submit()" ${selectedPriceRanges.contains('1500+') ? 'checked' : ''}>
                                <span>₹1,500+</span>
                            </label>
                        </div>
                    </div>

                    <!-- Filter 2: Bus Operator -->
                    <div class="filter-group">
                        <div class="filter-group-header">
                            <span>BUS OPERATOR</span>
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><path d="M7.41 8.59L12 13.17l4.59-4.58L18 10l-6 6-6-6 1.41-1.41z"/></svg>
                        </div>
                        <div class="filter-options-list">
                            <c:set var="operatorsList" value="${['KSRTC', 'Volvo Buses', 'RedBus', 'SETC', 'SRS Travels', 'VRL Travels', 'Rajdhani Travels']}" />
                            <c:forEach var="op" items="${operatorsList}">
                                <label class="filter-checkbox-item">
                                    <input type="checkbox" name="operator" value="${op}" onchange="this.form.submit()" ${selectedOperators.contains(op) ? 'checked' : ''}>
                                    <span>${op}</span>
                                </label>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Filter 3: Bus Type -->
                    <div class="filter-group">
                        <div class="filter-group-header">
                            <span>BUS TYPE</span>
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><path d="M7.41 8.59L12 13.17l4.59-4.58L18 10l-6 6-6-6 1.41-1.41z"/></svg>
                        </div>
                        <div class="filter-options-list">
                            <label class="filter-checkbox-item">
                                <input type="checkbox" name="busType" value="AC Sleeper" onchange="this.form.submit()" ${selectedBusTypes.contains('AC Sleeper') ? 'checked' : ''}>
                                <span>AC Sleeper</span>
                            </label>
                            <label class="filter-checkbox-item">
                                <input type="checkbox" name="busType" value="AC Seater" onchange="this.form.submit()" ${selectedBusTypes.contains('AC Seater') ? 'checked' : ''}>
                                <span>AC Seater</span>
                            </label>
                            <label class="filter-checkbox-item">
                                <input type="checkbox" name="busType" value="Non AC Seater" onchange="this.form.submit()" ${selectedBusTypes.contains('Non AC Seater') ? 'checked' : ''}>
                                <span>Non AC Seater</span>
                            </label>
                        </div>
                    </div>

                </form>
            </aside>

            <!-- Main Results Column -->
            <section class="search-main-results">

                <!-- Search by Model & Meta Toolbar -->
                <div class="results-toolbar">
                    <form action="${pageContext.request.contextPath}/search" method="GET" class="search-model-box">
                        <input type="hidden" name="from" value="${selectedFrom}">
                        <input type="hidden" name="to" value="${selectedTo}">
                        <input type="hidden" name="date" value="${selectedDate}">
                        <svg class="search-model-icon" viewBox="0 0 24 24">
                            <path d="M15.5 14h-.79l-.28-.27A6.471 6.471 0 0 0 16 9.5 6.5 6.5 0 1 0 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
                        </svg>
                        <input type="text" name="model" class="search-model-input" placeholder="Search by model..." value="${selectedModel}">
                    </form>

                    <div class="results-meta-row">
                        <div class="results-count">
                            ${totalCount} buses
                            <c:if test="${not empty selectedFrom and not empty selectedTo}">
                                • <span style="color: #38bdf8;">${selectedFrom} &rarr; ${selectedTo}</span>
                            </c:if>
                        </div>

                        <!-- Sort Dropdown -->
                        <select name="sort" class="sort-dropdown" onchange="location.href='${pageContext.request.contextPath}/search?from=${selectedFrom}&to=${selectedTo}&date=${selectedDate}&model=${selectedModel}&sort=' + this.value">
                            <option value="popular" ${selectedSort == 'popular' ? 'selected' : ''}>Most popular first</option>
                            <option value="price_asc" ${selectedSort == 'price_asc' ? 'selected' : ''}>Price: Low to High</option>
                            <option value="price_desc" ${selectedSort == 'price_desc' ? 'selected' : ''}>Price: High to Low</option>
                            <option value="departure_asc" ${selectedSort == 'departure_asc' ? 'selected' : ''}>Earliest Departure</option>
                        </select>
                    </div>
                </div>

                <!-- 2-Column Bus Cards Grid (Matching Reference Image 5) -->
                <div class="bus-cards-grid">
                    <c:forEach var="sched" items="${schedules}">
                        <div class="bus-card">
                            
                            <!-- Header: Operator & Type -->
                            <div class="bus-card-header">
                                <div class="operator-badge">
                                    <c:choose>
                                        <c:when test="${sched.bus.operator == 'KSRTC'}">
                                            <span class="operator-logo-ksrtc">● KSRTC</span>
                                        </c:when>
                                        <c:when test="${sched.bus.operator == 'Volvo Buses'}">
                                            <span class="operator-logo-volvo">VOLVO</span>
                                        </c:when>
                                        <c:when test="${sched.bus.operator == 'RedBus'}">
                                            <span class="operator-logo-redbus">redBus</span>
                                        </c:when>
                                        <c:when test="${sched.bus.operator == 'SRS Travels'}">
                                            <span class="operator-logo-srs">SRS TRAVELS</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span>${sched.bus.operator}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <span class="bus-type-badge">${sched.bus.busType}</span>
                            </div>

                            <!-- Bus Visual Box -->
                            <div class="bus-visual-box">
                                <c:choose>
                                    <c:when test="${sched.bus.operator == 'KSRTC'}">
                                        <img src="${pageContext.request.contextPath}/assets/images/bus_ksrtc.jpg" alt="${sched.bus.busName}" class="bus-card-img">
                                    </c:when>
                                    <c:when test="${sched.bus.operator == 'Volvo Buses'}">
                                        <img src="${pageContext.request.contextPath}/assets/images/bus_volvo.jpg" alt="${sched.bus.busName}" class="bus-card-img">
                                    </c:when>
                                    <c:when test="${sched.bus.operator == 'RedBus'}">
                                        <img src="${pageContext.request.contextPath}/assets/images/bus_redbus.jpg" alt="${sched.bus.busName}" class="bus-card-img">
                                    </c:when>
                                    <c:when test="${sched.bus.operator == 'SRS Travels'}">
                                        <img src="${pageContext.request.contextPath}/assets/images/bus_srs.jpg" alt="${sched.bus.busName}" class="bus-card-img">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/assets/images/bus_volvo.jpg" alt="${sched.bus.busName}" class="bus-card-img">
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Specs Bar (Seats, Fuel, Transmission) -->
                            <div class="bus-specs-bar">
                                <div class="spec-item">
                                    <svg viewBox="0 0 24 24"><path d="M4 18v3h3v-3h10v3h3v-3h1a2 2 0 0 0 2-2V8a6 6 0 0 0-6-6H7a6 6 0 0 0-6 6v8a2 2 0 0 0 2 2h1z"/></svg>
                                    <span>${sched.bus.totalSeats} seats</span>
                                </div>
                                <div class="spec-item">
                                    <svg viewBox="0 0 24 24"><path d="M19.77 7.23l.01-.01-3.72-3.72L15 4.56l2.11 2.11c-.94.36-1.61 1.26-1.61 2.33 0 1.38 1.12 2.5 2.5 2.5.36 0 .69-.08 1-.22v5.72c0 .55-.45 1-1 1s-1-.45-1-1V14c0-1.1-.9-2-2-2h-1V5c0-1.1-.9-2-2-2H6c-1.1 0-2 .9-2 2v16h10v-7.5h1.5v5c0 1.38 1.12 2.5 2.5 2.5s2.5-1.12 2.5-2.5V9c0-.69-.28-1.32-.73-1.77z"/></svg>
                                    <span>${sched.bus.fuelType}</span>
                                </div>
                                <div class="spec-item">
                                    <svg viewBox="0 0 24 24"><path d="M12 2a10 10 0 1 0 10 10A10 10 0 0 0 12 2zm1 14.93V15a1 1 0 0 0-2 0v1.93A8 8 0 0 1 4.07 13H6a1 1 0 0 0 0-2H4.07A8 8 0 0 1 11 4.07V6a1 1 0 0 0 2 0V4.07A8 8 0 0 1 19.93 11H18a1 1 0 0 0 0 2h1.93A8 8 0 0 1 13 16.93z"/></svg>
                                    <span>${sched.bus.transmission}</span>
                                </div>
                            </div>

                            <!-- Bus Model Title -->
                            <div class="bus-model-name">${sched.bus.busName}</div>

                            <!-- Route & Time Info -->
                            <div class="bus-route-timing">
                                <span>${sched.route.source} &rarr; ${sched.route.destination}</span>
                                <span>Dep: ${sched.departureTime}</span>
                            </div>

                            <!-- Footer Price & Book Now Button -->
                            <div class="bus-card-footer">
                                <div class="bus-price-tag">
                                    ₹ <fmt:formatNumber value="${sched.fare}" pattern="#,##0" />
                                    <span class="bus-price-unit">/ day</span>
                                </div>

                                <a href="${pageContext.request.contextPath}/seats?scheduleId=${sched.scheduleId}" class="btn-book-now">
                                    <span>Book Now</span>
                                    <span>&rarr;</span>
                                </a>
                            </div>

                        </div>
                    </c:forEach>

                    <c:if test="${empty schedules}">
                        <div style="grid-column: span 2; text-align: center; padding: 4rem; background: rgba(14, 18, 28, 0.6); border-radius: 16px;">
                            <p style="color: var(--text-muted); font-size: 1.1rem; margin-bottom: 1rem;">No buses found matching your filter criteria.</p>
                            <a href="${pageContext.request.contextPath}/search" class="btn-glow">Reset Filters</a>
                        </div>
                    </c:if>
                </div>

            </section>

        </div>

    </main>

    <!-- Floating Chat Bubble (Exact matching Image 5 bottom-right icon) -->
    <div class="floating-chat-bubble" onclick="location.href='${pageContext.request.contextPath}/contact'" title="Live Concierge Support">
        <svg viewBox="0 0 24 24">
            <path d="M20 2H4c-1.1 0-1.99.9-1.99 2L2 22l4-4h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zM6 9h12v2H6V9zm8 5H6v-2h8v2zm4-6H6V6h12v2z"/>
        </svg>
    </div>

    <!-- Footer -->
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
