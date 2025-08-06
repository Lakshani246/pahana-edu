package com.pahanaedu.dao.interfaces;

import com.pahanaedu.model.Item;
import java.sql.SQLException;
import java.util.List;

public interface ItemDAO {
    int addItem(Item item) throws SQLException;
    boolean updateItem(Item item) throws SQLException;
    boolean deactivateItem(int itemId) throws SQLException;
    
    Item getItemById(int itemId) throws SQLException;
    List<Item> getAllActiveItems() throws SQLException;
    List<Item> searchItems(String searchTerm) throws SQLException;
    List<Item> getItemsByCategory(int categoryId) throws SQLException;
    List<Item> getLowStockItems() throws SQLException;
    
    // Additional methods for reporting
    List<Item> getOutOfStockItems() throws SQLException;
    int getTotalItemCount() throws SQLException;
    int getActiveItemCount() throws SQLException;
}