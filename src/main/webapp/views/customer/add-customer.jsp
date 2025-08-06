<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Customer - Pahana Edu</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <jsp:include page="/includes/navbar.jsp" />
    
    <div class="container-fluid">
            <main class="px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Add New Customer</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/customer/list" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back to List
                        </a>
                    </div>
                </div>
                
                <jsp:include page="/includes/messages.jsp" />
                
                <div class="card shadow mb-4">
                    <div class="card-header py-3">
                        <h6 class="m-0 font-weight-bold text-primary">Customer Information</h6>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/customer/add" method="post">
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="customerName" class="form-label">Full Name *</label>
                                    <input type="text" class="form-control ${validationErrors.customerName != null ? 'is-invalid' : ''}" 
                                           id="customerName" name="customerName" value="${customer.customerName}" required>
                                    <c:if test="${validationErrors.customerName != null}">
                                        <div class="invalid-feedback">${validationErrors.customerName}</div>
                                    </c:if>
                                </div>
                                <div class="col-md-6">
                                    <label for="nicNumber" class="form-label">NIC Number *</label>
                                    <input type="text" class="form-control ${validationErrors.nicNumber != null ? 'is-invalid' : ''}" 
                                           id="nicNumber" name="nicNumber" value="${customer.nicNumber}" required>
                                    <c:if test="${validationErrors.nicNumber != null}">
                                        <div class="invalid-feedback">${validationErrors.nicNumber}</div>
                                    </c:if>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="address" class="form-label">Address *</label>
                                <textarea class="form-control ${validationErrors.address != null ? 'is-invalid' : ''}" 
                                          id="address" name="address" rows="3" required>${customer.address}</textarea>
                                <c:if test="${validationErrors.address != null}">
                                    <div class="invalid-feedback">${validationErrors.address}</div>
                                </c:if>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <label for="city" class="form-label">City</label>
                                    <input type="text" class="form-control ${validationErrors.city != null ? 'is-invalid' : ''}" 
                                           id="city" name="city" value="${customer.city}">
                                    <c:if test="${validationErrors.city != null}">
                                        <div class="invalid-feedback">${validationErrors.city}</div>
                                    </c:if>
                                </div>
                                <div class="col-md-4">
                                    <label for="postalCode" class="form-label">Postal Code</label>
                                    <input type="text" class="form-control ${validationErrors.postalCode != null ? 'is-invalid' : ''}" 
                                           id="postalCode" name="postalCode" value="${customer.postalCode}">
                                    <c:if test="${validationErrors.postalCode != null}">
                                        <div class="invalid-feedback">${validationErrors.postalCode}</div>
                                    </c:if>
                                </div>
                                <div class="col-md-4">
                                    <label for="registrationDate" class="form-label">Registration Date</label>
                                    <input type="date" class="form-control" id="registrationDate" 
                                           name="registrationDate" value="${customer.registrationDate}">
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <label for="telephone" class="form-label">Telephone *</label>
                                    <input type="tel" class="form-control ${validationErrors.telephone != null ? 'is-invalid' : ''}" 
                                           id="telephone" name="telephone" value="${customer.telephone}" required>
                                    <c:if test="${validationErrors.telephone != null}">
                                        <div class="invalid-feedback">${validationErrors.telephone}</div>
                                    </c:if>
                                </div>
                                <div class="col-md-4">
                                    <label for="mobile" class="form-label">Mobile</label>
                                    <input type="tel" class="form-control ${validationErrors.mobile != null ? 'is-invalid' : ''}" 
                                           id="mobile" name="mobile" value="${customer.mobile}">
                                    <c:if test="${validationErrors.mobile != null}">
                                        <div class="invalid-feedback">${validationErrors.mobile}</div>
                                    </c:if>
                                </div>
                                <div class="col-md-4">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" class="form-control ${validationErrors.email != null ? 'is-invalid' : ''}" 
                                           id="email" name="email" value="${customer.email}">
                                    <c:if test="${validationErrors.email != null}">
                                        <div class="invalid-feedback">${validationErrors.email}</div>
                                    </c:if>
                                </div>
                            </div>
                            
                            <div class="text-end">
                                <button type="reset" class="btn btn-secondary me-2">
                                    <i class="fas fa-undo"></i> Reset
                                </button>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Save Customer
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
    </div>
    
    <jsp:include page="/includes/footer.jsp" />
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/validation.js"></script>
</body>
</html>