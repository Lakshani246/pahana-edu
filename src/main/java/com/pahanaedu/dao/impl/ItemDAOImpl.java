package com.pahanaedu.dao.impl;

import com.pahanaedu.dao.interfaces.ItemDAO;
import com.pahanaedu.model.Item;
import com.pahanaedu.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ItemDAOImpl implements ItemDAO {
    
    private Connection getConnection() throws SQLException {
        return DBConnection.getConnection();
    }
    
    @Override
    public int addItem(Item item) throws SQLException {
        String sql = "INSERT INTO items (item_code, item_name, description, category_id, " +
                     "author, publisher, isbn, unit_price, selling_price, quantity_in_stock, " +
                     "reorder_level, is_active, created_by) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, item.getItemCode());
            stmt.setString(2, item.getItemName());
            stmt.setString(3, item.getDescription());
            stmt.setInt(4, item.getCategoryId());
            stmt.setString(5, item.getAuthor());
            stmt.setString(6, item.getPublisher());
            stmt.setString(7, item.getIsbn());
            stmt.setDouble(8, item.getUnitPrice());
            stmt.setDouble(9, item.getSellingPrice());
            stmt.setInt(10, item.getQuantityInStock());
            stmt.setInt(11, item.getReorderLevel());
            stmt.setBoolean(12, item.isActive());
            stmt.setInt(13, item.getCreatedBy());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating item failed, no rows affected.");
            }
            
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                } else {
                    throw new SQLException("Creating item failed, no ID obtained.");
                }
            }
        }
    }

    @Override
    public boolean updateItem(Item item) throws SQLException {
        String sql = "UPDATE items SET item_name=?, description=?, category_id=?, " +
                     "author=?, publisher=?, isbn=?, unit_price=?, selling_price=?, " +
                     "quantity_in_stock=?, reorder_level=?, updated_at=CURRENT_TIMESTAMP " +
                     "WHERE item_id=?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, item.getItemName());
            stmt.setString(2, item.getDescription());
            stmt.setInt(3, item.getCategoryId());
            stmt.setString(4, item.getAuthor());
            stmt.setString(5, item.getPublisher());
            stmt.setString(6, item.getIsbn());
            stmt.setDouble(7, item.getUnitPrice());
            stmt.setDouble(8, item.getSellingPrice());
            stmt.setInt(9, item.getQuantityInStock());
            stmt.setInt(10, item.getReorderLevel());
            stmt.setInt(11, item.getItemId());
            
            return stmt.executeUpdate() > 0;
        }
    }

    @Override
    public boolean deactivateItem(int itemId) throws SQLException {
        String sql = "UPDATE items SET is_active=false WHERE item_id=?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, itemId);
            return stmt.executeUpdate() > 0;
        }
    }

    @Override
    public Item getItemById(int itemId) throws SQLException {
        String sql = "SELECT i.*, c.category_name, u.username as created_by_username " +
                     "FROM items i " +
                     "LEFT JOIN categories c ON i.category_id = c.category_id " +
                     "LEFT JOIN users u ON i.created_by = u.user_id " +
                     "WHERE i.item_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, itemId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRowToItem(rs);
                }
                return null;
            }
        }
    }

    @Override
    public List<Item> getAllActiveItems() throws SQLException {
        String sql = "SELECT i.*, c.category_name FROM items i " +
                     "LEFT JOIN categories c ON i.category_id = c.category_id " +
                     "WHERE i.is_active = true ORDER BY i.item_name";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            List<Item> items = new ArrayList<>();
            while (rs.next()) {
                items.add(mapRowToItem(rs));
            }
            return items;
        }
    }

    @Override
    public List<Item> searchItems(String searchTerm) throws SQLException {
        String sql = "SELECT i.*, c.category_name FROM items i " +
                     "LEFT JOIN categories c ON i.category_id = c.category_id " +
                     "WHERE i.is_active = true AND " +
                     "(i.item_code LIKE ? OR i.item_name LIKE ? OR i.isbn LIKE ?) " +
                     "ORDER BY i.item_name";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String likeTerm = "%" + searchTerm + "%";
            stmt.setString(1, likeTerm);
            stmt.setString(2, likeTerm);
            stmt.setString(3, likeTerm);
            
            try (ResultSet rs = stmt.executeQuery()) {
                List<Item> items = new ArrayList<>();
                while (rs.next()) {
                    items.add(mapRowToItem(rs));
                }
                return items;
            }
        }
    }

    @Override
    public List<Item> getItemsByCategory(int categoryId) throws SQLException {
        String sql = "SELECT i.*, c.category_name FROM items i " +
                     "LEFT JOIN categories c ON i.category_id = c.category_id " +
                     "WHERE i.is_active = true AND i.category_id = ? " +
                     "ORDER BY i.item_name";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, categoryId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                List<Item> items = new ArrayList<>();
                while (rs.next()) {
                    items.add(mapRowToItem(rs));
                }
                return items;
            }
        }
    }

    @Override
    public List<Item> getLowStockItems() throws SQLException {
        String sql = "SELECT i.*, c.category_name FROM items i " +
                     "LEFT JOIN categories c ON i.category_id = c.category_id " +
                     "WHERE i.is_active = true AND i.quantity_in_stock <= i.reorder_level " +
                     "ORDER BY i.quantity_in_stock ASC";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            List<Item> items = new ArrayList<>();
            while (rs.next()) {
                items.add(mapRowToItem(rs));
            }
            return items;
        }
    }
    
    
    @Override
    public List<Item> getOutOfStockItems() throws SQLException {
        String sql = "SELECT i.*, c.category_name FROM items i " +
                     "LEFT JOIN categories c ON i.category_id = c.category_id " +
                     "WHERE i.is_active = true AND i.quantity_in_stock = 0 " +
                     "ORDER BY i.item_name";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            List<Item> items = new ArrayList<>();
            while (rs.next()) {
                items.add(mapRowToItem(rs));
            }
            return items;
        }
    }

    @Override
    public int getTotalItemCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM items";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        }
    }

    @Override
    public int getActiveItemCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM items WHERE is_active = true";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        }
    }

    private Item mapRowToItem(ResultSet rs) throws SQLException {
        Item item = new Item();
        item.setItemId(rs.getInt("item_id"));
        item.setItemCode(rs.getString("item_code"));
        item.setItemName(rs.getString("item_name"));
        item.setDescription(rs.getString("description"));
        item.setCategoryId(rs.getInt("category_id"));
        item.setAuthor(rs.getString("author"));
        item.setPublisher(rs.getString("publisher"));
        item.setIsbn(rs.getString("isbn"));
        item.setUnitPrice(rs.getDouble("unit_price"));
        item.setSellingPrice(rs.getDouble("selling_price"));
        item.setQuantityInStock(rs.getInt("quantity_in_stock"));
        item.setReorderLevel(rs.getInt("reorder_level"));
        item.setActive(rs.getBoolean("is_active"));
        
        // Transient fields
        if (hasColumn(rs, "category_name")) {
            item.setCategoryName(rs.getString("category_name"));
        }
        if (hasColumn(rs, "created_by_username")) {
            item.setCreatedByUsername(rs.getString("created_by_username"));
        }
        
        return item;
    }

    private boolean hasColumn(ResultSet rs, String columnName) throws SQLException {
        ResultSetMetaData metaData = rs.getMetaData();
        int columns = metaData.getColumnCount();
        for (int i = 1; i <= columns; i++) {
            if (columnName.equalsIgnoreCase(metaData.getColumnName(i))) {
                return true;
            }
        }
        return false;
    }
}