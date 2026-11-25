<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us – CruiseBus Concierge Support</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

    <div class="cinematic-bg" style="background-image: url('${pageContext.request.contextPath}/assets/images/ref_about.jpg');"></div>

    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="about-page-container">

        <div class="about-header-box">
            <h1 class="about-main-title">Contact CruiseBus</h1>
            <p class="about-sub-title">24/7 Executive Concierge & Passenger Assistance</p>
        </div>

        <div class="about-content-row">

            <!-- Left Info Panel -->
            <div class="about-card-col" style="flex: 1;">
                <div class="about-glass-card">
                    <h2 class="card-section-heading">Get in Touch</h2>
                    <p class="card-text">
                        Have an inquiry regarding luxury charters, interstate bookings, or need help with an active reservation? Our support team is available 24/7.
                    </p>

                    <div style="display: flex; flex-direction: column; gap: 1.5rem; margin-bottom: 2rem;">
                        <div style="display: flex; gap: 1rem; align-items: flex-start;">
                            <div class="brand-icon" style="flex-shrink: 0;">
                                <svg viewBox="0 0 24 24" fill="#38bdf8"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5a2.5 2.5 0 0 1 0-5 2.5 2.5 0 0 1 0 5z"/></svg>
                            </div>
                            <div>
                                <div style="font-weight: 700; color: #fff;">Headquarters</div>
                                <div style="color: var(--text-muted); font-size: 0.85rem;">CruiseBus Towers, Cyber City Hub, Bengaluru, Karnataka 560100</div>
                            </div>
                        </div>

                        <div style="display: flex; gap: 1rem; align-items: flex-start;">
                            <div class="brand-icon" style="flex-shrink: 0;">
                                <svg viewBox="0 0 24 24" fill="#38bdf8"><path d="M6.62 10.79a15.053 15.053 0 0 0 6.59 6.59l2.2-2.2c.27-.27.67-.36 1.02-.24 1.12.37 2.33.57 3.57.57.55 0 1 .45 1 1V20c0 .55-.45 1-1 1-9.39 0-17-7.61-17-17 0-.55.45-1 1-1h3.5c.55 0 1 .45 1 1 0 1.25.2 2.45.57 3.57.11.35.03.74-.25 1.02l-2.2 2.2z"/></svg>
                            </div>
                            <div>
                                <div style="font-weight: 700; color: #fff;">24/7 Passenger Support</div>
                                <div style="color: var(--text-muted); font-size: 0.85rem;">+91 1800 209 8899 (Toll Free) / +91 91234 56789</div>
                            </div>
                        </div>

                        <div style="display: flex; gap: 1rem; align-items: flex-start;">
                            <div class="brand-icon" style="flex-shrink: 0;">
                                <svg viewBox="0 0 24 24" fill="#38bdf8"><path d="M20 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 4l-8 5-8-5V6l8 5 8-5v2z"/></svg>
                            </div>
                            <div>
                                <div style="font-weight: 700; color: #fff;">Email Desk</div>
                                <div style="color: var(--text-muted); font-size: 0.85rem;">concierge@cruisebus.in / support@cruisebus.in</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Message Form -->
            <div class="about-card-col" style="flex: 1.2;">
                <div class="about-glass-card">
                    <h2 class="card-section-heading">Send a Message</h2>
                    
                    <c:if test="${not empty successMessage}">
                        <div class="flash-message flash-success">
                            <span>${successMessage}</span>
                        </div>
                    </c:if>
                    <c:if test="${not empty errorMessage}">
                        <div class="flash-message flash-error">
                            <span>${errorMessage}</span>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/contact" method="POST" style="display: flex; flex-direction: column; gap: 1rem;">
                        <div class="form-group">
                            <label class="form-label">Full Name</label>
                            <input type="text" name="name" class="form-control" placeholder="Your full name" required>
                        </div>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                            <div class="form-group">
                                <label class="form-label">Email Address</label>
                                <input type="email" name="email" class="form-control" placeholder="you@example.com" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Phone</label>
                                <input type="tel" name="phone" class="form-control" placeholder="+91 9876543210">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Subject</label>
                            <input type="text" name="subject" class="form-control" placeholder="e.g. Booking inquiry or feedback" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Your Message</label>
                            <textarea name="message" rows="4" class="form-control" placeholder="Write your message here..." required></textarea>
                        </div>

                        <button type="submit" class="btn-glow" style="margin-top: 0.5rem; width: 100%;">
                            Submit Message
                        </button>
                    </form>
                </div>
            </div>

        </div>

    </main>

    <jsp:include page="/WEB-INF/views/common/footer.jsp" />

    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
