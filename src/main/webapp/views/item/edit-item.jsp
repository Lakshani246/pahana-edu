<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Item - Pahana Edu</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <jsp:include page="/includes/navbar.jsp" />
    
    <div class="container-fluid">
            <main class="px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Edit Item</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/item/list" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back to List
                        </a>
                    </div>
                </div>
                
                <jsp:include page="/includes/messages.jsp" />
                
                <div class="card shadow mb-4">
                    <div class="card-header py-3">
                        <h6 class="m-0 font-weight-bold text-primary">Item Information</h6>
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/item/edit" method="post" id="editItemForm">
                            <input type="hidden" name="itemId" value="${item.itemId}">
                            <input type="hidden" name="itemCode" value="${item.itemCode}">
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label class="form-label">Item Code</label>
                                    <input type="text" class="form-control bg-light" value="${item.itemCode}" readonly disabled>
                                    <small class="text-muted">Item code cannot be changed</small>
                                </div>
                                <div class="col-md-6">
                                    <label for="itemName" class="form-label">Item Name *</label>
                                    <input type="text" class="form-control ${validationErrors.itemName != null ? 'is-invalid' : ''}" 
                                           id="itemName" name="itemName" value="${item.itemName}" required maxlength="100">
                                    <c:if test="${validationErrors.itemName != null}">
                                        <div class="invalid-feedback">${validationErrors.itemName}</div>
                                    </c:if>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="description" class="form-label">Description</label>
                                <textarea class="form-control ${validationErrors.description != null ? 'is-invalid' : ''}" 
                                          id="description" name="description" rows="3" maxlength="500">${item.description}</textarea>
                                <small class="text-muted">Optional: Provide a detailed description of the item</small>
                                <c:if test="${validationErrors.description != null}">
                                    <div class="invalid-feedback">${validationErrors.description}</div>
                                </c:if>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <label for="categoryId" class="form-label">Category *</label>
                                    <select class="form-select ${validationErrors.categoryId != null ? 'is-invalid' : ''}" 
                                            id="categoryId" name="categoryId" required>
                                        <option value="">Select Category</option>
                                        <c:forEach items="${categories}" var="category">
                                            <option value="${category.categoryId}" 
                                                ${item.categoryId == category.categoryId ? 'selected' : ''}>
                                                ${category.categoryName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <c:if test="${validationErrors.categoryId != null}">
                                        <div class="invalid-feedback">${validationErrors.categoryId}</div>
                                    </c:if>
                                </div>
                                <div class="col-md-4">
                                    <label for="author" class="form-label">Author</label>
                                    <input type="text" class="form-control ${validationErrors.author != null ? 'is-invalid' : ''}" 
                                           id="author" name="author" value="${item.author}" maxlength="100">
                                    <small class="text-muted">For books only</small>
                                    <c:if test="${validationErrors.author != null}">
                                        <div class="invalid-feedback">${validationErrors.author}</div>
                                    </c:if>
                                </div>
                                <div class="col-md-4">
                                    <label for="publisher" class="form-label">Publisher</label>
                                    <input type="text" class="form-control ${validationErrors.publisher != null ? 'is-invalid' : ''}" 
                                           id="publisher" name="publisher" value="${item.publisher}" maxlength="100">
                                    <small class="text-muted">For books only</small>
                                    <c:if test="${validationErrors.publisher != null}">
                                        <div class="invalid-feedback">${validationErrors.publisher}</div>
                                    </c:if>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="isbn" class="form-label">ISBN</label>
                                    <input type="text" class="form-control ${validationErrors.isbn != null ? 'is-invalid' : ''}" 
                                           id="isbn" name="isbn" value="${item.isbn}" maxlength="20">
                                    <small class="text-muted">10 or 13 digit ISBN (for books)</small>
                                    <c:if test="${validationErrors.isbn != null}">
                                        <div class="invalid-feedback">${validationErrors.isbn}</div>
                                    </c:if>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Status</label>
                                    <div class="form-control bg-light">
                                        <span class="badge ${item.active ? 'bg-success' : 'bg-danger'}">
                                            ${item.active ? 'Active' : 'Inactive'}
                                        </span>
                                    </div>
                                    <small class="text-muted">Status cannot be changed from this form</small>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <label for="unitPrice" class="form-label">Unit Price (LKR) *</label>
                                    <div class="input-group">
                                        <span class="input-group-text">Rs.</span>
                                        <input type="number" step="0.01" min="0" 
                                               class="form-control ${validationErrors.unitPrice != null ? 'is-invalid' : ''}" 
                                               id="unitPrice" name="unitPrice" value="${item.unitPrice}" required>
                                        <c:if test="${validationErrors.unitPrice != null}">
                                            <div class="invalid-feedback">${validationErrors.unitPrice}</div>
                                        </c:if>
                                    </div>
                                    <small class="text-muted">Cost price of the item</small>
                                </div>
                                <div class="col-md-4">
                                    <label for="sellingPrice" class="form-label">Selling Price (LKR) *</label>
                                    <div class="input-group">
                                        <span class="input-group-text">Rs.</span>
                                        <input type="number" step="0.01" min="0" 
                                               class="form-control ${validationErrors.sellingPrice != null ? 'is-invalid' : ''}" 
                                               id="sellingPrice" name="sellingPrice" value="${item.sellingPrice}" required>
                                        <c:if test="${validationErrors.sellingPrice != null}">
                                            <div class="invalid-feedback">${validationErrors.sellingPrice}</div>
                                        </c:if>
                                    </div>
                                    <small class="text-muted">Price for customers</small>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">Profit Margin</label>
                                    <div class="input-group">
                                        <span class="input-group-text">Rs.</span>
                                        <div class="form-control bg-light" id="profitDisplay">
                                            <span id="profitValue"><fmt:formatNumber value="${item.profit}" pattern="#,##0.00"/></span>
                                        </div>
                                        <span class="input-group-text" id="profitPercentage">
                                            (<fmt:formatNumber value="${item.profitMargin}" pattern="#0.0"/>%)
                                        </span>
                                    </div>
                                    <small class="text-muted">Auto-calculated profit</small>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="quantityInStock" class="form-label">Quantity in Stock *</label>
                                    <div class="input-group">
                                        <input type="number" min="0" 
                                               class="form-control ${validationErrors.quantityInStock != null ? 'is-invalid' : ''}" 
                                               id="quantityInStock" name="quantityInStock" value="${item.quantityInStock}" required>
                                        <span class="input-group-text">units</span>
                                        <c:if test="${validationErrors.quantityInStock != null}">
                                            <div class="invalid-feedback">${validationErrors.quantityInStock}</div>
                                        </c:if>
                                    </div>
                                    <small class="text-muted">Current stock level</small>
                                </div>
                                <div class="col-md-6">
                                    <label for="reorderLevel" class="form-label">Reorder Level *</label>
                                    <div class="input-group">
                                        <input type="number" min="0" 
                                               class="form-control ${validationErrors.reorderLevel != null ? 'is-invalid' : ''}" 
                                               id="reorderLevel" name="reorderLevel" value="${item.reorderLevel}" required>
                                        <span class="input-group-text">units</span>
                                        <c:if test="${validationErrors.reorderLevel != null}">
                                            <div class="invalid-feedback">${validationErrors.reorderLevel}</div>
                                        </c:if>
                                    </div>
                                    <small class="text-muted">Alert when stock falls below this level</small>
                                </div>
                            </div>
                            
                            <!-- Stock Status Alert -->
                            <c:if test="${item.quantityInStock <= item.reorderLevel}">
                                <div class="alert alert-warning d-flex align-items-center mb-3" role="alert">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    <div>
                                        <c:choose>
                                            <c:when test="${item.quantityInStock == 0}">
                                                <strong>Out of Stock!</strong> This item is currently out of stock.
                                            </c:when>
                                            <c:otherwise>
                                                <strong>Low Stock Alert!</strong> Current stock (${item.quantityInStock}) is at or below reorder level.
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </c:if>
                            
                            <hr class="my-4">
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <small class="text-muted">
                                        <i class="fas fa-info-circle"></i> 
                                        Last updated: <fmt:formatDate value="${item.updatedAt}" pattern="yyyy-MM-dd HH:mm"/>
                                    </small>
                                </div>
                                <div class="col-md-6 text-end">
                                    <button type="reset" class="btn btn-secondary me-2">
                                        <i class="fas fa-undo"></i> Reset Changes
                                    </button>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save"></i> Update Item
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
    </div>
    
    <jsp:include page="/includes/footer.jsp" />
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
    $(document).ready(function() {
        // Function to calculate and display profit
        function calculateProfit() {
            var unitPrice = parseFloat($('#unitPrice').val()) || 0;
            var sellingPrice = parseFloat($('#sellingPrice').val()) || 0;
            var profit = sellingPrice - unitPrice;
            var profitMargin = unitPrice > 0 ? ((profit / unitPrice) * 100) : 0;
            
            // Format profit value with commas
            $('#profitValue').text(profit.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ","));
            $('#profitPercentage').text('(' + profitMargin.toFixed(1) + '%)');
            
            // Apply color coding based on profit
            var profitDisplay = $('#profitDisplay');
            profitDisplay.removeClass('bg-light bg-success bg-warning bg-danger text-white text-dark');
            
            if (profit < 0) {
                profitDisplay.addClass('bg-danger text-white');
            } else if (profit === 0) {
                profitDisplay.addClass('bg-warning');
            } else if (profitMargin > 20) {
                profitDisplay.addClass('bg-success text-white');
            } else {
                profitDisplay.addClass('bg-light');
            }
        }
        
        // Function to check stock levels
        function checkStockLevel() {
            var quantity = parseInt($('#quantityInStock').val()) || 0;
            var reorderLevel = parseInt($('#reorderLevel').val()) || 0;
            
            // Remove existing alert if any
            $('.stock-alert-dynamic').remove();
            
            if (quantity <= reorderLevel && quantity >= 0) {
                var alertMessage = quantity === 0 ? 
                    '<strong>Out of Stock!</strong> This item will be out of stock after update.' :
                    '<strong>Low Stock Warning!</strong> Stock level will be at or below reorder level.';
                
                var alertHtml = '<div class="alert alert-warning d-flex align-items-center stock-alert-dynamic mb-3" role="alert">' +
                               '<i class="fas fa-exclamation-triangle me-2"></i>' +
                               '<div>' + alertMessage + '</div></div>';
                
                $(alertHtml).insertBefore('hr.my-4');
            }
        }
        
        // Calculate profit on page load
        calculateProfit();
        
        // Recalculate when prices change
        $('#unitPrice, #sellingPrice').on('input', calculateProfit);
        
        // Check stock levels when quantities change
        $('#quantityInStock, #reorderLevel').on('input', checkStockLevel);
        
        // Form validation before submission
        $('#editItemForm').on('submit', function(e) {
            var unitPrice = parseFloat($('#unitPrice').val()) || 0;
            var sellingPrice = parseFloat($('#sellingPrice').val()) || 0;
            var quantity = parseInt($('#quantityInStock').val()) || 0;
            var reorderLevel = parseInt($('#reorderLevel').val()) || 0;
            
            // Validate prices
            if (unitPrice < 0 || sellingPrice < 0) {
                alert('Prices cannot be negative!');
                e.preventDefault();
                return false;
            }
            
            // Warning for selling below cost
            if (sellingPrice < unitPrice) {
                if (!confirm('Warning: Selling price is less than unit price. This will result in a loss of Rs. ' + 
                           (unitPrice - sellingPrice).toFixed(2) + ' per unit.\n\nDo you want to continue?')) {
                    e.preventDefault();
                    return false;
                }
            }
            
            // Validate quantities
            if (quantity < 0 || reorderLevel < 0) {
                alert('Quantities cannot be negative!');
                e.preventDefault();
                return false;
            }
            
            // Warning for out of stock
            if (quantity === 0) {
                if (!confirm('Warning: This item is currently out of stock. Continue with update?')) {
                    e.preventDefault();
                    return false;
                }
            }
            
            return true;
        });
        
        // ISBN formatting (optional)
        $('#isbn').on('blur', function() {
            var isbn = $(this).val().replace(/[^0-9X]/gi, '');
            if (isbn.length === 10 || isbn.length === 13) {
                $(this).removeClass('is-invalid');
            } else if (isbn.length > 0) {
                $(this).addClass('is-invalid');
                if (!$(this).next('.invalid-feedback').length) {
                    $(this).after('<div class="invalid-feedback">ISBN must be 10 or 13 digits</div>');
                }
            }
        });
    });
    </script>
</body>
</html>