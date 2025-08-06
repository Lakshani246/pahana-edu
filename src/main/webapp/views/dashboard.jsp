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
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .stat-card.primary { border-left-color: #007bff; }
        .stat-card.success { border-left-color: #28a745; }
        .stat-card.info { border-left-color: #17a2b8; }
        .stat-card.warning { border-left-color: #ffc107; }
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
                        <span class="text-muted">Welcome, ${currentUser.fullName}!</span>
                    </div>
                </div>
                
                <!-- Include Messages -->
                <jsp:include page="/includes/messages.jsp" />
                
                <!-- Statistics Cards -->
                <div class="row">
                    <!-- Total Customers Card -->
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stat-card primary h-100 py-2">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                            Total Customers
                                        </div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800">
                                            ${dashboardStats.totalCustomers}
                                        </div>
                                        <small class="text-muted">
                                            ${dashboardStats.activeCustomers} active
                                        </small>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-users fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Total Items Card -->
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stat-card success h-100 py-2">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                            Total Items
                                        </div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800">
                                            ${dashboardStats.totalItems}
                                        </div>
                                        <small class="text-muted">
                                            ${dashboardStats.activeItems} active
                                        </small>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-box fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Today's Sales Card -->
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stat-card info h-100 py-2">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
                                            Today's Sales
                                        </div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800">
                                            LKR <fmt:formatNumber value="${dashboardStats.todaysSales}" pattern="#,##0.00"/>
                                        </div>
                                        <small class="text-muted">
                                            ${dashboardStats.todaysBills} bills
                                        </small>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-dollar-sign fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Low Stock Alert Card -->
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stat-card warning h-100 py-2">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                            Low Stock Items
                                        </div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800">
                                            ${dashboardStats.lowStockItems}
                                        </div>
                                        <small class="text-muted">
                                            ${dashboardStats.outOfStockItems} out of stock
                                        </small>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-exclamation-triangle fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Charts Row -->
                <div class="row">
                    <!-- Sales Overview -->
                    <div class="col-xl-8 col-lg-7">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                                <h6 class="m-0 font-weight-bold text-primary">Sales Overview - Last 7 Days</h6>
                            </div>
                            <div class="card-body">
                                <div class="chart-area">
                                    <canvas id="salesChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Quick Actions -->
                    <div class="col-xl-4 col-lg-5">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3">
                                <h6 class="m-0 font-weight-bold text-primary">Quick Actions</h6>
                            </div>
                            <div class="card-body">
                                <a href="${pageContext.request.contextPath}/bill/create" class="btn btn-primary btn-block mb-3 w-100">
                                    <i class="fas fa-plus-circle"></i> Create New Bill
                                </a>
                                <a href="${pageContext.request.contextPath}/customer/add" class="btn btn-success btn-block mb-3 w-100">
                                    <i class="fas fa-user-plus"></i> Add New Customer
                                </a>
                                <a href="${pageContext.request.contextPath}/item/add" class="btn btn-info btn-block mb-3 w-100">
                                    <i class="fas fa-box-open"></i> Add New Item
                                </a>
                                <hr>
                                <h6 class="mb-3">Reports</h6>
                                <a href="${pageContext.request.contextPath}/report/daily-sales" class="btn btn-outline-primary btn-sm mb-2 w-100">
                                    <i class="fas fa-chart-line"></i> Daily Sales
                                </a>
                                <a href="${pageContext.request.contextPath}/report/stock" class="btn btn-outline-warning btn-sm mb-2 w-100">
                                    <i class="fas fa-warehouse"></i> Stock Report
                                </a>
                                <a href="${pageContext.request.contextPath}/report/customer" class="btn btn-outline-info btn-sm w-100">
                                    <i class="fas fa-users"></i> Customer Report
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Tables Row -->
                <div class="row">
                    <!-- Recent Bills -->
                    <div class="col-lg-6">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3">
                                <h6 class="m-0 font-weight-bold text-primary">Recent Bills</h6>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Bill No</th>
                                                <th>Customer</th>
                                                <th>Amount</th>
                                                <th>Date</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${not empty dashboardStats.recentBills}">
                                                    <c:forEach items="${dashboardStats.recentBills}" var="bill">
                                                        <tr>
                                                            <td>${bill.billNumber}</td>
                                                            <td>${bill.customerName}</td>
                                                            <td>LKR <fmt:formatNumber value="${bill.totalAmount}" pattern="#,##0.00"/></td>
                                                            <td><fmt:formatDate value="${bill.billDate}" pattern="MMM dd"/></td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <tr>
                                                        <td colspan="4" class="text-center text-muted">No recent bills</td>
                                                    </tr>
                                                </c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Recent Customers -->
                    <div class="col-lg-6">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3">
                                <h6 class="m-0 font-weight-bold text-primary">Recent Customers</h6>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Account</th>
                                                <th>Name</th>
                                                <th>Registered</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${not empty dashboardStats.recentCustomers}">
                                                    <c:forEach items="${dashboardStats.recentCustomers}" var="customer">
                                                        <tr>
                                                            <td>${customer.accountNumber}</td>
                                                            <td>${customer.customerName}</td>
                                                            <td><fmt:formatDate value="${customer.registrationDate}" pattern="MMM dd"/></td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <tr>
                                                        <td colspan="3" class="text-center text-muted">No recent customers</td>
                                                    </tr>
                                                </c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
    </div>
    
    <!-- Include Footer -->
    <jsp:include page="/includes/footer.jsp" />
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
    
    <script>
        // Sales chart with real data
        var ctx = document.getElementById('salesChart').getContext('2d');
        var salesChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: [
                    <c:forEach items="${dashboardStats.salesChartLabels}" var="label" varStatus="status">
                        '${label}'<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                ],
                datasets: [{
                    label: 'Sales (LKR)',
                    data: [
                        <c:forEach items="${dashboardStats.salesChartData}" var="data" varStatus="status">
                            ${data}<c:if test="${!status.last}">,</c:if>
                        </c:forEach>
                    ],
                    borderColor: 'rgb(75, 192, 192)',
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    tension: 0.1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return 'LKR ' + value.toLocaleString();
                            }
                        }
                    }
                },
                plugins: {
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return 'Sales: LKR ' + context.parsed.y.toLocaleString();
                            }
                        }
                    }
                }
            }
        });
        
        // Auto-refresh dashboard every 5 minutes
        setTimeout(function() {
            location.reload();
        }, 300000);
    </script>
</body>
</html>