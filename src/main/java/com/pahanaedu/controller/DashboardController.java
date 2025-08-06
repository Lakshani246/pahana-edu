package com.pahanaedu.controller;

import com.pahanaedu.service.interfaces.AuthService;
import com.pahanaedu.service.impl.AuthServiceImpl;
import com.pahanaedu.service.interfaces.ReportService;
import com.pahanaedu.service.impl.ReportServiceImpl;
import com.pahanaedu.dto.DashboardDTO;
import com.pahanaedu.dao.interfaces.UserDAO;
import com.pahanaedu.dao.impl.UserDAOImpl;
import com.pahanaedu.model.User;
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
 * Servlet for handling dashboard display with integrated reports
 */
@WebServlet(name = "DashboardController", urlPatterns = {"/dashboard"})
public class DashboardController extends HttpServlet {
    
    private AuthService authService;
    private ReportService reportService;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        authService = new AuthServiceImpl();
        reportService = new ReportServiceImpl();
        userDAO = new UserDAOImpl();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User loggedUser = SessionUtil.getLoggedInUser(session);
        
        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + SystemConstants.URL_LOGIN);
            return;
        }
        
        try {
            // Generate dashboard statistics using ReportService
            DashboardDTO dashboardStats = reportService.generateDashboardStatistics();
            
            // Set current user
            request.setAttribute("currentUser", loggedUser);
            
            // Set dashboard statistics
            request.setAttribute("dashboardStats", dashboardStats);
            
            // Forward to dashboard JSP
            request.getRequestDispatcher(SystemConstants.PAGE_DASHBOARD).forward(request, response);
            
        } catch (Exception e) {
            log("Error loading dashboard: " + e.getMessage(), e);
            session.setAttribute(SystemConstants.REQUEST_ERROR_MESSAGE, 
                "Error loading dashboard. Please try again.");
            response.sendRedirect(request.getContextPath() + SystemConstants.URL_LOGIN);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Handle any dashboard actions if needed
        String action = request.getParameter("action");
        
        if ("refresh".equals(action)) {
            // Refresh dashboard data
            doGet(request, response);
        } else {
            doGet(request, response);
        }
    }
    
    @Override
    public String getServletInfo() {
        return "Dashboard Controller - Main dashboard display with integrated reports";
    }
}