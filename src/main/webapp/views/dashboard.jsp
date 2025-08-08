<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Pahana Edu Online Billing System</title>
    
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <style>
        .stat-card {
            border-left: 4px solid;
            transition: transform 0.2s;
            box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075);
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 0.5rem 1rem rgba(0,0,0,0.15);
        }
        .stat-card.primary { border-left-color: #007bff; }
        .stat-card.success { border-left-color: #28a745; }
        .stat-card.info { border-left-color: #17a2b8; }
        .stat-card.warning { border-left-color: #ffc107; }
        
        .quick-actions-card {
            box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075);
        }
        
        .quick-action-btn {
            transition: all 0.3s;
        }
        
        .quick-action-btn:hover {
            transform: scale(1.05);
        }
        
        .welcome-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            border-radius: 0.5rem;
            margin-bottom: 2rem;
        }
        
        .today-summary {
            background-color: #f8f9fa;
            border-radius: 0.5rem;
            padding: 1.5rem;
            margin-top: 2rem;
        }
    </style>
</head>
<body>
    <!-- Include Navbar -->
    <jsp:include page="/includes/navbar.jsp" />
    
    <div class="container-fluid">  
        <!-- Main Content -->
        <main class="px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Dashboard</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <span class="text-muted">
                        <i class="fas fa-clock"></i> 
                        <fmt:formatDate value="<%=new java.util.Date()%>" pattern="EEEE, dd MMMM yyyy"/>
                    </span>
                </div>
            </div>
            
            <!-- Welcome Section -->
            <div class="welcome-section">
                <h3><i class="fas fa-hand-wave"></i> Welcome back, ${currentUser.fullName}!</h3>
                <p class="mb-0">Here's your business overview for today</p>
            </div>
            
            <!-- Include Messages -->
            <jsp:include page="/includes/messages.jsp" />
            
            <!-- Statistics Cards -->
            <div class="row">
                <!-- Total Customers Card -->
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card stat-card primary h-100">
                        <div class="card-body">
                            <div class="row align-items-center">
                                <div class="col">
                                    <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                        Total Customers
                                    </div>
                                    <div class="h4 mb-0 font-weight-bold text-gray-800">
                                        ${dashboardStats.totalCustomers}
                                    </div>
                                    <small class="text-muted">
                                        <i class="fas fa-check-circle text-success"></i> ${dashboardStats.activeCustomers} active
                                    </small>
                                </div>
                                <div class="col-auto">
                                    <i class="fas fa-users fa-2x text-primary opacity-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Total Items Card -->
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card stat-card success h-100">
                        <div class="card-body">
                            <div class="row align-items-center">
                                <div class="col">
                                    <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                        Total Items
                                    </div>
                                    <div class="h4 mb-0 font-weight-bold text-gray-800">
                                        ${dashboardStats.totalItems}
                                    </div>
                                    <small class="text-muted">
                                        <i class="fas fa-check-circle text-success"></i> ${dashboardStats.activeItems} active
                                    </small>
                                </div>
                                <div class="col-auto">
                                    <i class="fas fa-box fa-2x text-success opacity-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Today's Sales Card -->
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card stat-card info h-100">
                        <div class="card-body">
                            <div class="row align-items-center">
                                <div class="col">
                                    <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
                                        Today's Sales
                                    </div>
                                    <div class="h4 mb-0 font-weight-bold text-gray-800">
                                        LKR <fmt:formatNumber value="${dashboardStats.todaysSales}" pattern="#,##0.00"/>
                                    </div>
                                    <small class="text-muted">
                                        <i class="fas fa-file-invoice text-info"></i> ${dashboardStats.todaysBills} bills
                                    </small>
                                </div>
                                <div class="col-auto">
                                    <i class="fas fa-dollar-sign fa-2x text-info opacity-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Stock Alert Card -->
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card stat-card warning h-100">
                        <div class="card-body">
                            <div class="row align-items-center">
                                <div class="col">
                                    <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                        Stock Alerts
                                    </div>
                                    <div class="h4 mb-0 font-weight-bold text-gray-800">
                                        ${dashboardStats.lowStockItems}
                                    </div>
                                    <small class="text-${dashboardStats.outOfStockItems > 0 ? 'danger' : 'muted'}">
                                        <c:if test="${dashboardStats.outOfStockItems > 0}">
                                            <i class="fas fa-exclamation-circle"></i>
                                        </c:if>
                                        ${dashboardStats.outOfStockItems} out of stock
                                    </small>
                                </div>
                                <div class="col-auto">
                                    <i class="fas fa-exclamation-triangle fa-2x text-warning opacity-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Quick Actions Section -->
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="card quick-actions-card shadow">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0"><i class="fas fa-rocket"></i> Quick Actions</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <!-- Primary Actions -->
                                <div class="col-12 mb-3">
                                    <h6 class="text-muted mb-3">Daily Operations</h6>
                                    <div class="d-grid gap-2 d-md-block">
                                        <a href="${pageContext.request.contextPath}/bill/create" 
                                           class="btn btn-primary quick-action-btn mb-2 me-2">
                                            <i class="fas fa-plus-circle"></i> Create New Bill
                                        </a>
                                        <a href="${pageContext.request.contextPath}/customer/add" 
                                           class="btn btn-success quick-action-btn mb-2 me-2">
                                            <i class="fas fa-user-plus"></i> Add Customer
                                        </a>
                                        <a href="${pageContext.request.contextPath}/item/add" 
                                           class="btn btn-info quick-action-btn mb-2">
                                            <i class="fas fa-box-open"></i> Add Item
                                        </a>
                                    </div>
                                </div>
                                
                                <hr>
                                
                                <!-- Report Actions -->
                                <div class="col-12">
                                    <h6 class="text-muted mb-3">Reports & Analytics</h6>
                                    <div class="row">
                                        <div class="col-md-4 mb-2">
                                            <a href="${pageContext.request.contextPath}/report/sales" 
                                               class="btn btn-outline-primary w-100">
                                                <i class="fas fa-chart-line"></i> Sales Report
                                            </a>
                                        </div>
                                        <div class="col-md-4 mb-2">
                                            <a href="${pageContext.request.contextPath}/report/stock" 
                                               class="btn btn-outline-warning w-100">
                                                <i class="fas fa-warehouse"></i> Stock Report
                                            </a>
                                        </div>
                                        <div class="col-md-4 mb-2">
                                            <a href="${pageContext.request.contextPath}/report/customer" 
                                               class="btn btn-outline-info w-100">
                                                <i class="fas fa-users"></i> Customer Report
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            
            <!-- Critical Alerts (if any) -->
            <c:if test="${dashboardStats.outOfStockItems > 0}">
                <div class="row justify-content-center mt-4">
                    <div class="col-lg-8">
                        <div class="alert alert-danger" role="alert">
                            <h5 class="alert-heading"><i class="fas fa-exclamation-circle"></i> Critical Alerts</h5>
                            <p class="mb-0">
                                <strong>${dashboardStats.outOfStockItems}</strong> items are currently out of stock. 
                                <a href="${pageContext.request.contextPath}/report/stock?type=low-stock" class="alert-link">
                                    View Stock Report →
                                </a>
                            </p>
                        </div>
                    </div>
                </div>
            </c:if>
            
        </main>
    </div>
    
    <!-- Include Footer -->
    <jsp:include page="/includes/footer.jsp" />
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
</body>
</html>