<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Adjust Stock - Pahana Edu</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .stock-badge {
            font-size: 1.2rem;
            padding: 8px 16px;
        }
        .movement-history {
            max-height: 400px;
            overflow-y: auto;
        }
        .movement-in { color: #28a745; }
        .movement-out { color: #dc3545; }
        .movement-adjustment { color: #ffc107; }
    </style>
</head>
<body>
    <jsp:include page="/includes/navbar.jsp" />
    
    <div class="container-fluid">
            
            <main class="px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Stock Adjustment</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/item/stock" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back to Stock Status
                        </a>
                    </div>
                </div>
                
                <jsp:include page="/includes/messages.jsp" />
                
                <div class="row">
                    <!-- Item Information Card -->
                    <div class="col-md-4">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3 bg-info text-white">
                                <h6 class="m-0 font-weight-bold">Item Information</h6>
                            </div>
                            <div class="card-body">
                                <table class="table table-sm table-borderless">
                                    <tr>
                                        <th width="40%">Code:</th>
                                        <td><strong>${item.itemCode}</strong></td>
                                    </tr>
                                    <tr>
                                        <th>Name:</th>
                                        <td>${item.itemName}</td>
                                    </tr>
                                    <tr>
                                        <th>Category:</th>
                                        <td>${item.categoryName}</td>
                                    </tr>
                                    <tr>
                                        <th>Unit Price:</th>
                                        <td>LKR <fmt:formatNumber value="${item.unitPrice}" pattern="#,##0.00"/></td>
                                    </tr>
                                    <tr>
                                        <th>Current Stock:</th>
                                        <td>
                                            <span class="badge stock-badge bg-${item.stockStatusClass}">
                                                ${item.quantityInStock} units
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>Reorder Level:</th>
                                        <td>${item.reorderLevel} units</td>
                                    </tr>
                                    <tr>
                                        <th>Status:</th>
                                        <td>
                                            <span class="badge bg-${item.stockStatusClass}">
                                                ${item.stockStatus}
                                            </span>
                                        </td>
                                    </tr>
                                </table>
                                
                                <c:if test="${item.quantityInStock <= item.reorderLevel}">
                                    <div class="alert alert-warning mt-3" role="alert">
                                        <i class="fas fa-exclamation-triangle"></i>
                                        <c:choose>
                                            <c:when test="${item.quantityInStock == 0}">
                                                <strong>Out of Stock!</strong>
                                            </c:when>
                                            <c:otherwise>
                                                <strong>Low Stock Alert!</strong>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Stock Adjustment Form -->
                    <div class="col-md-8">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3 bg-primary text-white">
                                <h6 class="m-0 font-weight-bold">Adjust Stock Level</h6>
                            </div>
                            <div class="card-body">
                                <form action="${pageContext.request.contextPath}/item/adjust-stock" method="post" id="adjustStockForm">
                                    <input type="hidden" name="itemId" value="${item.itemId}">
                                    
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="movementType" class="form-label">Movement Type *</label>
                                            <select class="form-select" id="movementType" name="movementType" required>
                                                <option value="">Select Movement Type</option>
                                                <optgroup label="Stock Increase">
                                                    <option value="IN" data-color="success">Stock In (Purchase/Delivery)</option>
                                                    <option value="RETURN" data-color="success">Customer Return</option>
                                                </optgroup>
                                                <optgroup label="Stock Decrease">
                                                    <option value="OUT" data-color="danger">Stock Out (Manual Sale)</option>
                                                    <option value="DAMAGE" data-color="danger">Damaged/Expired</option>
                                                </optgroup>
                                                <optgroup label="Adjustment">
                                                    <option value="ADJUSTMENT" data-color="warning">Stock Adjustment (Set to specific value)</option>
                                                </optgroup>
                                            </select>
                                            <small class="text-muted">Select the type of stock movement</small>
                                        </div>
                                        
                                        <div class="col-md-6">
                                            <label for="quantity" class="form-label">
                                                <span id="quantityLabel">Quantity *</span>
                                            </label>
                                            <div class="input-group">
                                                <span class="input-group-text" id="quantityPrefix">+</span>
                                                <input type="number" class="form-control" id="quantity" name="quantity" 
                                                       min="1" required>
                                                <span class="input-group-text">units</span>
                                            </div>
                                            <small class="text-muted" id="quantityHelp">Enter the quantity to add/remove</small>
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="reason" class="form-label">Reason/Notes *</label>
                                        <textarea class="form-control" id="reason" name="reason" rows="3" 
                                                  required maxlength="500"
                                                  placeholder="Provide a reason for this stock adjustment..."></textarea>
                                        <small class="text-muted">This will be recorded in the stock movement history</small>
                                    </div>
                                    
                                    <!-- Preview Section -->
                                    <div class="alert alert-info d-none" id="previewSection">
                                        <h6>Preview:</h6>
                                        <p class="mb-1">Current Stock: <strong>${item.quantityInStock} units</strong></p>
                                        <p class="mb-1">Operation: <strong id="previewOperation">-</strong></p>
                                        <p class="mb-0">New Stock Level: <strong id="previewNewStock">-</strong></p>
                                    </div>
                                    
                                    <div class="text-end">
                                        <button type="button" class="btn btn-secondary me-2" onclick="window.history.back()">
                                            <i class="fas fa-times"></i> Cancel
                                        </button>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save"></i> Confirm Adjustment
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                        
                        <!-- Recent Movement History -->
                        <div class="card shadow">
                            <div class="card-header py-3">
                                <h6 class="m-0 font-weight-bold text-primary">Recent Stock Movements</h6>
                            </div>
                            <div class="card-body movement-history">
                                <c:choose>
                                    <c:when test="${not empty stockHistory}">
                                        <div class="table-responsive">
                                            <table class="table table-sm table-hover">
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
                                                    <c:forEach items="${stockHistory}" var="movement">
                                                        <tr>
                                                            <td>
                                                                <fmt:formatDate value="${movement.movementDate}" 
                                                                              pattern="yyyy-MM-dd HH:mm"/>
                                                            </td>
                                                            <td>
                                                                <span class="badge bg-${movement.movementClass}">
                                                                    ${movement.movementType.displayName}
                                                                </span>
                                                            </td>
                                                            <td class="${movement.movementClass}">
                                                                <strong>
                                                                    ${movement.movementSymbol}${movement.absoluteQuantity}
                                                                </strong>
                                                            </td>
                                                            <td>${movement.reason}</td>
                                                            <td>${movement.userName}</td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="text-muted text-center">No stock movement history available</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
    </div>
    
    <jsp:include page="/includes/footer.jsp" />
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
    $(document).ready(function() {
        var currentStock = ${item.quantityInStock};
        
        // Handle movement type change
        $('#movementType').on('change', function() {
            var selectedType = $(this).val();
            var selectedOption = $(this).find('option:selected');
            var color = selectedOption.data('color');
            
            // Update quantity label and prefix based on type
            switch(selectedType) {
                case 'IN':
                case 'RETURN':
                    $('#quantityLabel').text('Quantity to Add *');
                    $('#quantityPrefix').text('+').removeClass().addClass('input-group-text text-success');
                    $('#quantityHelp').text('Enter the quantity to add to stock');
                    break;
                    
                case 'OUT':
                case 'DAMAGE':
                    $('#quantityLabel').text('Quantity to Remove *');
                    $('#quantityPrefix').text('-').removeClass().addClass('input-group-text text-danger');
                    $('#quantityHelp').text('Enter the quantity to remove from stock');
                    break;
                    
                case 'ADJUSTMENT':
                    $('#quantityLabel').text('New Stock Level *');
                    $('#quantityPrefix').text('=').removeClass().addClass('input-group-text text-warning');
                    $('#quantityHelp').text('Enter the new total stock quantity');
                    break;
                    
                default:
                    $('#quantityLabel').text('Quantity *');
                    $('#quantityPrefix').text('').removeClass().addClass('input-group-text');
                    $('#quantityHelp').text('Enter the quantity');
            }
            
            updatePreview();
        });
        
        // Handle quantity change
        $('#quantity').on('input', function() {
            updatePreview();
        });
        
        // Update preview section
        function updatePreview() {
            var movementType = $('#movementType').val();
            var quantity = parseInt($('#quantity').val()) || 0;
            
            if (movementType && quantity > 0) {
                var newStock = currentStock;
                var operation = '';
                
                switch(movementType) {
                    case 'IN':
                    case 'RETURN':
                        newStock = currentStock + quantity;
                        operation = 'Adding ' + quantity + ' units';
                        break;
                        
                    case 'OUT':
                    case 'DAMAGE':
                        newStock = currentStock - quantity;
                        operation = 'Removing ' + quantity + ' units';
                        break;
                        
                    case 'ADJUSTMENT':
                        newStock = quantity;
                        var diff = quantity - currentStock;
                        operation = 'Adjusting to ' + quantity + ' units (' + 
                                  (diff >= 0 ? '+' : '') + diff + ')';
                        break;
                }
                
                $('#previewOperation').text(operation);
                $('#previewNewStock').text(newStock + ' units');
                
                // Show warning if stock will be negative
                if (newStock < 0) {
                    $('#previewNewStock').addClass('text-danger').append(' (INVALID - Cannot be negative!)');
                } else if (newStock === 0) {
                    $('#previewNewStock').addClass('text-warning').append(' (Out of Stock)');
                } else if (newStock <= ${item.reorderLevel}) {
                    $('#previewNewStock').addClass('text-warning').append(' (Low Stock)');
                } else {
                    $('#previewNewStock').removeClass('text-danger text-warning');
                }
                
                $('#previewSection').removeClass('d-none');
            } else {
                $('#previewSection').addClass('d-none');
            }
        }
        
        // Form validation
        $('#adjustStockForm').on('submit', function(e) {
            var movementType = $('#movementType').val();
            var quantity = parseInt($('#quantity').val()) || 0;
            var reason = $('#reason').val().trim();
            
            if (!movementType) {
                alert('Please select a movement type');
                e.preventDefault();
                return false;
            }
            
            if (quantity <= 0) {
                alert('Quantity must be greater than zero');
                e.preventDefault();
                return false;
            }
            
            if (!reason) {
                alert('Please provide a reason for this adjustment');
                e.preventDefault();
                return false;
            }
            
            // Check for negative stock
            var newStock = currentStock;
            if (movementType === 'OUT' || movementType === 'DAMAGE') {
                newStock = currentStock - quantity;
                if (newStock < 0) {
                    alert('Error: This adjustment would result in negative stock!\n' +
                          'Current stock: ' + currentStock + '\n' +
                          'Trying to remove: ' + quantity);
                    e.preventDefault();
                    return false;
                }
            }
            
            // Confirmation for critical operations
            if (movementType === 'ADJUSTMENT') {
                if (!confirm('Are you sure you want to adjust the stock level to ' + quantity + ' units?')) {
                    e.preventDefault();
                    return false;
                }
            } else if (movementType === 'DAMAGE') {
                if (!confirm('Are you sure you want to mark ' + quantity + ' units as damaged/expired?')) {
                    e.preventDefault();
                    return false;
                }
            }
            
            return true;
        });
    });
    </script>
</body>
</html>