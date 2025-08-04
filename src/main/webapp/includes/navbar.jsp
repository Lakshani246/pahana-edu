<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.pahanaedu.util.SessionUtil" %>
<%@ page import="com.pahanaedu.model.User" %>
<%
    User currentUser = SessionUtil.getLoggedInUser(session);
%>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <div class="container-fluid">
        <!-- Brand -->
        <a class="navbar-brand" href="${pageContext.request.contextPath}/dashboard">
            <i class="fas fa-book"></i> Pahana Edu
        </a>
        
        <!-- Mobile Toggle -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" 
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <!-- Navbar Content -->
        <div class="collapse navbar-collapse" id="navbarNav">
            <!-- Left Side Menu -->
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.servletPath == '/dashboard' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/dashboard">
                        <i class="fas fa-tachometer-alt"></i> Dashboard
                    </a>
                </li>
                
                <!-- Billing Dropdown -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="billingDropdown" role="button" 
                       data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-file-invoice"></i> Billing
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="billingDropdown">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/bill/create">
                            <i class="fas fa-plus"></i> Create Bill</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/bill/list">
                            <i class="fas fa-list"></i> Bill List</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/bill/search">
                            <i class="fas fa-search"></i> Search Bills</a></li>
                    </ul>
                </li>
                
                <!-- Customers Dropdown -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="customerDropdown" role="button" 
                       data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-users"></i> Customers
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="customerDropdown">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/customer/add">
                            <i class="fas fa-user-plus"></i> Add Customer</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/customer/list">
                            <i class="fas fa-list"></i> Customer List</a></li>
                    </ul>
                </li>
                
                <!-- Items Dropdown -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="itemDropdown" role="button" 
                       data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-box"></i> Items
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="itemDropdown">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/item/add">
                            <i class="fas fa-plus"></i> Add Item</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/item/list">
                            <i class="fas fa-list"></i> Item List</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/item/stock">
                            <i class="fas fa-warehouse"></i> Stock Status</a></li>
                    </ul>
                </li>
                
                <!-- Reports (Manager/Admin only) -->
                <c:if test="${currentUser.role == 'ADMIN' || currentUser.role == 'MANAGER'}">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="reportDropdown" role="button" 
                           data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-chart-bar"></i> Reports
                        </a>
                        <ul class="dropdown-menu" aria-labelledby="reportDropdown">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/report/daily">
                                <i class="fas fa-calendar-day"></i> Daily Sales</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/report/monthly">
                                <i class="fas fa-calendar-alt"></i> Monthly Report</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/report/stock">
                                <i class="fas fa-boxes"></i> Stock Report</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/report/customer">
                                <i class="fas fa-user-friends"></i> Customer Report</a></li>
                        </ul>
                    </li>
                </c:if>
            </ul>
            
            <!-- Right Side Menu -->
            <ul class="navbar-nav ms-auto">
                <!-- Help -->
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/help">
                        <i class="fas fa-question-circle"></i> Help
                    </a>
                </li>
                
                <!-- User Menu -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" 
                       data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-user-circle"></i> <%= currentUser != null ? currentUser.getFullName() : "User" %>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                        <li><h6 class="dropdown-header">
                            <%= currentUser != null ? currentUser.getRole() : "" %>
                        </h6></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                            <i class="fas fa-user"></i> My Profile</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/change-password">
                            <i class="fas fa-key"></i> Change Password</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                            <i class="fas fa-sign-out-alt"></i> Logout</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Add spacing for fixed navbar -->
<div style="margin-top: 56px;"></div>