<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.pahanaedu.util.SessionUtil" %>
<%@ page import="com.pahanaedu.model.User" %>
<%
    User currentUser = SessionUtil.getLoggedInUser(session);
    String userRole = currentUser != null ? currentUser.getRole() : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Help - Pahana Edu Billing System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .help-section {
            margin-bottom: 40px;
        }
        .help-card {
            border-left: 4px solid #007bff;
            margin-bottom: 20px;
        }
        .help-card.admin {
            border-left-color: #dc3545;
        }
        .help-card.manager {
            border-left-color: #ffc107;
        }
        .help-card.cashier {
            border-left-color: #28a745;
        }
        .step-number {
            background-color: #007bff;
            color: white;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-right: 10px;
        }
        .shortcut-key {
            background-color: #f8f9fa;
            padding: 2px 6px;
            border-radius: 3px;
            border: 1px solid #dee2e6;
            font-family: monospace;
        }
    </style>
</head>
<body>
    <jsp:include page="/includes/navbar.jsp" />
    
    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <h2 class="mb-4"><i class="fas fa-question-circle"></i> Help & User Guide</h2>
                
                <!-- Quick Start Guide -->
                <div class="help-section">
                    <h4 class="mb-3">Quick Start Guide</h4>
                    <div class="card help-card">
                        <div class="card-body">
                            <h5 class="card-title">Creating Your First Bill</h5>
                            <ol class="mt-3">
                                <li class="mb-2">
                                    <span class="step-number">1</span>
                                    Navigate to <strong>Billing → Create Bill</strong>
                                </li>
                                <li class="mb-2">
                                    <span class="step-number">2</span>
                                    Select or add a customer
                                </li>
                                <li class="mb-2">
                                    <span class="step-number">3</span>
                                    Add items by searching and clicking "Add to Bill"
                                </li>
                                <li class="mb-2">
                                    <span class="step-number">4</span>
                                    Adjust quantities as needed
                                </li>
                                <li class="mb-2">
                                    <span class="step-number">5</span>
                                    Review total and click "Generate Bill"
                                </li>
                            </ol>
                        </div>
                    </div>
                </div>
                
                <!-- Role-Based Features -->
                <div class="help-section">
                    <h4 class="mb-3">Features by User Role</h4>
                    
                    <% if ("ADMIN".equals(userRole)) { %>
                    <div class="card help-card admin">
                        <div class="card-body">
                            <h5 class="card-title"><i class="fas fa-user-shield"></i> Admin Features</h5>
                            <ul class="mt-3">
                                <li>Full access to all system features</li>
                                <li>User management and role assignment</li>
                                <li>View and generate all types of reports</li>
                                <li>Manage items, customers, and billing</li>
                                <li>System configuration and settings</li>
                            </ul>
                        </div>
                    </div>
                    <% } %>
                    
                    <% if ("MANAGER".equals(userRole) || "ADMIN".equals(userRole)) { %>
                    <div class="card help-card manager">
                        <div class="card-body">
                            <h5 class="card-title"><i class="fas fa-user-tie"></i> Manager Features</h5>
                            <ul class="mt-3">
                                <li>Access to all reports (Sales, Stock, Customer)</li>
                                <li>Manage inventory and items</li>
                                <li>View and edit all bills</li>
                                <li>Customer management</li>
                                <li>Monitor daily operations</li>
                            </ul>
                        </div>
                    </div>
                    <% } %>
                    
                    <div class="card help-card cashier">
                        <div class="card-body">
                            <h5 class="card-title"><i class="fas fa-cash-register"></i> Cashier Features</h5>
                            <ul class="mt-3">
                                <li>Create and print bills</li>
                                <li>Add new customers</li>
                                <li>View item list and stock</li>
                                <li>Search and filter bills</li>
                                <li>Basic customer management</li>
                            </ul>
                        </div>
                    </div>
                </div>
                
                <!-- Common Tasks -->
                <div class="help-section">
                    <h4 class="mb-3">Common Tasks</h4>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="card mb-3">
                                <div class="card-body">
                                    <h6 class="card-title"><i class="fas fa-user-plus"></i> Adding a Customer</h6>
                                    <p class="card-text">Go to <strong>Customers → Add Customer</strong>. Fill in the required details and click Save.</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card mb-3">
                                <div class="card-body">
                                    <h6 class="card-title"><i class="fas fa-box"></i> Adding Items</h6>
                                    <p class="card-text">Navigate to <strong>Items → Add Item</strong>. Enter item details including name, price, and initial stock.</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card mb-3">
                                <div class="card-body">
                                    <h6 class="card-title"><i class="fas fa-search"></i> Finding Bills</h6>
                                    <p class="card-text">Use <strong>Billing → View Bills</strong> to search by bill number, customer name, or date range.</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card mb-3">
                                <div class="card-body">
                                    <h6 class="card-title"><i class="fas fa-warehouse"></i> Checking Stock</h6>
                                    <p class="card-text">Go to <strong>Items → Stock Status</strong> to view current inventory levels and low stock alerts.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Tips & Shortcuts -->
                <div class="help-section">
                    <h4 class="mb-3">Tips & Best Practices</h4>
                    <div class="card">
                        <div class="card-body">
                            <ul class="list-unstyled">
                                <li class="mb-2">
                                    <i class="fas fa-lightbulb text-warning"></i> 
                                    <strong>Quick Search:</strong> Use the search bars in lists to quickly find customers, items, or bills
                                </li>
                                <li class="mb-2">
                                    <i class="fas fa-lightbulb text-warning"></i> 
                                    <strong>Stock Alerts:</strong> Items with stock below 10 units will show a warning indicator
                                </li>
                                <li class="mb-2">
                                    <i class="fas fa-lightbulb text-warning"></i> 
                                    <strong>Print Bills:</strong> After generating a bill, use the Print button for a customer receipt
                                </li>
                                <li class="mb-2">
                                    <i class="fas fa-lightbulb text-warning"></i> 
                                    <strong>Dashboard:</strong> Check the dashboard regularly for today's sales summary and recent activities
                                </li>
                                <li class="mb-2">
                                    <i class="fas fa-lightbulb text-warning"></i> 
                                    <strong>Regular Backups:</strong> Admins should regularly backup the database for data safety
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                
                <!-- Contact Support -->
                <div class="help-section">
                    <div class="card bg-light">
                        <div class="card-body text-center">
                            <h5 class="card-title">Need More Help?</h5>
                            <p class="card-text">If you encounter any issues or need additional assistance, please contact your system administrator.</p>
                            <p class="mb-0">
                                <i class="fas fa-envelope"></i> Email: support@pahanaedu.com | 
                                <i class="fas fa-phone"></i> Phone: +94 11 234 5678
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>