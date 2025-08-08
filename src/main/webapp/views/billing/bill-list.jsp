<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bills - Pahana Edu</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .stats-card {
            border-left: 4px solid;
            transition: transform 0.2s;
        }
        .stats-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .stats-card.total { border-left-color: #007bff; }
        .stats-card.paid { border-left-color: #28a745; }
        .stats-card.pending { border-left-color: #ffc107; }
        .stats-card.cancelled { border-left-color: #dc3545; }
        
        .filter-section {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .status-badge {
            font-size: 0.875rem;
            padding: 0.25rem 0.75rem;
        }
        
    </style>
</head>
<body>
    <jsp:include page="/includes/navbar.jsp" />
    
    <div class="container-fluid"> 
            <main class="px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">${pageTitle}</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <a href="${pageContext.request.contextPath}/bill/create" class="btn btn-primary">
                                <i class="fas fa-plus"></i> New Bill
                            </a>
                            <button type="button" class="btn btn-outline-secondary" onclick="exportBills('csv')">
                                <i class="fas fa-download"></i> Export
                            </button>
                        </div>
                    </div>
                </div>
                
                <jsp:include page="/includes/messages.jsp" />
                
                <!-- Statistics Cards -->
                <div class="row mb-4">
                    <div class="col-md-3 mb-3">
                        <div class="card stats-card total">
                            <div class="card-body">
                                <h6 class="card-title text-muted">Total Bills</h6>
                                <h3 class="mb-0">${statistics.totalBills}</h3>
                                <p class="mb-0 text-muted">
                                    <fmt:formatNumber value="${statistics.totalAmount}" type="currency" currencySymbol="Rs. "/>
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="card stats-card paid">
                            <div class="card-body">
                                <h6 class="card-title text-muted">Paid Bills</h6>
                                <h3 class="mb-0">${statistics.paidCount}</h3>
                                <p class="mb-0 text-success">
                                    <fmt:formatNumber value="${statistics.paidAmount}" type="currency" currencySymbol="Rs. "/>
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="card stats-card pending">
                            <div class="card-body">
                                <h6 class="card-title text-muted">Pending Bills</h6>
                                <h3 class="mb-0">${statistics.pendingCount}</h3>
                                <p class="mb-0 text-warning">
                                    <fmt:formatNumber value="${statistics.pendingAmount}" type="currency" currencySymbol="Rs. "/>
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="card stats-card cancelled">
                            <div class="card-body">
                                <h6 class="card-title text-muted">Cancelled</h6>
                                <h3 class="mb-0">${statistics.cancelledCount}</h3>
                                <p class="mb-0 text-muted">
                                    ${statistics.cancelledCount > 0 ? statistics.cancelledCount : 0} bills
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Filters Section -->
                <div class="filter-section">
                    <form id="filterForm" action="${pageContext.request.contextPath}/bill/list" method="get">
                        <div class="row">
                            <div class="col-md-3 mb-2">
                                <input type="text" class="form-control" name="search" placeholder="Search bill or customer..." 
                                       value="${searchTerm}">
                            </div>
                            <div class="col-md-3 mb-2">
                                <input type="text" class="form-control" id="dateRange" placeholder="Select date range">
                                <input type="hidden" name="startDate" id="startDate" value="${startDate}">
                                <input type="hidden" name="endDate" id="endDate" value="${endDate}">
                            </div>
                            <div class="col-md-2 mb-2">
                                <select class="form-select" name="status">
                                    <option value="">All Status</option>
                                    <c:forEach items="${statusOptions}" var="status">
                                        <option value="${status}" ${selectedStatus == status ? 'selected' : ''}>
                                            ${status.displayName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-2 mb-2">
                                <select class="form-select" name="method">
                                    <option value="">All Methods</option>
                                    <c:forEach items="${methodOptions}" var="method">
                                        <option value="${method}" ${selectedMethod == method ? 'selected' : ''}>
                                            ${method.displayName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-2 mb-2">
                                <button type="submit" class="btn btn-primary w-100">
                                    <i class="fas fa-filter"></i> Filter
                                </button>
                            </div>
                        </div>
                        <div class="row mt-2">
                            <div class="col-md-12">
                                <div class="btn-group btn-group-sm" role="group">
                                    <a href="${pageContext.request.contextPath}/bill/list" 
                                       class="btn ${filterType == null ? 'btn-primary' : 'btn-outline-primary'}">All</a>
                                    <a href="${pageContext.request.contextPath}/bill/list?filter=today" 
                                       class="btn ${filterType == 'today' ? 'btn-primary' : 'btn-outline-primary'}">Today</a>
                                    <a href="${pageContext.request.contextPath}/bill/list?filter=pending" 
                                       class="btn ${filterType == 'pending' ? 'btn-primary' : 'btn-outline-primary'}">Pending</a>
                                    <a href="${pageContext.request.contextPath}/bill/list?filter=overdue" 
                                       class="btn ${filterType == 'overdue' ? 'btn-primary' : 'btn-outline-primary'}">Overdue</a>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                
                
                <!-- Bills Table -->
                <div class="card">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        
                                        <th>Bill No.</th>
                                        <th>Date</th>
                                        <th>Customer</th>
                                        <th>Items</th>
                                        <th>Amount</th>
                                        <th>Payment</th>
                                        <th>Status</th>
                                        <th width="80">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty bills}">
                                            <c:forEach items="${bills}" var="bill">
                                                <tr data-bill-id="${bill.billId}">
                                                    
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/bill/view?id=${bill.billId}" 
                                                           class="text-decoration-none">
                                                            <strong>${bill.billNumber}</strong>
                                                        </a>
                                                    </td>
                                                    <td>
                                                        <fmt:formatDate value="${bill.billDate}" pattern="dd/MM/yyyy"/>
                                                        <br>
                                                        <small class="text-muted">
                                                            <fmt:formatDate value="${bill.billTime}" pattern="hh:mm a"/>
                                                        </small>
                                                    </td>
                                                    <td>
                                                        ${bill.customerName}
                                                        <br>
                                                        <small class="text-muted">${bill.customerAccountNumber}</small>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-secondary">${bill.itemCount} items</span>
                                                    </td>
                                                    <td>
                                                        <strong>
                                                            <fmt:formatNumber value="${bill.totalAmount}" 
                                                                            type="currency" currencySymbol="Rs. "/>
                                                        </strong>
                                                    </td>
                                                    <td>
                                                        <i class="${bill.paymentMethodIcon} me-1"></i>
                                                        ${bill.paymentMethod}
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-${bill.paymentStatusClass} status-badge">
                                                            ${bill.paymentStatus}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/bill/view?id=${bill.billId}" 
                                                           class="btn btn-sm btn-primary" title="View">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="9" class="text-center py-4">
                                                    <i class="fas fa-file-invoice fa-3x text-muted mb-3"></i>
                                                    <p class="text-muted">No bills found</p>
                                                    <a href="${pageContext.request.contextPath}/bill/create" 
                                                       class="btn btn-primary">
                                                        <i class="fas fa-plus"></i> Create First Bill
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                        
                        <!-- Pagination -->
                        <c:if test="${totalBills > pageSize}">
                            <nav aria-label="Bill pagination">
                                <ul class="pagination justify-content-center">
                                    <c:set var="totalPages" value="${(totalBills + pageSize - 1) / pageSize}" />
                                    <c:set var="totalPages" value="${totalPages - (totalPages % 1)}" />
                                    
                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="?page=${currentPage - 1}&pageSize=${pageSize}">
                                            Previous
                                        </a>
                                    </li>
                                    
                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                                            <a class="page-link" href="?page=${i}&pageSize=${pageSize}">${i}</a>
                                        </li>
                                    </c:forEach>
                                    
                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                        <a class="page-link" href="?page=${currentPage + 1}&pageSize=${pageSize}">
                                            Next
                                        </a>
                                    </li>
                                </ul>
                            </nav>
                        </c:if>
                    </div>
                </div>
            </main>
    </div>
    
    <jsp:include page="/includes/footer.jsp" />
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/moment/min/moment.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.js"></script>
    
    
    <script>
        $(document).ready(function() {
            // Initialize date range picker
            $('#dateRange').daterangepicker({
                autoUpdateInput: false,
                locale: {
                    cancelLabel: 'Clear',
                    format: 'DD/MM/YYYY'
                }
            });
            
            $('#dateRange').on('apply.daterangepicker', function(ev, picker) {
                $(this).val(picker.startDate.format('DD/MM/YYYY') + ' - ' + picker.endDate.format('DD/MM/YYYY'));
                $('#startDate').val(picker.startDate.format('YYYY-MM-DD'));
                $('#endDate').val(picker.endDate.format('YYYY-MM-DD'));
            });
            
            $('#dateRange').on('cancel.daterangepicker', function(ev, picker) {
                $(this).val('');
                $('#startDate').val('');
                $('#endDate').val('');
            });
            
            // Set initial date range if present
            if ('${startDate}' && '${endDate}') {
                var start = moment('${startDate}');
                var end = moment('${endDate}');
                $('#dateRange').val(start.format('DD/MM/YYYY') + ' - ' + end.format('DD/MM/YYYY'));
            }
            
            // Select all checkbox
            $('#selectAll').on('change', function() {
                $('.bill-select').prop('checked', this.checked);
                updateSelectedCount();
            });
            
            // Individual checkbox change
            $('.bill-select').on('change', function() {
                updateSelectedCount();
            });
        });
        
        function updateSelectedCount() {
            var count = $('.bill-select:checked').length;
            $('#selectedCount').text(count);
            if (count > 0) {
                $('.bulk-select-info').show();
            } else {
                $('.bulk-select-info').hide();
            }
        }
        
        function exportBills(format) {
            var params = window.location.search + (window.location.search ? '&' : '?') + 'export=' + format;
            window.location.href = '${pageContext.request.contextPath}/bill/list' + params;
        }
        
    </script>
</body>
</html>