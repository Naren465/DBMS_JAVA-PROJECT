<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CruiseBus – Login & Sign Up</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
</head>
<body>

    <!-- Subtle dark backdrop -->
    <div class="cinematic-bg" style="background-image: url('${pageContext.request.contextPath}/assets/images/ref_login.jpg'); background-position: center top;"></div>

    <!-- Header Navigation -->
    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="auth-container">
        
        <!-- Left Hero Section (Exact Image 1 reproduction) -->
        <section class="auth-hero">
            <h1 class="auth-heading">
                THE ROAD<br>
                <span>THAT</span><br>
                <span>BELONGS TO</span><br>
                <span>YOU</span>
            </h1>

            <p class="auth-subheading">
                From premium interstate coaches to luxury charter buses. Transparent daily pricing, instant availability.
            </p>

            <div class="auth-bus-visual">
                <img src="${pageContext.request.contextPath}/assets/images/luxury_bus_hero.png" alt="CruiseBus Luxury Coach" class="auth-bus-img" onerror="this.src='${pageContext.request.contextPath}/assets/images/bus_volvo.jpg'">
            </div>
        </section>

        <!-- Right Glassmorphism Card (Exact Image 1 reproduction) -->
        <aside class="auth-card-wrapper">
            <div class="auth-card">
                <h2 class="auth-title">${activeTab == 'signup' ? 'CREATE ACCOUNT' : 'WELCOME BACK'}</h2>

                <!-- Tabs: SIGN IN / CREATE ACCOUNT -->
                <div class="auth-tabs">
                    <a href="${pageContext.request.contextPath}/auth?tab=login" class="auth-tab-btn ${activeTab != 'signup' ? 'active' : ''}">SIGN IN</a>
                    <a href="${pageContext.request.contextPath}/auth?tab=signup" class="auth-tab-btn ${activeTab == 'signup' ? 'active' : ''}">CREATE ACCOUNT</a>
                </div>

                <!-- Error Alert -->
                <c:if test="${not empty errorMessage}">
                    <div class="flash-message flash-error" style="margin-bottom: 1rem; padding: 0.65rem 1rem;">
                        <span>${errorMessage}</span>
                    </div>
                </c:if>

                <c:choose>
                    <c:when test="${activeTab == 'signup'}">
                        <!-- SIGN UP FORM -->
                        <form action="${pageContext.request.contextPath}/auth" method="POST" class="auth-form">
                            <input type="hidden" name="action" value="signup">

                            <div class="form-group">
                                <label class="form-label" for="su-name">FULL NAME</label>
                                <input type="text" id="su-name" name="name" class="form-control" placeholder="Enter your full name" value="${signupName}" required>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="su-email">EMAIL</label>
                                <input type="email" id="su-email" name="email" class="form-control" placeholder="you@example.com" value="${signupEmail}" required>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="su-phone">PHONE NUMBER</label>
                                <input type="tel" id="su-phone" name="phone" class="form-control" placeholder="+91 98765 43210" value="${signupPhone}" required>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="su-pass">PASSWORD</label>
                                <input type="password" id="su-pass" name="password" class="form-control" placeholder="At least 6 characters" required>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="su-cpass">CONFIRM PASSWORD</label>
                                <input type="password" id="su-cpass" name="confirmPassword" class="form-control" placeholder="Re-enter password" required>
                            </div>

                            <button type="submit" class="btn-auth-submit">CREATE ACCOUNT</button>
                        </form>
                    </c:when>

                    <c:otherwise>
                        <!-- SIGN IN FORM (Matching Image 1) -->
                        <form action="${pageContext.request.contextPath}/auth" method="POST" class="auth-form">
                            <input type="hidden" name="action" value="login">

                            <div class="form-group">
                                <label class="form-label" for="si-email">EMAIL</label>
                                <input type="email" id="si-email" name="email" class="form-control" placeholder="you@example.com" value="${not empty emailValue ? emailValue : 'demo@cruisebus.in'}" required>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="si-pass">PASSWORD</label>
                                <input type="password" id="si-pass" name="password" class="form-control" placeholder="At least 6 characters" value="${empty emailValue ? 'Demo@123' : ''}" required>
                            </div>

                            <button type="submit" class="btn-auth-submit">SIGN IN</button>
                        </form>
                    </c:otherwise>
                </c:choose>

                <!-- Demo Hint (Exact matching reference text) -->
                <div class="auth-demo-hint">
                    Try the demo customer: <code>demo@cruisebus.in</code> / <code>Demo@123</code>.<br>
                    Administrator access is granted only to authorised emails. (<code>admin@cruisebus.in</code> / <code>Admin@123</code>)
                </div>
            </div>
        </aside>

    </main>

    <!-- Footer -->
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
