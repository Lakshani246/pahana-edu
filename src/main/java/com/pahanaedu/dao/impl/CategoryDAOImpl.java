package com.pahanaedu.dao.impl;

import com.pahanaedu.dao.interfaces.CategoryDAO;
import com.pahanaedu.model.Category;
import com.pahanaedu.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAOImpl implements CategoryDAO {
    @Override
    public List<Category> getAllCategories() throws SQLException {
        String sql = "SELECT * FROM categories WHERE is_active = true ORDER BY category_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            List<Category> categories = new ArrayList<>();
            while (rs.next()) {
                Category category = new Category();
                category.setCategoryId(rs.getInt("category_id"));
                category.setCategoryName(rs.getString("category_name"));
                category.setDescription(rs.getString("description"));
                category.setActive(rs.getBoolean("is_active"));
                categories.add(category);
            }
            return categories;
        }
    }
    
    @Override
    public Category getCategoryById(int categoryId) throws SQLException {
        // Implementation if needed
        return null;
    }
}