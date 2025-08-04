package com.pahanaedu.controller;

import com.pahanaedu.service.interfaces.AuthService;
import com.pahanaedu.service.impl.AuthServiceImpl;
import com.pahanaedu.dao.interfaces.UserDAO;
// TODO: Uncomment these imports when DAOs are implemented in later phases
// import com.pahanaedu.dao.interfaces.CustomerDAO;
// import com.pahanaedu.dao.interfaces.ItemDAO;
// import com.pahanaedu.dao.interfaces.BillDAO;
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
import java.util.HashMap;
import java.util.Map;

/**
 * Servlet for handling dashboard display
 */
@WebServlet(name = "DashboardController", urlPatterns = {"/dashboard"})
public class DashboardController extends HttpServlet {
    
    private AuthService authService;
    private UserDAO userDAO;
    // TODO: Initialize these DAOs when implemented in later phases
    // private CustomerDAO customerDAO;
    // private ItemDAO itemDAO;
    // private BillDAO billDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        authService = new AuthServiceImpl();
        userDAO = new UserDAOImpl();
        // TODO: Initialize other DAOs when implemented
        // customerDAO = new CustomerDAOImpl();
        // itemDAO = new ItemDAOImpl();
        // billDAO = new BillDAOImpl();
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
            // Prepare dashboard statistics
            Map<String, Object> dashboardStats = new HashMap<>();
            
            // User statistics
            dashboardStats.put("totalUsers", userDAO.getTotalUserCount());
            dashboardStats.put("activeUsers", userDAO.getActiveUserCount());
            
            // Placeholder statistics for now (will be updated when DAOs are implemented)
            dashboardStats.put("totalCustomers", 0);
            dashboardStats.put("totalItems", 0);
            dashboardStats.put("lowStockItems", 0);
            dashboardStats.put("todaysBills", 0);
            dashboardStats.put("todaysSales", 0.0);
            dashboardStats.put("monthlyBills", 0);
            dashboardStats.put("monthlySales", 0.0);
            
            // Recent activities (placeholder)
            dashboardStats.put("recentBills", null);
            dashboardStats.put("recentCustomers", null);
            
            // Set attributes for JSP
            request.setAttribute("dashboardStats", dashboardStats);
            request.setAttribute("currentUser", loggedUser);
            
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
        // Redirect POST requests to GET
        doGet(request, response);
    }
    
    @Override
    public String getServletInfo() {
        return "Dashboard Controller - Main dashboard display";
    }
}