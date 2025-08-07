<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bill #${bill.billNumber} - Pahana Edu</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .bill-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            border-radius: 10px 10px 0 0;
            margin: -1rem -1rem 0 -1rem;
        }
        .bill-status {
            display: inline-block;
            padding: 0.5rem 1rem;
            border-radius: 25px;
            font-weight: 500;
            background: rgba(255,255,255,0.2);
        }
        .bill-info-row {
            display: flex;
            justify-content: space-between;
            padding: 0.75rem 0;
            border-bottom: 1px solid #f0f0f0;
        }
        .bill-info-row:last-child {
            border-bottom: none;
        }
        .bill-info-label {
            color: #6c757d;
            font-weight: 500;
        }
        .bill-info-value {
            font-weight: 600;
            text-align: right;
        }
        .item-table th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: #495057;
        }
        .total-section {
            background-color: #f8f9fa;
            padding: 1.5rem;
            border-radius: 8px;
            margin-top: 1rem;
        }
        .total-row {
            display: flex;
            justify-content: space-between;
            padding: 0.5rem 0;
        }
        .total-row.grand-total {
            border-top: 2px solid #dee2e6;
            padding-top: 1rem;
            font-size: 1.25rem;
            font-weight: bold;
            color: #28a745;
        }
        .action-button {
            min-width: 120px;
        }
        .customer-info-card {
            background: #f8f9fa;
            border-left: 4px solid #007bff;
        }
        .timeline-item {
            position: relative;
            padding-left: 30px;
            margin-bottom: 20px;
        }
        .timeline-item:before {
            content: '';
            position: absolute;
            left: 0;
            top: 5px;
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: #007bff;
        }
        .timeline-item:after {
            content: '';
            position: absolute;
            left: 4px;
            top: 15px;
            width: 2px;
            height: calc(100% + 10px);
            background: #e9ecef;
        }
        .timeline-item:last-child:after {
            display: none;
        }
        @media print {
            .no-print {
                display: none !important;
            }
            .bill-header {
                background: none !important;
                color: black !important;
                -webkit-print-color-adjust: exact;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/includes/navbar.jsp" />
    
    <div class="container-fluid">
            <main class="px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom no-print">
                    <h1 class="h2">Bill Details</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2">
                            <button type="button" class="btn btn-primary" onclick="openPrintView()">
                                <i class="fas fa-print"></i> Print
                            </button>
                            <button type="button" class="btn btn-outline-secondary" onclick="downloadPDF()">
                                <i class="fas fa-file-pdf"></i> PDF
                            </button>
                            <!-- Email button removed -->
                        </div>
                        <a href="${pageContext.request.contextPath}/bill/list" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left"></i> Back
                        </a>
                    </div>
                </div>
                
                <jsp:include page="/includes/messages.jsp" />
                
                <div class="row">
                    <div class="col-lg-8">
                        <!-- Bill Main Content -->
                        <div class="card mb-4">
                            <div class="bill-header">
                                <div class="row align-items-center">
                                    <div class="col-md-8">
                                        <h2 class="mb-1">Bill #${bill.billNumber}</h2>
                                        <p class="mb-0">
                                            <fmt:formatDate value="${bill.billDate}" pattern="EEEE, dd MMMM yyyy"/> at 
                                            <fmt:formatDate value="${bill.billTime}" pattern="hh:mm a"/>
                                        </p>
                                    </div>
                                    <div class="col-md-4 text-md-end">
                                        <span class="bill-status">
                                            <i class="${paymentStatus.iconClass}"></i> ${paymentStatus.displayName}
                                        </span>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="card-body">
                                <!-- Customer Information -->
                                <div class="row mb-4">
                                    <div class="col-md-6">
                                        <h5 class="text-muted mb-3">Bill To</h5>
                                        <h6 class="mb-1">${bill.customer.customerName}</h6>
                                        <p class="mb-1 text-muted">
                                            <i class="fas fa-id-card"></i> ${bill.customer.accountNumber}
                                        </p>
                                        <p class="mb-1 text-muted">
                                            <i class="fas fa-phone"></i> ${bill.customer.telephone}
                                        </p>
                                        <p class="mb-0 text-muted">
                                            <i class="fas fa-map-marker-alt"></i> ${bill.customer.address}
                                        </p>
                                    </div>
                                    <div class="col-md-6">
                                        <h5 class="text-muted mb-3">Bill Information</h5>
                                        <div class="bill-info-row">
                                            <span class="bill-info-label">Created By:</span>
                                            <span class="bill-info-value">${bill.userName}</span>
                                        </div>
                                        <div class="bill-info-row">
                                            <span class="bill-info-label">Payment Method:</span>
                                            <span class="bill-info-value">
                                                <i class="${paymentMethod.iconClass}"></i> ${paymentMethod.displayName}
                                            </span>
                                        </div>
                                        <c:if test="${not empty bill.notes}">
                                            <div class="bill-info-row">
                                                <span class="bill-info-label">Notes:</span>
                                                <span class="bill-info-value">${bill.notes}</span>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                                
                                <!-- Items Table -->
                                <h5 class="mb-3">Items</h5>
                                <div class="table-responsive">
                                    <table class="table item-table">
                                        <thead>
                                            <tr>
                                                <th width="50">#</th>
                                                <th>Item</th>
                                                <th>Code</th>
                                                <th class="text-end">Price</th>
                                                <th class="text-center">Qty</th>
                                                <th class="text-end">Subtotal</th>
                                                <th class="text-end">Discount</th>
                                                <th class="text-end">Total</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${bill.billItems}" var="item" varStatus="status">
                                                <tr>
                                                    <td>${status.index + 1}</td>
                                                    <td>${item.itemName}</td>
                                                    <td>${item.itemCode}</td>
                                                    <td class="text-end">
                                                        <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="Rs. "/>
                                                    </td>
                                                    <td class="text-center">${item.quantity}</td>
                                                    <td class="text-end">
                                                        <fmt:formatNumber value="${item.unitPrice * item.quantity}" type="currency" currencySymbol="Rs. "/>
                                                    </td>
                                                    <td class="text-end">
                                                        <c:if test="${item.discountAmount > 0}">
                                                            <span class="text-danger">
                                                                -<fmt:formatNumber value="${item.discountAmount}" type="currency" currencySymbol="Rs. "/>
                                                                <small>(${item.discountPercentage}%)</small>
                                                            </span>
                                                        </c:if>
                                                        <c:if test="${item.discountAmount == 0}">
                                                            -
                                                        </c:if>
                                                    </td>
                                                    <td class="text-end">
                                                        <strong>
                                                            <fmt:formatNumber value="${item.totalPrice}" type="currency" currencySymbol="Rs. "/>
                                                        </strong>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                                
                                <!-- Totals Section -->
                                <div class="total-section">
                                    <div class="row">
                                        <div class="col-md-6 offset-md-6">
                                            <div class="total-row">
                                                <span>Subtotal:</span>
                                                <span><fmt:formatNumber value="${bill.subtotal}" type="currency" currencySymbol="Rs. "/></span>
                                            </div>
                                            <c:if test="${bill.discountAmount > 0}">
                                                <div class="total-row text-danger">
                                                    <span>Discount (${bill.discountPercentage}%):</span>
                                                    <span>-<fmt:formatNumber value="${bill.discountAmount}" type="currency" currencySymbol="Rs. "/></span>
                                                </div>
                                            </c:if>
                                            <c:if test="${bill.taxAmount > 0}">
                                                <div class="total-row">
                                                    <span>Tax (${bill.taxPercentage}%):</span>
                                                    <span><fmt:formatNumber value="${bill.taxAmount}" type="currency" currencySymbol="Rs. "/></span>
                                                </div>
                                            </c:if>
                                            <div class="total-row grand-total">
                                                <span>Total Amount:</span>
                                                <span><fmt:formatNumber value="${bill.totalAmount}" type="currency" currencySymbol="Rs. "/></span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Action Buttons (No Print) -->
                        <div class="card mb-4 no-print">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-12">
                                        <h5 class="mb-3">Actions</h5>
                                        <div class="d-flex flex-wrap gap-2">
                                            <c:if test="${canEdit}">
                                                <a href="${pageContext.request.contextPath}/bill/edit?id=${bill.billId}" 
                                                   class="btn btn-warning action-button">
                                                    <i class="fas fa-edit"></i> Edit Bill
                                                </a>
                                            </c:if>
                                            
                                            <c:if test="${canProcessPayment}">
                                                <button type="button" class="btn btn-success action-button" 
                                                        onclick="showPaymentModal()">
                                                    <i class="fas fa-dollar-sign"></i> Process Payment
                                                </button>
                                            </c:if>
                                            
                                            
                                            
                                            <c:if test="${canCancel}">
                                                <button type="button" class="btn btn-danger action-button" 
                                                        onclick="showCancelModal()">
                                                    <i class="fas fa-times"></i> Cancel Bill
                                                </button>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Sidebar Information -->
                    <div class="col-lg-4">
                        <!-- Customer Summary -->
                        <div class="card customer-info-card mb-4">
                            <div class="card-header">
                                <h5 class="mb-0">Customer Summary</h5>
                            </div>
                            <div class="card-body">
                                <div class="bill-info-row">
                                    <span class="bill-info-label">Total Purchases:</span>
                                    <span class="bill-info-value">${customerPurchaseSummary.totalBills}</span>
                                </div>
                                <div class="bill-info-row">
                                    <span class="bill-info-label">Total Spent:</span>
                                    <span class="bill-info-value">
                                        <fmt:formatNumber value="${customerPurchaseSummary.totalSpent}" 
                                                        type="currency" currencySymbol="Rs. "/>
                                    </span>
                                </div>
                                <div class="bill-info-row">
                                    <span class="bill-info-label">Average Bill:</span>
                                    <span class="bill-info-value">
                                        <fmt:formatNumber value="${customerPurchaseSummary.averageBill}" 
                                                        type="currency" currencySymbol="Rs. "/>
                                    </span>
                                </div>
                                <div class="bill-info-row">
                                    <span class="bill-info-label">Member Since:</span>
                                    <span class="bill-info-value">
                                        <fmt:formatDate value="${customerPurchaseSummary.firstPurchaseDate}" 
                                                      pattern="dd/MM/yyyy"/>
                                    </span>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Activity Timeline -->
                        <div class="card mb-4 no-print">
                            <div class="card-header">
                                <h5 class="mb-0">Activity Timeline</h5>
                            </div>
                            <div class="card-body">
                                <div class="timeline-item">
                                    <strong>Bill Created</strong>
                                    <p class="mb-0 text-muted small">
                                        <fmt:formatDate value="${bill.createdAt}" pattern="dd/MM/yyyy hh:mm a"/>
                                        by ${bill.userName}
                                    </p>
                                </div>
                                
                                <c:if test="${bill.paymentStatus == 'PAID'}">
                                    <div class="timeline-item">
                                        <strong>Payment Received</strong>
                                        <p class="mb-0 text-muted small">
                                            ${paymentMethod.displayName} payment processed
                                        </p>
                                    </div>
                                </c:if>
                                
                                <c:if test="${bill.paymentStatus == 'CANCELLED'}">
                                    <div class="timeline-item">
                                        <strong>Bill Cancelled</strong>
                                        <p class="mb-0 text-muted small">
                                            Reason: ${bill.notes}
                                        </p>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                        
                        <!-- Quick Actions -->
                        <div class="card mb-4 no-print">
                            <div class="card-header">
                                <h5 class="mb-0">Quick Actions</h5>
                            </div>
                            <div class="card-body">
                                <div class="d-grid gap-2">
                                    <button type="button" class="btn btn-outline-primary" onclick="openPrintView()">
                                        <i class="fas fa-print"></i> Print Bill
                                    </button>
                                    <button type="button" class="btn btn-outline-secondary" onclick="generateReceipt()">
                                        <i class="fas fa-receipt"></i> Generate Receipt
                                    </button>
                                    <button type="button" class="btn btn-outline-info" onclick="viewCustomer()">
                                        <i class="fas fa-user"></i> View Customer
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
    </div>
    
    <!-- Process Payment Modal -->
    <div class="modal fade" id="paymentModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form id="paymentForm" onsubmit="processPayment(event)">
                    <div class="modal-header">
                        <h5 class="modal-title">Process Payment</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Total Amount Due</label>
                            <div class="h4 text-success">
                                <fmt:formatNumber value="${bill.totalAmount}" type="currency" currencySymbol="Rs. "/>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="paymentMethodModal" class="form-label">Payment Method</label>
                            <select class="form-select" id="paymentMethodModal" required>
                                <option value="CASH">Cash</option>
                                <option value="CARD">Credit/Debit Card</option>
                                <option value="CHEQUE">Cheque</option>
                                <option value="BANK_TRANSFER">Bank Transfer</option>
                            </select>
                        </div>
                        <div class="mb-3" id="referenceFieldModal" style="display: none;">
                            <label for="paymentReferenceModal" class="form-label">Reference Number</label>
                            <input type="text" class="form-control" id="paymentReferenceModal" 
                                   placeholder="Enter cheque/transaction number">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-check"></i> Confirm Payment
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Cancel Bill Modal -->
    <div class="modal fade" id="cancelModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/bill/view" method="post" 
                      onsubmit="return confirm('Are you sure you want to cancel this bill?')">
                    <input type="hidden" name="billAction" value="cancel">
                    <input type="hidden" name="billId" value="${bill.billId}">
                    <div class="modal-header">
                        <h5 class="modal-title">Cancel Bill</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle"></i> 
                            This action cannot be undone. Stock levels will be adjusted accordingly.
                        </div>
                        <div class="mb-3">
                            <label for="cancellationReason" class="form-label">Cancellation Reason *</label>
                            <textarea class="form-control" id="cancellationReason" name="cancellationReason" 
                                      rows="3" required placeholder="Please provide a reason for cancellation"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-danger">
                            <i class="fas fa-times"></i> Cancel Bill
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Email Bill Modal has been removed -->
    
    <jsp:include page="/includes/footer.jsp" />
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        $(document).ready(function() {
            // Payment method change in modal
            $('#paymentMethodModal').on('change', function() {
                var method = $(this).val();
                if (method === 'CHEQUE' || method === 'BANK_TRANSFER') {
                    $('#referenceFieldModal').show();
                    $('#paymentReferenceModal').attr('required', true);
                } else {
                    $('#referenceFieldModal').hide();
                    $('#paymentReferenceModal').removeAttr('required');
                }
            });
        });
        
        function showPaymentModal() {
            $('#paymentModal').modal('show');
        }
        
        function showCancelModal() {
            $('#cancelModal').modal('show');
        }
        
        // Removed sendEmail function as it's no longer needed
        
        function processPayment(event) {
            event.preventDefault();
            
            var paymentMethod = $('#paymentMethodModal').val();
            var paymentReference = $('#paymentReferenceModal').val();
            
            $.ajax({
                url: '${pageContext.request.contextPath}/bill/view',
                type: 'POST',
                data: {
                    action: 'ajax',
                    ajaxAction: 'processPayment',
                    billId: ${bill.billId},
                    paymentMethod: paymentMethod,
                    paymentReference: paymentReference
                },
                success: function(response) {
                    if (response.success) {
                        alert('Payment processed successfully!');
                        location.reload();
                    } else {
                        alert('Error: ' + response.error);
                    }
                }
            });
        }
        
        function generateReceipt() {
            // Download as text receipt
            window.location.href = '${pageContext.request.contextPath}/bill/download/${bill.billId}/text';
        }
        
        function viewCustomer() {
            window.location.href = '${pageContext.request.contextPath}/customer/view?id=${bill.customerId}';
        }
        
        function downloadPDF() {
            // Download as HTML (user can save as PDF from browser)
            window.location.href = '${pageContext.request.contextPath}/bill/download/${bill.billId}';
        }
        
        function openPrintView() {
            // Open the dedicated print view
            var printWindow = window.open('${pageContext.request.contextPath}/bill/print/${bill.billId}', 
                                          'PrintBill', 
                                          'width=900,height=700');
            
            // Optional: Auto-print when window loads
            printWindow.onload = function() {
                setTimeout(function() {
                    printWindow.print();
                }, 500);
            };
        }
        
        // Print formatting
        window.addEventListener('beforeprint', function() {
            document.body.classList.add('printing');
        });
        
        window.addEventListener('afterprint', function() {
            document.body.classList.remove('printing');
        });
    </script>
</body>
</html>