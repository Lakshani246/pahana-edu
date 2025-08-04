<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.pahanaedu.util.SessionUtil" %>
<%@ page import="com.pahanaedu.model.User" %>
<%
    User sidebarUser = SessionUtil.getLoggedInUser(session);
    String currentPath = request.getServletPath();
%>

<nav id="sidebarMenu" class="col-md-3 col-lg-2 d-md-block bg-light sidebar collapse">
    <div class="position-sticky pt-3">
        <!-- Main Navigation -->
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link <%= currentPath.equals("/dashboard") ? "active" : "" %>" 
                   href="${pageContext.request.contextPath}/dashboard">
                    <i class="fas fa-tachometer-alt"></i>
                    Dashboard
                </a>
            </li>
            
            <!-- Billing Section -->
            <li class="nav-item">
                <h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-muted">
                    <span>Billing</span>
                </h6>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= currentPath.equals("/bill/create") ? "active" : "" %>" 
                   href="${pageContext.request.contextPath}/bill/create">
                    <i class="fas fa-plus-circle"></i>
                    Create Bill
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= currentPath.equals("/bill/list") ? "active" : "" %>" 
                   href="${pageContext.request.contextPath}/bill/list">
                    <i class="fas fa-file-invoice"></i>
                    Bill List
                </a>
            </li>
            
            <!-- Customer Management -->
            <li class="nav-item">
                <h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-muted">
                    <span>Customers</span>
                </h6>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= currentPath.equals("/customer/add") ? "active" : "" %>" 
                   href="${pageContext.request.contextPath}/customer/add">
                    <i class="fas fa-user-plus"></i>
                    Add Customer
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= currentPath.equals("/customer/list") ? "active" : "" %>" 
                   href="${pageContext.request.contextPath}/customer/list">
                    <i class="fas fa-users"></i>
                    Customer List
                </a>
            </li>
            
            <!-- Item Management -->
            <li class="nav-item">
                <h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-muted">
                    <span>Items</span>
                </h6>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= currentPath.equals("/item/add") ? "active" : "" %>" 
                   href="${pageContext.request.contextPath}/item/add">
                    <i class="fas fa-box-open"></i>
                    Add Item
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= currentPath.equals("/item/list") ? "active" : "" %>" 
                   href="${pageContext.request.contextPath}/item/list">
                    <i class="fas fa-boxes"></i>
                    Item List
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= currentPath.equals("/item/stock") ? "active" : "" %>" 
                   href="${pageContext.request.contextPath}/item/stock">
                    <i class="fas fa-warehouse"></i>
                    Stock Status
                </a>
            </li>
            
            <!-- Reports Section (Manager/Admin only) -->
            <% if (sidebarUser != null && ("ADMIN".equals(sidebarUser.getRole()) || "MANAGER".equals(sidebarUser.getRole()))) { %>
            <li class="nav-item">
                <h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-muted">
                    <span>Reports</span>
                </h6>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= currentPath.equals("/report/daily") ? "active" : "" %>" 
                   href="${pageContext.request.contextPath}/report/daily">
                    <i class="fas fa-calendar-day"></i>
                    Daily Sales
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= currentPath.equals("/report/stock") ? "active" : "" %>" 
                   href="${pageContext.request.contextPath}/report/stock">
                    <i class="fas fa-chart-line"></i>
                    Stock Report
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= currentPath.equals("/report/customer") ? "active" : "" %>" 
                   href="${pageContext.request.contextPath}/report/customer">
                    <i class="fas fa-user-chart"></i>
                    Customer Report
                </a>
            </li>
            <% } %>
            
            <!-- Admin Section (Admin only) -->
            <% if (sidebarUser != null && "ADMIN".equals(sidebarUser.getRole())) { %>
            <li class="nav-item">
                <h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-muted">
                    <span>Administration</span>
                </h6>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= currentPath.equals("/user/list") ? "active" : "" %>" 
                   href="${pageContext.request.contextPath}/user/list">
                    <i class="fas fa-users-cog"></i>
                    User Management
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= currentPath.equals("/settings") ? "active" : "" %>" 
                   href="${pageContext.request.contextPath}/settings">
                    <i class="fas fa-cog"></i>
                    System Settings
                </a>
            </li>
            <% } %>
            
            <!-- Help Section -->
            <li class="nav-item">
                <h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-muted">
                    <span>Support</span>
                </h6>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= currentPath.equals("/help") ? "active" : "" %>" 
                   href="${pageContext.request.contextPath}/help">
                    <i class="fas fa-question-circle"></i>
                    Help
                </a>
            </li>
        </ul>
        
        <!-- User Info at Bottom -->
        <div class="sidebar-footer px-3 py-3 mt-4 border-top">
            <div class="d-flex align-items-center">
                <i class="fas fa-user-circle fa-2x text-secondary"></i>
                <div class="ms-3">
                    <div class="small"><%= sidebarUser != null ? sidebarUser.getFullName() : "User" %></div>
                    <div class="text-muted small"><%= sidebarUser != null ? sidebarUser.getRole() : "" %></div>
                </div>
            </div>
        </div>
    </div>
</nav>