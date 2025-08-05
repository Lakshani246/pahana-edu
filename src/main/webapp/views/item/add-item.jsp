<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Item - Pahana Edu</title>
    <jsp:include page="/includes/header.jsp" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <jsp:include page="/includes/navbar.jsp" />
    
    <div class="container-fluid">
        <div class="row">
            <jsp:include page="/includes/sidebar.jsp" />
            
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Add New Item</h1>
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
                        <form action="${pageContext.request.contextPath}/item/add" method="post">
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="itemCode" class="form-label">Item Code *</label>
                                    <input type="text" class="form-control ${validationErrors.itemCode != null ? 'is-invalid' : ''}" 
                                           id="itemCode" name="itemCode" value="${item.itemCode}" required>
                                    <c:if test="${validationErrors.itemCode != null}">
                                        <div class="invalid-feedback">${validationErrors.itemCode}</div>
                                    </c:if>
                                </div>
                                <div class="col-md-6">
                                    <label for="itemName" class="form-label">Item Name *</label>
                                    <input type="text" class="form-control ${validationErrors.itemName != null ? 'is-invalid' : ''}" 
                                           id="itemName" name="itemName" value="${item.itemName}" required>
                                    <c:if test="${validationErrors.itemName != null}">
                                        <div class="invalid-feedback">${validationErrors.itemName}</div>
                                    </c:if>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="description" class="form-label">Description</label>
                                <textarea class="form-control" id="description" name="description" rows="3">${item.description}</textarea>
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
                                    <input type="text" class="form-control" id="author" name="author" value="${item.author}">
                                </div>
                                <div class="col-md-4">
                                    <label for="publisher" class="form-label">Publisher</label>
                                    <input type="text" class="form-control" id="publisher" name="publisher" value="${item.publisher}">
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="isbn" class="form-label">ISBN</label>
                                    <input type="text" class="form-control" id="isbn" name="isbn" value="${item.isbn}">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Item Type</label>
                                    <input type="text" class="form-control" value="${item.isBook() ? 'Book' : 'Other'}" readonly>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <label for="unitPrice" class="form-label">Unit Price *</label>
                                    <input type="number" step="0.01" class="form-control ${validationErrors.unitPrice != null ? 'is-invalid' : ''}" 
                                           id="unitPrice" name="unitPrice" value="${item.unitPrice}" required>
                                    <c:if test="${validationErrors.unitPrice != null}">
                                        <div class="invalid-feedback">${validationErrors.unitPrice}</div>
                                    </c:if>
                                </div>
                                <div class="col-md-4">
                                    <label for="sellingPrice" class="form-label">Selling Price *</label>
                                    <input type="number" step="0.01" class="form-control ${validationErrors.sellingPrice != null ? 'is-invalid' : ''}" 
                                           id="sellingPrice" name="sellingPrice" value="${item.sellingPrice}" required>
                                    <c:if test="${validationErrors.sellingPrice != null}">
                                        <div class="invalid-feedback">${validationErrors.sellingPrice}</div>
                                    </c:if>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">Profit</label>
                                    <input type="text" class="form-control" value="Calculated automatically" readonly>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="quantityInStock" class="form-label">Quantity in Stock *</label>
                                    <input type="number" class="form-control ${validationErrors.quantityInStock != null ? 'is-invalid' : ''}" 
                                           id="quantityInStock" name="quantityInStock" value="${item.quantityInStock}" required>
                                    <c:if test="${validationErrors.quantityInStock != null}">
                                        <div class="invalid-feedback">${validationErrors.quantityInStock}</div>
                                    </c:if>
                                </div>
                                <div class="col-md-6">
                                    <label for="reorderLevel" class="form-label">Reorder Level *</label>
                                    <input type="number" class="form-control ${validationErrors.reorderLevel != null ? 'is-invalid' : ''}" 
                                           id="reorderLevel" name="reorderLevel" value="${item.reorderLevel}" required>
                                    <c:if test="${validationErrors.reorderLevel != null}">
                                        <div class="invalid-feedback">${validationErrors.reorderLevel}</div>
                                    </c:if>
                                </div>
                            </div>
                            
                            <div class="text-end">
                                <button type="reset" class="btn btn-secondary me-2">
                                    <i class="fas fa-undo"></i> Reset
                                </button>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Save Item
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>
    </div>
    
    <jsp:include page="/includes/footer.jsp" />
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/validation.js"></script>
    
    <script src="${pageContext.request.contextPath}/assets/js/validation.js"></script>
    <script>
        // Auto-detect book type based on ISBN
        $('#isbn').on('blur', function() {
            if($(this).val().trim() !== '') {
                $('#itemType').val('Book');
            } else {
                $('#itemType').val('Other');
            }
        });
    </script>
</body>
</html>