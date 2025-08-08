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
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
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
                            <span class="badge ${item.active ? 'bg-success' : 'bg-secondary'}" id="statusBadge">
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
                                        <td>LKR <fmt:formatNumber value="${item.unitPrice}" pattern="#,##0.00"/></td>
                                    </tr>
                                    <tr>
                                        <th>Selling Price:</th>
                                        <td>LKR <fmt:formatNumber value="${item.sellingPrice}" pattern="#,##0.00"/></td>
                                    </tr>
                                    <tr>
                                        <th>Profit:</th>
                                        <td>LKR <fmt:formatNumber value="${item.profit}" pattern="#,##0.00"/></td>
                                    </tr>
                                    <tr>
                                        <th>Profit Margin:</th>
                                        <td><fmt:formatNumber value="${item.profitMargin}" pattern="#.##"/>%</td>
                                    </tr>
                                    <tr>
                                        <th>Quantity in Stock:</th>
                                        <td>
                                            <span id="stockQuantity">${item.quantityInStock}</span> units
                                            <c:if test="${item.quantityInStock > 0 && !item.active}">
                                                <span class="text-warning">
                                                    <i class="fas fa-exclamation-triangle"></i>
                                                    (Has stock but inactive)
                                                </span>
                                            </c:if>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>Reorder Level:</th>
                                        <td>${item.reorderLevel} units</td>
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
                        
                        <hr class="my-4">
                        
                        <div class="mt-4">
                            <!-- Edit Button (always visible) -->
                            <a href="${pageContext.request.contextPath}/item/edit?id=${item.itemId}" 
                               class="btn btn-primary me-2">
                                <i class="fas fa-edit"></i> Edit Details
                            </a>
                            
                            <!-- Adjust Stock Button (only for active items) -->
                            <c:if test="${item.active}">
                                <a href="${pageContext.request.contextPath}/item/adjust-stock?id=${item.itemId}" 
                                   class="btn btn-info me-2">
                                    <i class="fas fa-boxes"></i> Adjust Stock
                                </a>
                            </c:if>
                            
                            <!-- Activate/Deactivate Button -->
                            <c:choose>
                                <c:when test="${item.active}">
                                    <!-- Deactivate Button for Active Items -->
                                    <button type="button" class="btn btn-warning" id="statusToggleBtn"
                                            onclick="toggleItemStatus(${item.itemId}, false)">
                                        <i class="fas fa-pause-circle"></i> Deactivate Item
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <!-- Activate Button for Inactive Items -->
                                    <button type="button" class="btn btn-success" id="statusToggleBtn"
                                            onclick="toggleItemStatus(${item.itemId}, true)">
                                        <i class="fas fa-play-circle"></i> Activate Item
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <!-- Additional Information -->
                        <div class="mt-4">
                            <small class="text-muted">
                                <i class="fas fa-info-circle"></i>
                                Created: <fmt:formatDate value="${item.createdAt}" pattern="yyyy-MM-dd HH:mm"/> |
                                Last Updated: <fmt:formatDate value="${item.updatedAt}" pattern="yyyy-MM-dd HH:mm"/>
                            </small>
                        </div>
                    </div>
                </div>
                
                <!-- Stock Movement History (Optional - if you want to show recent movements) -->
                <c:if test="${not empty stockHistory}">
                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">Recent Stock Movements</h6>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-sm">
                                    <thead>
                                        <tr>
                                            <th>Date</th>
                                            <th>Type</th>
                                            <th>Quantity</th>
                                            <th>Reason</th>
                                            <th>By</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${stockHistory}" var="movement" varStatus="loop">
                                            <c:if test="${loop.index < 5}">
                                                <tr>
                                                    <td><fmt:formatDate value="${movement.movementDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                                                    <td>
                                                        <span class="badge bg-info">${movement.movementType.displayName}</span>
                                                    </td>
                                                    <td>${movement.movementSymbol}${movement.quantity}</td>
                                                    <td>${movement.reason}</td>
                                                    <td>${movement.userName}</td>
                                                </tr>
                                            </c:if>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </c:if>
            </main>
    </div>
    
    <jsp:include page="/includes/footer.jsp" />
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
    function toggleItemStatus(itemId, activate) {
        var action = activate ? 'activate' : 'deactivate';
        var confirmMsg = activate ? 
            'Are you sure you want to activate this item?' : 
            'Are you sure you want to deactivate this item?';
        
        // Check stock before deactivation
        var stockQty = parseInt($('#stockQuantity').text());
        if (!activate && stockQty > 0) {
            confirmMsg += '\n\nWarning: This item has ' + stockQty + ' units in stock!';
            confirmMsg += '\nDeactivating will prevent sales but won\'t remove the stock.';
        }
        
        if (confirm(confirmMsg)) {
            // Create form and submit
            var form = $('<form>', {
                'method': 'POST',
                'action': '${pageContext.request.contextPath}/item/' + action
            });
            
            form.append($('<input>', {
                'type': 'hidden',
                'name': 'id',
                'value': itemId
            }));
            
            // Add force parameter if deactivating with stock
            if (!activate && stockQty > 0) {
                form.append($('<input>', {
                    'type': 'hidden',
                    'name': 'force',
                    'value': 'true'
                }));
            }
            
            form.appendTo('body').submit();
        }
    }
    
    // Alternative: AJAX implementation
    function toggleItemStatusAjax(itemId, activate) {
        var action = activate ? 'activate' : 'deactivate';
        
        $.ajax({
            url: '${pageContext.request.contextPath}/item/' + action,
            type: 'POST',
            data: {
                id: itemId,
                force: true // For items with stock
            },
            beforeSend: function(xhr) {
                xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
            },
            success: function(response) {
                if (response.success) {
                    // Update UI
                    location.reload(); // Simple reload, or update specific elements
                } else {
                    alert('Error: ' + response.error);
                }
            },
            error: function(xhr, status, error) {
                alert('Error: ' + error);
            }
        });
    }
    </script>
</body>
</html>