package com.pahanaedu.controller.item;

import com.pahanaedu.service.interfaces.ItemService;
import com.pahanaedu.service.impl.ItemServiceImpl;
import com.pahanaedu.util.SessionUtil;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/item/stock")
public class ItemStockController extends HttpServlet {
    private ItemService itemService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.itemService = new ItemServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String statusFilter = request.getParameter("status");
            
            if (statusFilter != null && !statusFilter.isEmpty()) {
                switch (statusFilter) {
                    case "low":
                        request.setAttribute("items", itemService.getLowStockItems());
                        break;
                    case "out":
                        request.setAttribute("items", itemService.getOutOfStockItems());
                        break;
//                    case "normal":
//                        request.setAttribute("items", itemService.getNormalStockItems());
//                        break;
                    default:
                        request.setAttribute("items", itemService.getAllActiveItems());
                }
            } else {
                request.setAttribute("items", itemService.getAllActiveItems());
            }
            
            request.getRequestDispatcher("/views/item/stock-status.jsp").forward(request, response);
            
        } catch (Exception e) {
            SessionUtil.setErrorMessage(request.getSession(), "Error loading stock status: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/item");
        }
    }
}