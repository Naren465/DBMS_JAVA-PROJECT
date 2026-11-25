<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<header class="site-header">
    <a href="${pageContext.request.contextPath}/home" class="brand-logo">
        <div class="brand-icon">
            <svg viewBox="0 0 24 24">
                <path d="M4 16c0 .88.39 1.67 1 2.22V20c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h8v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1.78c.61-.55 1-1.34 1-2.22V6c0-3.5-3.58-4-8-4s-8 .5-8 4v10zm3.5 1c-.83 0-1.5-.67-1.5-1.5S6.67 14 7.5 14s1.5.67 1.5 1.5S8.33 17 7.5 17zm9 0c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5zm1.5-6H6V6h12v5z"/>
            </svg>
        </div>
        <span class="brand-title">CRUISEBUS</span>
    </a>

    <ul class="nav-menu">
        <li>
            <a href="${pageContext.request.contextPath}/home" class="nav-link ${activeNav == 'home' ? 'active' : ''}">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/>
                </svg>
                Home
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/about" class="nav-link ${activeNav == 'about' ? 'active' : ''}">About</a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/ticket" class="nav-link ${activeNav == 'download-ticket' ? 'active' : ''}">Download Ticket</a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/contact" class="nav-link ${activeNav == 'contact' ? 'active' : ''}">Contact Us</a>
        </li>
    </ul>

    <div class="nav-actions">
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <a href="${sessionScope.user.role == 'ADMIN' ? pageContext.request.contextPath.concat('/admin') : pageContext.request.contextPath.concat('/ticket')}" class="user-pill" title="${sessionScope.user.name}">
                    <div class="user-avatar-circle">
                        <svg viewBox="0 0 24 24">
                            <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
                        </svg>
                    </div>
                    <span>${sessionScope.userName}</span>
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="btn-nav-outline" style="padding: 0.35rem 0.85rem; font-size: 0.75rem;">Logout</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/auth?tab=signup" class="btn-nav-outline">SIGN UP</a>
                <a href="${pageContext.request.contextPath}/auth?tab=login" class="btn-nav-primary">LOGIN</a>
            </c:otherwise>
        </c:choose>
    </div>
</header>
