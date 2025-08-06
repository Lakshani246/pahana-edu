<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Item Details - Pahana Edu</title>
    <jsp:include page="/includes/header.jsp" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <jsp:include page="/includes/navbar.jsp" />
    
    <div class="container-fluid">
            <main class="px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Item Details</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/item/list" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back to List
                        </a>
                    </div>
                </div>
                
                <jsp:include page="/includes/messages.jsp" />
                
                <div class="card shadow mb-4">
                    <div class="card-header py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <h6 class="m-0 font-weight-bold text-primary">${item.itemName}</h6>
                            <span class="badge ${item.active ? 'bg-success' : 'bg-secondary'}">
                                ${item.active ? 'Active' : 'Inactive'}
                            </span>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h5 class="mb-3">Basic Information</h5>
                                <table class="table table-sm table-borderless">
                                    <tr>
                                        <th width="40%">Item Code:</th>
                                        <td>${item.itemCode}</td>
                                    </tr>
                                    <tr>
                                        <th>Category:</th>
                                        <td>${item.categoryName}</td>
                                    </tr>
                                    <tr>
                                        <th>Author:</th>
                                        <td>${not empty item.author ? item.author : 'N/A'}</td>
                                    </tr>
                                    <tr>
                                        <th>Publisher:</th>
                                        <td>${not empty item.publisher ? item.publisher : 'N/A'}</td>
                                    </tr>
                                    <tr>
                                        <th>ISBN:</th>
                                        <td>${not empty item.isbn ? item.isbn : 'N/A'}</td>
                                    </tr>
                                </table>
                            </div>
                            <div class="col-md-6">
                                <h5 class="mb-3">Pricing & Stock</h5>
                                <table class="table table-sm table-borderless">
                                    <tr>
                                        <th width="40%">Unit Price:</th>
                                        <td><fmt:formatNumber value="${item.unitPrice}" type="currency"/></td>
                                    </tr>
                                    <tr>
                                        <th>Selling Price:</th>
                                        <td><fmt:formatNumber value="${item.sellingPrice}" type="currency"/></td>
                                    </tr>
                                    <tr>
                                        <th>Profit:</th>
                                        <td><fmt:formatNumber value="${item.profit}" type="currency"/></td>
                                    </tr>
                                    <tr>
                                        <th>Profit Margin:</th>
                                        <td><fmt:formatNumber value="${item.profitMargin}" pattern="#.##"/>%</td>
                                    </tr>
                                    <tr>
                                        <th>Quantity in Stock:</th>
                                        <td>${item.quantityInStock}</td>
                                    </tr>
                                    <tr>
                                        <th>Reorder Level:</th>
                                        <td>${item.reorderLevel}</td>
                                    </tr>
                                    <tr>
                                        <th>Stock Status:</th>
                                        <td>
                                            <span class="badge bg-${item.stockStatusClass}">
                                                ${item.stockStatus}
                                            </span>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                        
                        <c:if test="${not empty item.description}">
                            <div class="mt-3">
                                <h5>Description</h5>
                                <p>${item.description}</p>
                            </div>
                        </c:if>
                        
                        <div class="mt-4">
                            <a href="${pageContext.request.contextPath}/item/edit?id=${item.itemId}" 
                               class="btn btn-primary me-2">
                                <i class="fas fa-edit"></i> Edit
                            </a>
                            <c:if test="${item.active}">
                                <form action="${pageContext.request.contextPath}/item/delete" method="post" 
                                      style="display:inline;" onsubmit="return confirm('Deactivate this item?');">
                                    <input type="hidden" name="id" value="${item.itemId}">
                                    <button type="submit" class="btn btn-danger">
                                        <i class="fas fa-times-circle"></i> Deactivate
                                    </button>
                                </form>
                            </c:if>
                        </div>
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