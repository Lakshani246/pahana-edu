<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Item List - Pahana Edu</title>
    <jsp:include page="/includes/header.jsp" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        /* Style for inactive items */
        tr.item-inactive {
            opacity: 0.7;
            background-color: #f8f9fa;
        }
        tr.item-inactive td {
            color: #6c757d;
        }
        .table thead th {
        background-color: #f8f9fa;
        font-weight: 600;
        color: #495057;
        border-bottom: 2px solid #dee2e6;
    }
    </style>
</head>
<body>
    <jsp:include page="/includes/navbar.jsp" />
    
    <div class="container-fluid">
            <main class="px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Item Management</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/item/add" class="btn btn-primary">
                            <i class="fas fa-plus"></i> Add New Item
                        </a>
                    </div>
                </div>
                
                <jsp:include page="/includes/messages.jsp" />
                
                <div class="card shadow mb-4">
                    <div class="card-header py-3">
                        <div class="row">
                            <div class="col-md-6">
                                <h6 class="m-0 font-weight-bold text-primary">Item List</h6>
                            </div>
                            <div class="col-md-6 text-end">
                                <form class="form-inline" action="${pageContext.request.contextPath}/item" method="get">
                                    <div class="input-group">
                                        <input type="text" class="form-control" placeholder="Search..." 
                                               name="search" value="${param.search}">
                                        <select class="form-select" name="category" onchange="this.form.submit()">
                                            <option value="">All Categories</option>
                                            <c:forEach items="${categories}" var="category">
                                                <option value="${category.categoryId}" 
                                                    ${param.category eq category.categoryId.toString() ? 'selected' : ''}>
                                                    ${category.categoryName}
                                                </option>
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
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Code</th>
                                        <th>Name</th>
                                        <th>Category</th>
                                        <th>Price</th>
                                        <th>Stock</th>
                                        <th>Item Status</th>
                                        <th>Stock Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty items}">
                                            <c:forEach items="${items}" var="item">
                                                <tr class="${item.active ? '' : 'item-inactive'}">
                                                    <td>${item.itemCode}</td>
                                                    <td>
                                                        ${item.itemName}
                                                        <c:if test="${!item.active}">
                                                            <span class="text-muted">(Inactive)</span>
                                                        </c:if>
                                                    </td>
                                                    <td>${item.categoryName}</td>
                                                    <td>LKR <fmt:formatNumber value="${item.sellingPrice}" pattern="#,##0.00"/></td>
                                                    <td>${item.quantityInStock}</td>
                                                    <td>
                                                        <!-- Item Active/Inactive Status -->
                                                        <span class="badge ${item.active ? 'bg-success' : 'bg-secondary'}">
                                                            ${item.active ? 'Active' : 'Inactive'}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <!-- Stock Status -->
                                                        <span class="badge bg-${item.stockStatusClass}">
                                                            ${item.stockStatus}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/item/view?id=${item.itemId}" 
                                                           class="btn btn-sm btn-info" title="View">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/item/edit?id=${item.itemId}" 
                                                           class="btn btn-sm btn-warning" title="Edit">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <c:choose>
                                                            <c:when test="${item.active}">
                                                                <!-- Deactivate button for active items -->
                                                                <form action="${pageContext.request.contextPath}/item/deactivate" method="post" 
                                                                      style="display:inline;" 
                                                                      onsubmit="return confirm('Deactivate this item?');">
                                                                    <input type="hidden" name="id" value="${item.itemId}">
                                                                    <button type="submit" class="btn btn-sm btn-danger" title="Deactivate">
                                                                        <i class="fas fa-times-circle"></i>
                                                                    </button>
                                                                </form>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <!-- Activate button for inactive items -->
                                                                <form action="${pageContext.request.contextPath}/item/activate" method="post" 
                                                                      style="display:inline;" 
                                                                      onsubmit="return confirm('Activate this item?');">
                                                                    <input type="hidden" name="id" value="${item.itemId}">
                                                                    <button type="submit" class="btn btn-sm btn-success" title="Activate">
                                                                        <i class="fas fa-check-circle"></i>
                                                                    </button>
                                                                </form>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="8" class="text-center">No items found</td>
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
</body>
</html>