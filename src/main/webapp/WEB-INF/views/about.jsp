<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About CruiseBus – Redefining Journey, Connect with Comfort</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/about.css">
</head>
<body>

    <!-- Cinematic Backdrop from Reference Image 3 -->
    <div class="cinematic-bg" style="background-image: url('${pageContext.request.contextPath}/assets/images/ref_about.jpg');"></div>

    <!-- Navigation Bar -->
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="about-page-container">

        <!-- Header Title Box (Matching Image 3) -->
        <div class="about-header-box">
            <h1 class="about-main-title">About CruiseBus</h1>
            <p class="about-sub-title">Redefining Journey, Connect with Comfort.</p>
        </div>

        <!-- Main Content (2 Columns) -->
        <div class="about-content-row">
            
            <!-- Left Section: Stats & Futuristic Globe Illustration -->
            <div class="about-visual-col">
                <div class="about-stats-row">
                    <!-- Stat 1 -->
                    <div class="stat-item">
                        <div class="stat-number">10,000+</div>
                        <div class="stat-label">Journeys</div>
                    </div>

                    <!-- Stat 2 -->
                    <div class="stat-item">
                        <div class="stat-number">500+</div>
                        <div class="stat-label">Safe Buses</div>
                    </div>

                    <!-- Stat 3 -->
                    <div class="stat-item">
                        <div class="stat-circle-icon">
                            <svg viewBox="0 0 24 24">
                                <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 14h-2v-2h2v2zm0-4h-2V7h2v5z"/>
                            </svg>
                        </div>
                        <div class="stat-number" style="font-size: 1.25rem;">24/7</div>
                        <div class="stat-label">Support</div>
                    </div>
                </div>

                <img src="${pageContext.request.contextPath}/assets/images/about_illustration.png" alt="CruiseBus Global Connectivity" class="about-globe-img" onerror="this.src='${pageContext.request.contextPath}/assets/images/ref_about.jpg'">
            </div>

            <!-- Right Section: Glassmorphism Information Card -->
            <div class="about-card-col">
                <div class="about-glass-card">
                    <h2 class="card-section-heading">Our Mission</h2>
                    <p class="card-text">
                        To provide smart, reliable, and comfortable travel solutions that connect people effortlessly.
                    </p>

                    <h2 class="card-section-heading">Why Choose Us?</h2>
                    <ul class="card-features-list">
                        <li class="card-feature-item">
                            <strong>Modern Fleet:</strong> Luxury, premium, and safe interstate coaches.
                        </li>
                        <li class="card-feature-item">
                            <strong>Seamless Booking:</strong> Instant ticket generation on our robust digital platform.
                        </li>
                        <li class="card-feature-item">
                            <strong>Customer First:</strong> A dedication to top-tier support and hassle-free travel.
                        </li>
                    </ul>

                    <a href="${pageContext.request.contextPath}/search" class="btn-explore">Explore Our Services</a>
                </div>
            </div>

        </div>

    </main>

    <!-- Footer -->
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
