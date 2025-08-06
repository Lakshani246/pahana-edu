<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer List - Pahana Edu</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <jsp:include page="/includes/navbar.jsp" />
    
    <div class="container-fluid">
            <main class="px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Customer Management</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/customer/add" class="btn btn-primary">
                            <i class="fas fa-plus"></i> Add New Customer
                        </a>
                    </div>
                </div>
                
                <jsp:include page="/includes/messages.jsp" />
                
                <div class="card shadow mb-4">
                    <div class="card-header py-3">
                        <div class="row">
                            <div class="col-md-6">
                                <h6 class="m-0 font-weight-bold text-primary">Customer List</h6>
                            </div>
                            <div class="col-md-6 text-end">
                                <form class="form-inline" action="${pageContext.request.contextPath}/customer/list" method="get">
                                    <div class="input-group">
                                        <input type="text" class="form-control" placeholder="Search..." name="search" value="${param.search}">
                                        <select class="form-select" name="city" onchange="this.form.submit()">
                                            <option value="">All Cities</option>
                                            <c:forEach items="${cities}" var="city">
                                                <option value="${city}" ${param.city eq city ? 'selected' : ''}>${city}</option>
                                            </c:forEach>
                                        </select>
                                        <button class="btn btn-outline-secondary" type="submit">
                                            <i class="fas fa-search"></i>
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead class="table-dark">
                                    <tr>
                                        <th>Account No</th>
                                        <th>Customer Name</th>
                                        <th>Telephone</th>
                                        <th>City</th>
                                        <th>Registered On</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty customers}">
                                            <c:forEach items="${customers}" var="customer">
                                                <tr>
                                                    <td>${customer.accountNumber}</td>
                                                    <td>${customer.customerName}</td>
                                                    <td>${customer.telephone}</td>
                                                    <td>${customer.city}</td>
                                                    <td><fmt:formatDate value="${customer.registrationDate}" pattern="yyyy-MM-dd"/></td>
                                                    <td>
                                                        <span class="badge ${customer.active ? 'bg-success' : 'bg-secondary'}">
                                                            ${customer.active ? 'Active' : 'Inactive'}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/customer/view?id=${customer.customerId}" 
                                                           class="btn btn-sm btn-info" title="View">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/customer/edit?id=${customer.customerId}" 
                                                           class="btn btn-sm btn-warning" title="Edit">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <form action="${pageContext.request.contextPath}/customer/delete" method="post" 
                                                              style="display:inline;" onsubmit="return confirm('Deactivate this customer?');">
                                                            <input type="hidden" name="id" value="${customer.customerId}">
                                                            <button type="submit" class="btn btn-sm btn-danger" title="Deactivate">
                                                                <i class="fas fa-user-slash"></i>
                                                            </button>
                                                        </form>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="7" class="text-center">No customers found</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                        
                        <div class="row mt-3">
                            <div class="col-md-6">
                                <p class="text-muted">
                                    Showing ${customers.size()} of ${customerStats.totalCustomers} customers
                                    (${customerStats.activeCustomers} active)
                                </p>
                            </div>
                            <div class="col-md-6 text-end">
                                <a href="${pageContext.request.contextPath}/customer/list?export=csv" 
                                   class="btn btn-sm btn-outline-secondary">
                                    <i class="fas fa-download"></i> Export to CSV
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
    </div>
    
    <jsp:include page="/includes/footer.jsp" />
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
</body>
</html>