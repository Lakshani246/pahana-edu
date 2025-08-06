package com.pahanaedu.controller.report;

import com.pahanaedu.service.interfaces.ReportService;
import com.pahanaedu.service.impl.ReportServiceImpl;
import com.pahanaedu.dto.ReportDTO;
import com.pahanaedu.constant.SystemConstants;
import com.pahanaedu.util.SessionUtil;
import com.pahanaedu.util.DateUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.ParseException;
import java.util.Date;

/**
 * Servlet for generating daily sales reports
 */
@WebServlet(name = "DailySalesReportController", urlPatterns = {"/report/daily-sales", "/report/daily"})
public class DailySalesReportController extends HttpServlet {
    
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
            // Get report date parameter (null for today)
            String dateParam = request.getParameter("date");
            Date reportDate = null;
            
            if (dateParam != null && !dateParam.trim().isEmpty()) {
                try {
                    reportDate = DateUtil.parseDate(dateParam);
                } catch (ParseException e) {
                    SessionUtil.setErrorMessage(session, "Invalid date format. Using today's date.");
                    reportDate = new Date();
                }
            } else {
                reportDate = new Date();
            }
            
            // Generate report
            ReportDTO report = reportService.generateDailySalesReport(reportDate);
            
            // Add username to report
            report.setGeneratedBy(SessionUtil.getLoggedInUsername(session));
            
            // Set attributes
            request.setAttribute("report", report);
            request.setAttribute("reportDate", reportDate);
            
            // Check if export is requested
            String export = request.getParameter("export");
            if ("csv".equalsIgnoreCase(export)) {
                exportToCSV(response, report);
                return;
            }
            
            // Forward to JSP
            request.getRequestDispatcher("/views/reports/daily-sales.jsp").forward(request, response);
            
        } catch (Exception e) {
            log("Error generating daily sales report: " + e.getMessage(), e);
            SessionUtil.setErrorMessage(session, "Error generating report: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/dashboard");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Handle date range selection
        String action = request.getParameter("action");
        
        if ("generate".equals(action)) {
            doGet(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/report/daily-sales");
        }
    }
    
    /**
     * Export report to CSV
     */
    private void exportToCSV(HttpServletResponse response, ReportDTO report) 
            throws IOException {
        
        String csv = reportService.exportReportToCSV(report);
        
        // Set response headers
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", 
            "attachment; filename=\"daily-sales-report-" + 
            DateUtil.formatDate(report.getStartDate()) + ".csv\"");
        
        // Write CSV
        response.getWriter().write(csv);
    }
    
    @Override
    public String getServletInfo() {
        return "Daily Sales Report Controller - Generates daily sales reports";
    }
}