package com.pahanaedu.controller.item;

import com.pahanaedu.service.interfaces.ItemService;
import com.pahanaedu.service.impl.ItemServiceImpl;
import com.pahanaedu.util.SessionUtil;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/item/delete")
public class DeleteItemController extends HttpServlet {
    private ItemService itemService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.itemService = new ItemServiceImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String itemIdStr = request.getParameter("id");
        
        try {
            int itemId = Integer.parseInt(itemIdStr);
            boolean deleted = itemService.deactivateItem(itemId);
            
            if (deleted) {
                SessionUtil.setSuccessMessage(session, "Item deactivated successfully");
            } else {
                SessionUtil.setErrorMessage(session, "Failed to deactivate item");
            }
        } catch (Exception e) {
            SessionUtil.setErrorMessage(session, "Error: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/items");
    }
}