package com.pahanaedu.controller.report;

import com.pahanaedu.service.interfaces.ReportService;
import com.pahanaedu.service.impl.ReportServiceImpl;
import com.pahanaedu.dto.ReportDTO;
import com.pahanaedu.constant.SystemConstants;
import com.pahanaedu.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet for generating stock reports
 */
@WebServlet(name = "StockReportController", urlPatterns = {"/report/stock", "/report/inventory"})
public class StockReportController extends HttpServlet {
    
    private ReportService reportService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        reportService = new ReportServiceImpl();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        try {
            // Check report type
            String reportType = request.getParameter("type");
            ReportDTO report;
            
            if ("low-stock".equals(reportType)) {
                // Get threshold parameter
                String thresholdParam = request.getParameter("threshold");
                int threshold = 10; // Default threshold
                
                if (thresholdParam != null) {
                    try {
                        threshold = Integer.parseInt(thresholdParam);
                    } catch (NumberFormatException e) {
                        SessionUtil.setWarningMessage(session, 
                            "Invalid threshold value. Using default: " + threshold);
                    }
                }
                
                report = reportService.generateLowStockReport(threshold);
                request.setAttribute("threshold", threshold);
            } else {
                // Generate full stock report
                report = reportService.generateStockReport();
            }
            
            // Add username to report
            report.setGeneratedBy(SessionUtil.getLoggedInUsername(session));
            
            // Set attributes
            request.setAttribute("report", report);
            request.setAttribute("reportType", reportType);
            
            // Check if export is requested
            String export = request.getParameter("export");
            if ("csv".equalsIgnoreCase(export)) {
                exportToCSV(response, report);
                return;
            }
            
            // Forward to JSP
            request.getRequestDispatcher("/views/reports/stock-report.jsp").forward(request, response);
            
        } catch (Exception e) {
            log("Error generating stock report: " + e.getMessage(), e);
            SessionUtil.setErrorMessage(session, "Error generating report: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/dashboard");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Handle filter/threshold updates
        doGet(request, response);
    }
    
    /**
     * Export report to CSV
     */
    private void exportToCSV(HttpServletResponse response, ReportDTO report) 
            throws IOException {
        
        StringBuilder csv = new StringBuilder();
        
        // Header
        csv.append("Stock Report\n");
        csv.append("Generated: ").append(new java.util.Date()).append("\n\n");
        
        // Summary
        csv.append("Summary\n");
        csv.append("Total Items,").append(report.getTotalItems()).append("\n");
        csv.append("Low Stock Items,").append(report.getLowStockItems()).append("\n");
        csv.append("Out of Stock Items,").append(report.getOutOfStockItems()).append("\n");
        csv.append("Total Stock Value,").append(report.getTotalStockValue()).append("\n\n");
        
        // Stock by category
        if (report.getStockByCategory() != null && !report.getStockByCategory().isEmpty()) {
            csv.append("Stock by Category\n");
            csv.append("Category,Item Count,Stock Value\n");
            
            for (java.util.Map<String, Object> cat : report.getStockByCategory()) {
                csv.append(cat.get("category")).append(",");
                csv.append(cat.get("itemCount")).append(",");
                csv.append(cat.get("stockValue")).append("\n");
            }
            csv.append("\n");
        }
        
        // Low stock items
        if (report.getLowStockList() != null && !report.getLowStockList().isEmpty()) {
            csv.append("Low Stock Items\n");
            csv.append("Item Code,Item Name,Current Stock,Reorder Level\n");
            
            for (java.util.Map<String, Object> item : report.getLowStockList()) {
                csv.append(item.get("itemCode")).append(",");
                csv.append(item.get("itemName")).append(",");
                csv.append(item.get("currentStock")).append(",");
                csv.append(item.get("reorderLevel")).append("\n");
            }
        }
        
        // Set response headers
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", 
            "attachment; filename=\"stock-report-" + 
            new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) + ".csv\"");
        
        // Write CSV
        response.getWriter().write(csv.toString());
    }
    
    @Override
    public String getServletInfo() {
        return "Stock Report Controller - Generates stock and inventory reports";
    }
}