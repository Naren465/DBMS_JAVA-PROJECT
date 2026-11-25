<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CRUISEBUS – Premium Bus Reservation System | Travel Smart. Book Easy.</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
</head>
<body>

    <!-- Cinematic Night Highway Fleet Background (Exact reference backdrop) -->
    <div class="cinematic-bg" style="background-image: url('${pageContext.request.contextPath}/assets/images/ref_home.jpg');"></div>

    <!-- Navigation Bar -->
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="home-hero-section">

        <!-- Flash messages -->
        <c:if test="${param.msg == 'registered'}">
            <div class="flash-message flash-success">
                <span>Account created successfully! Welcome to CruiseBus.</span>
            </div>
        </c:if>
        <c:if test="${param.msg == 'logged_out'}">
            <div class="flash-message flash-success">
                <span>You have been logged out securely.</span>
            </div>
        </c:if>

        <!-- Hero Typography (Matching Reference Image 2) -->
        <div class="hero-header-box">
            <div class="hero-main-title">BUS TICKET BOOKING</div>
            <div class="hero-highlight-title">PLATFORM</div>
            <div class="hero-tagline-wrap">
                <div class="hero-tagline-line"></div>
                <div class="hero-tagline">Travel Smart. Book Easy.</div>
            </div>
        </div>

        <!-- Search Section (Matching Reference Image 2) -->
        <div class="search-card-wrapper">
            <div class="search-glass-card">
                <div class="search-bar-header">
                    <svg viewBox="0 0 24 24">
                        <path d="M15.5 14h-.79l-.28-.27A6.471 6.471 0 0 0 16 9.5 6.5 6.5 0 1 0 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
                    </svg>
                    <span>Bus Ticket Booking Platform</span>
                </div>

                <form action="${pageContext.request.contextPath}/search" method="GET" class="search-form-row">
                    <!-- From -->
                    <div class="search-input-col">
                        <label class="search-label" for="from-select">From</label>
                        <select name="from" id="from-select" class="search-select-box">
                            <option value="">Select From</option>
                            <c:forEach var="src" items="${sources}">
                                <option value="${src}">${src}</option>
                            </c:forEach>
                            <c:if test="${empty sources}">
                                <option value="Chennai" selected>Chennai</option>
                                <option value="Bengaluru">Bengaluru</option>
                                <option value="Hyderabad">Hyderabad</option>
                                <option value="Coimbatore">Coimbatore</option>
                            </c:if>
                        </select>
                    </div>

                    <!-- To -->
                    <div class="search-input-col">
                        <label class="search-label" for="to-select">To</label>
                        <select name="to" id="to-select" class="search-select-box">
                            <option value="">Select To</option>
                            <c:forEach var="dst" items="${destinations}">
                                <option value="${dst}">${dst}</option>
                            </c:forEach>
                            <c:if test="${empty destinations}">
                                <option value="Bengaluru" selected>Bengaluru</option>
                                <option value="Chennai">Chennai</option>
                                <option value="Goa">Goa</option>
                                <option value="Kochi">Kochi</option>
                            </c:if>
                        </select>
                    </div>

                    <!-- Date -->
                    <div class="search-input-col">
                        <label class="search-label" for="date-input">Date</label>
                        <input type="date" name="date" id="date-input" class="search-date-box" value="${java.time.LocalDate.now()}">
                    </div>

                    <!-- Search Bus Button -->
                    <div class="search-btn-col">
                        <button type="submit" class="btn-search-glow">
                            <svg viewBox="0 0 24 24">
                                <path d="M15.5 14h-.79l-.28-.27A6.471 6.471 0 0 0 16 9.5 6.5 6.5 0 1 0 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
                            </svg>
                            <span>Search Bus</span>
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- WHY BOOK WITH US? Section (Matching Reference Image 2) -->
        <section class="why-book-section">
            <div class="section-divider-title">
                <div class="section-divider-line"></div>
                <h2 class="section-title">Why Book With Us?</h2>
                <div class="section-divider-line"></div>
            </div>

            <div class="feature-cards-grid">
                <!-- Card 1 -->
                <div class="feature-card">
                    <div class="feature-icon-circle">
                        <svg viewBox="0 0 24 24">
                            <path d="M4 16c0 .88.39 1.67 1 2.22V20c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h8v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1.78c.61-.55 1-1.34 1-2.22V6c0-3.5-3.58-4-8-4s-8 .5-8 4v10zm3.5 1c-.83 0-1.5-.67-1.5-1.5S6.67 14 7.5 14s1.5.67 1.5 1.5S8.33 17 7.5 17zm9 0c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5zm1.5-6H6V6h12v5z"/>
                        </svg>
                    </div>
                    <h3 class="feature-title">Multiple Bus Operators</h3>
                    <p class="feature-desc">Choose from a wide range of trusted operators.</p>
                </div>

                <!-- Card 2 -->
                <div class="feature-card">
                    <div class="feature-icon-circle">
                        <svg viewBox="0 0 24 24">
                            <path d="M4 6h16v10H4V6zm18-2H2c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h7l-2 3v1h10v-1l-2-3h7c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2z"/>
                        </svg>
                    </div>
                    <h3 class="feature-title">Multiple Platforms</h3>
                    <p class="feature-desc">Book easily on web, Android and iOS apps.</p>
                </div>

                <!-- Card 3 -->
                <div class="feature-card">
                    <div class="feature-icon-circle">
                        <svg viewBox="0 0 24 24">
                            <path d="M12 1c-4.97 0-9 4.03-9 9v7c0 2.76 2.24 5 5 5h1v-2H8c-1.66 0-3-1.34-3-3v-6.07C6.01 9.38 7.91 8.5 10 8.5c1.13 0 2.2.27 3.15.75.52.27 1.09.4 1.67.4 2.11 0 3.82-1.71 3.82-3.82C18.64 3.32 15.68 1 12 1zm7 11h-2v5c0 1.66-1.34 3-3 3h-1v2h1c2.76 0 5-2.24 5-5v-5z"/>
                        </svg>
                    </div>
                    <h3 class="feature-title">Superior Customer Service</h3>
                    <p class="feature-desc">Get 24/7 support for a smooth booking experience.</p>
                </div>
            </div>
        </section>

        <!-- Bottom 5 Service Navigation Cards (Matching Reference Image 2) -->
        <div class="service-cards-row">
            <!-- 1. Agent App (POS) -->
            <a href="${pageContext.request.contextPath}/search" class="service-card">
                <div class="service-icon">
                    <svg viewBox="0 0 24 24">
                        <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
                    </svg>
                </div>
                <div class="service-title">Agent App<br>(POS)</div>
            </a>

            <!-- 2. Admin Panel -->
            <a href="${pageContext.request.contextPath}/admin?demo_admin=true" class="service-card">
                <div class="service-icon">
                    <svg viewBox="0 0 24 24">
                        <path d="M19.14 12.94c.04-.3.06-.61.06-.94 0-.32-.02-.64-.07-.94l2.03-1.58c.18-.14.23-.41.12-.61l-1.92-3.32c-.12-.22-.37-.29-.59-.22l-2.39.96c-.5-.38-1.03-.7-1.62-.94l-.36-2.54c-.04-.24-.24-.41-.48-.41h-3.84c-.24 0-.43.17-.47.41l-.36 2.54c-.59.24-1.13.57-1.62.94l-2.39-.96c-.22-.08-.47 0-.59.22L2.74 8.87c-.12.21-.08.47.12.61l2.03 1.58c-.05.3-.09.63-.09.94s.02.64.07.94l-2.03 1.58c-.18.14-.23.41-.12.61l1.92 3.32c.12.22.37.29.59.22l2.39-.96c.5.38 1.03.7 1.62.94l.36 2.54c.05.24.24.41.48.41h3.84c.24 0 .44-.17.47-.41l.36-2.54c.59-.24 1.13-.56 1.62-.94l2.39.96c.22.08.47 0 .59-.22l1.92-3.32c.12-.22.07-.47-.12-.61l-2.01-1.58zM12 15.6c-1.98 0-3.6-1.62-3.6-3.6s1.62-3.6 3.6-3.6 3.6 1.62 3.6 3.6-1.62 3.6-3.6 3.6z"/>
                    </svg>
                </div>
                <div class="service-title">Admin<br>Panel</div>
            </a>

            <!-- 3. Mobile App (Android + iOS) -->
            <a href="${pageContext.request.contextPath}/about" class="service-card">
                <div class="service-icon">
                    <svg viewBox="0 0 24 24">
                        <path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/>
                    </svg>
                </div>
                <div class="service-title">Mobile App<br>(Android + iOS)</div>
            </a>

            <!-- 4. Driver App -->
            <a href="${pageContext.request.contextPath}/search" class="service-card">
                <div class="service-icon">
                    <svg viewBox="0 0 24 24">
                        <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8 0-1.85.63-3.55 1.69-4.9L12 11.5l6.31-4.4C19.37 8.45 20 10.15 20 12c0 4.41-3.59 8-8 8zm-1-8.5V6.08c.33-.05.66-.08 1-.08s.67.03 1 .08v5.42L11 11.5z"/>
                    </svg>
                </div>
                <div class="service-title">Driver<br>App</div>
            </a>

            <!-- 5. Bus Tracker -->
            <a href="${pageContext.request.contextPath}/ticket" class="service-card">
                <div class="service-icon">
                    <svg viewBox="0 0 24 24">
                        <path d="M12 2c-4.42 0-8 3.58-8 8 0 5.25 7.15 11.39 7.45 11.64.33.27.77.27 1.1 0C12.85 21.39 20 15.25 20 10c0-4.42-3.58-8-8-8zm0 11c-1.66 0-3-1.34-3-3s1.34-3 3-3 3 1.34 3 3-1.34 3-3 3z"/>
                    </svg>
                </div>
                <div class="service-title">Bus<br>Tracker</div>
            </a>
        </div>

    </main>

    <!-- Footer -->
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
