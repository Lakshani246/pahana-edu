package com.pahanaedu.controller.item;

import com.pahanaedu.service.interfaces.ItemService;
import com.pahanaedu.service.impl.ItemServiceImpl;
import com.pahanaedu.util.SessionUtil;
import com.pahanaedu.constant.SystemConstants;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/item/list")
public class ItemListController extends HttpServlet {
    private ItemService itemService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.itemService = new ItemServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        try {
            String searchTerm = request.getParameter("search");
            String categoryId = request.getParameter("category");
            
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                request.setAttribute("items", itemService.searchItems(searchTerm));
                request.setAttribute("searchTerm", searchTerm);
            } else if (categoryId != null && !categoryId.trim().isEmpty()) {
                request.setAttribute("items", itemService.getItemsByCategory(Integer.parseInt(categoryId)));
                request.setAttribute("selectedCategory", categoryId);
            } else {
                request.setAttribute("items", itemService.getAllActiveItems());
            }
            
            request.setAttribute("categories", itemService.getAllCategories());
            request.getRequestDispatcher(SystemConstants.PAGE_ITEM_LIST).forward(request, response);
            
        } catch (Exception e) {
            SessionUtil.setErrorMessage(session, "Error loading items: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/dashboard");
        }
    }
}