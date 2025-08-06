package com.pahanaedu.controller.customer;

import com.pahanaedu.service.interfaces.CustomerService;
import com.pahanaedu.service.impl.CustomerServiceImpl;
import com.pahanaedu.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/customer/delete")
public class DeleteCustomerController extends HttpServlet {
    private CustomerService customerService = new CustomerServiceImpl();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String customerIdStr = request.getParameter("id");
        
        try {
            int customerId = Integer.parseInt(customerIdStr);
            boolean deleted = customerService.deleteCustomer(customerId);
            
            if (deleted) {
                SessionUtil.setSuccessMessage(session, "Customer deactivated successfully");
            } else {
                SessionUtil.setErrorMessage(session, "Failed to deactivate customer");
            }
        } catch (Exception e) {
            SessionUtil.setErrorMessage(session, "Error: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/customer/list");
    }
}