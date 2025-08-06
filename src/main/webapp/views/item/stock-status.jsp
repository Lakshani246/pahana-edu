<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Stock Status - Pahana Edu</title>
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
                    <h1 class="h2">Stock Status Report</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <button type="button" class="btn btn-sm btn-outline-secondary">Export</button>
                        </div>
                    </div>
                </div>
                
                <jsp:include page="/includes/messages.jsp" />
                
                <div class="card shadow mb-4">
                    <div class="card-header py-3">
                        <div class="row">
                            <div class="col-md-6">
                                <h6 class="m-0 font-weight-bold text-primary">Current Stock Levels</h6>
                            </div>
                            <div class="col-md-6 text-end">
                                <form class="form-inline" action="${pageContext.request.contextPath}/item/stock" method="get">
                                    <select class="form-select" name="status" onchange="this.form.submit()">
                                        <option value="">All Statuses</option>
                                        <option value="low" ${param.status eq 'low' ? 'selected' : ''}>Low Stock</option>
                                        <option value="out" ${param.status eq 'out' ? 'selected' : ''}>Out of Stock</option>
                                        <option value="normal" ${param.status eq 'normal' ? 'selected' : ''}>Normal Stock</option>
                                    </select>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead class="table-dark">
                                    <tr>
                                        <th>Item Code</th>
                                        <th>Item Name</th>
                                        <th>Category</th>
                                        <th>Current Stock</th>
                                        <th>Reorder Level</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty items}">
                                            <c:forEach items="${items}" var="item">
                                                <tr class="${item.stockStatusClass}">
                                                    <td>${item.itemCode}</td>
                                                    <td>${item.itemName}</td>
                                                    <td>${item.categoryName}</td>
                                                    <td>${item.quantityInStock}</td>
                                                    <td>${item.reorderLevel}</td>
                                                    <td>
                                                        <span class="badge bg-${item.stockStatusClass}">
                                                            ${item.stockStatus}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/item/edit?id=${item.itemId}" 
                                                           class="btn btn-sm btn-warning" title="Edit">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="7" class="text-center">No items found</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
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