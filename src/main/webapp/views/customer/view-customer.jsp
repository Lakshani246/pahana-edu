<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Details - Pahana Edu</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <jsp:include page="/includes/navbar.jsp" />
    
    <div class="container-fluid">
        <div class="row">
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Customer Details</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/customer/list" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back to List
                        </a>
                    </div>
                </div>
                
                <jsp:include page="/includes/messages.jsp" />
                
                <div class="card shadow mb-4">
                    <div class="card-header py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <h6 class="m-0 font-weight-bold text-primary">${customer.customerName}</h6>
                            <span class="badge ${customer.active ? 'bg-success' : 'bg-secondary'}">
                                ${customer.active ? 'Active' : 'Inactive'}
                            </span>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h5 class="mb-3">Basic Information</h5>
                                <table class="table table-sm table-borderless">
                                    <tr>
                                        <th width="40%">Account Number:</th>
                                        <td>${customer.accountNumber}</td>
                                    </tr>
                                    <tr>
                                        <th>NIC Number:</th>
                                        <td>${customer.nicNumber}</td>
                                    </tr>
                                    <tr>
                                        <th>Registered On:</th>
                                        <td><fmt:formatDate value="${customer.registrationDate}" pattern="yyyy-MM-dd"/></td>
                                    </tr>
                                    <tr>
                                        <th>Registered By:</th>
                                        <td>${customer.createdByUsername}</td>
                                    </tr>
                                </table>
                            </div>
                            <div class="col-md-6">
                                <h5 class="mb-3">Contact Information</h5>
                                <table class="table table-sm table-borderless">
                                    <tr>
                                        <th width="40%">Address:</th>
                                        <td>${customer.address}</td>
                                    </tr>
                                    <tr>
                                        <th>City:</th>
                                        <td>${customer.city}</td>
                                    </tr>
                                    <tr>
                                        <th>Postal Code:</th>
                                        <td>${customer.postalCode}</td>
                                    </tr>
                                    <tr>
                                        <th>Telephone:</th>
                                        <td>${customer.telephone}</td>
                                    </tr>
                                    <tr>
                                        <th>Mobile:</th>
                                        <td>${customer.mobile}</td>
                                    </tr>
                                    <tr>
                                        <th>Email:</th>
                                        <td>${customer.email}</td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                        
                        <div class="mt-4">
                            <a href="${pageContext.request.contextPath}/customer/edit?id=${customer.customerId}" 
                               class="btn btn-primary me-2">
                                <i class="fas fa-edit"></i> Edit
                            </a>
                            <c:if test="${customer.active}">
                                <form action="${pageContext.request.contextPath}/customer/delete" method="post" 
                                      style="display:inline;" onsubmit="return confirm('Deactivate this customer?');">
                                    <input type="hidden" name="id" value="${customer.customerId}">
                                    <button type="submit" class="btn btn-danger">
                                        <i class="fas fa-user-slash"></i> Deactivate
                                    </button>
                                </form>
                            </c:if>
                        </div>
                    </div>
                </div>
                
                <!-- Customer Purchase History (to be implemented with billing module) -->
                <div class="card shadow mb-4">
                    <div class="card-header py-3">
                        <h6 class="m-0 font-weight-bold text-primary">Purchase History</h6>
                    </div>
                    <div class="card-body">
                        <div class="alert alert-info">
                            Purchase history will be displayed here once billing module is implemented.
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
    
    <jsp:include page="/includes/footer.jsp" />
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>