package com.pahanaedu.controller.billing;

import com.pahanaedu.service.interfaces.BillingService;
import com.pahanaedu.service.impl.BillingServiceImpl;
import com.pahanaedu.model.Bill;
import com.pahanaedu.util.SimplePDFGenerator;
import com.pahanaedu.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Servlet for downloading bills as PDF/HTML
 */
@WebServlet(name = "PDFDownloadController", urlPatterns = {"/bill/download/*"})
public class PDFDownloadController extends HttpServlet {
    
    private BillingService billingService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        billingService = new BillingServiceImpl();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        try {
            // Extract bill ID from URL
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.length() <= 1) {
                throw new IllegalArgumentException("Bill ID is required");
            }
            
            String[] pathParts = pathInfo.substring(1).split("/");
            int billId = Integer.parseInt(pathParts[0]);
            String format = pathParts.length > 1 ? pathParts[1] : "html";
            
            // Get bill details
            Bill bill = billingService.getBillById(billId);
            
            if (bill == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Bill not found");
                return;
            }
            
            // Company info (you can load this from database/settings)
            String companyName = "Pahana Edu Bookshop";
            String companyAddress = "123 Main Street, Colombo 07";
            String companyPhone = "011-2345678";
            
            if ("text".equalsIgnoreCase(format)) {
                // Generate text format
                String billText = SimplePDFGenerator.generateBillText(bill, companyName);
                
                response.setContentType("text/plain");
                response.setHeader("Content-Disposition", 
                    "attachment; filename=\"Bill_" + bill.getBillNumber() + ".txt\"");
                
                PrintWriter out = response.getWriter();
                out.print(billText);
                out.flush();
                
            } else {
                // Generate HTML format (default)
                String billHTML = SimplePDFGenerator.generateBillHTML(bill, 
                    companyName, companyAddress, companyPhone);
                
                response.setContentType("text/html");
                response.setHeader("Content-Disposition", 
                    "attachment; filename=\"Bill_" + bill.getBillNumber() + ".html\"");
                
                PrintWriter out = response.getWriter();
                out.print(billHTML);
                out.flush();
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid bill ID format");
        } catch (Exception e) {
            log("Error generating bill download: " + e.getMessage(), e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Error generating bill: " + e.getMessage());
        }
    }
    
    @Override
    public String getServletInfo() {
        return "PDF Download Controller - Downloads bills in various formats";
    }
}