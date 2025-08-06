package com.pahanaedu.service.impl;

import com.pahanaedu.dao.interfaces.ItemDAO;
import com.pahanaedu.exception.BusinessException;
import com.pahanaedu.exception.ValidationException;
import com.pahanaedu.model.Item;
import com.pahanaedu.service.interfaces.ItemService;
import com.pahanaedu.util.ValidationUtil;
import com.pahanaedu.dao.interfaces.CategoryDAO;
import com.pahanaedu.dao.impl.CategoryDAOImpl;
import com.pahanaedu.model.Category;
import com.pahanaedu.dao.impl.ItemDAOImpl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Arrays;

public class ItemServiceImpl implements ItemService {
    private final ItemDAO itemDAO;
    private final CategoryDAO categoryDAO;

    public ItemServiceImpl() {
        this.itemDAO = new ItemDAOImpl();
        this.categoryDAO = new CategoryDAOImpl();
    }

    @Override
    public int addItem(Item item, int createdBy) throws ValidationException, BusinessException {
        validateItem(item);
        item.setCreatedBy(createdBy);
        
        try {
            return itemDAO.addItem(item);
        } catch (SQLException e) {
            throw new BusinessException("Error adding item to database: " + e.getMessage());
        }
    }

    @Override
    public boolean updateItem(Item item) throws ValidationException, BusinessException {
        validateItem(item);
        
        try {
            return itemDAO.updateItem(item);
        } catch (SQLException e) {
            throw new BusinessException("Error updating item: " + e.getMessage());
        }
    }

    @Override
    public boolean deactivateItem(int itemId) throws BusinessException {
        try {
            return itemDAO.deactivateItem(itemId);
        } catch (SQLException e) {
            throw new BusinessException("Error deactivating item: " + e.getMessage());
        }
    }

    @Override
    public Item getItemById(int itemId) throws BusinessException {
        try {
            return itemDAO.getItemById(itemId);
        } catch (SQLException e) {
            throw new BusinessException("Error retrieving item: " + e.getMessage());
        }
    }

    @Override
    public List<Item> getAllActiveItems() throws BusinessException {
        try {
            return itemDAO.getAllActiveItems();
        } catch (SQLException e) {
            throw new BusinessException("Error retrieving active items: " + e.getMessage());
        }
    }
    
    @Override
    public List<Item> getActiveItems() throws BusinessException {
        // This is just an alias for getAllActiveItems()
        return getAllActiveItems();
    }

    @Override
    public List<Item> searchItems(String searchTerm) throws BusinessException {
        try {
            return itemDAO.searchItems(searchTerm);
        } catch (SQLException e) {
            throw new BusinessException("Error searching items: " + e.getMessage());
        }
    }

    @Override
    public List<Item> getItemsByCategory(int categoryId) throws BusinessException {
        try {
            return itemDAO.getItemsByCategory(categoryId);
        } catch (SQLException e) {
            throw new BusinessException("Error retrieving items by category: " + e.getMessage());
        }
    }

    @Override
    public List<Item> getLowStockItems() throws BusinessException {
        try {
            return itemDAO.getLowStockItems();
        } catch (SQLException e) {
            throw new BusinessException("Error retrieving low stock items: " + e.getMessage());
        }
    }
    
    
    @Override
    public List<Category> getAllCategories() throws BusinessException {
        try {
            return categoryDAO.getAllCategories();
        } catch (SQLException e) {
            throw new BusinessException("Error retrieving categories: " + e.getMessage());
        }
    }
    
    
    
    @Override
    public boolean increaseStock(int itemId, int quantity) throws BusinessException {
        try {
            Item item = itemDAO.getItemById(itemId);
            if (item == null) {
                throw new BusinessException("Item not found");
            }
            item.setQuantityInStock(item.getQuantityInStock() + quantity);
            return itemDAO.updateItem(item);
        } catch (SQLException e) {
            throw new BusinessException("Error increasing stock: " + e.getMessage());
        }
    }

    @Override
    public boolean decreaseStock(int itemId, int quantity) throws BusinessException {
        try {
            Item item = itemDAO.getItemById(itemId);
            if (item == null) {
                throw new BusinessException("Item not found");
            }
            if (item.getQuantityInStock() < quantity) {
                throw new BusinessException("Insufficient stock");
            }
            item.setQuantityInStock(item.getQuantityInStock() - quantity);
            return itemDAO.updateItem(item);
        } catch (SQLException e) {
            throw new BusinessException("Error decreasing stock: " + e.getMessage());
        }
    }

    @Override
    public boolean adjustStock(int itemId, int newQuantity) throws BusinessException {
        try {
            Item item = itemDAO.getItemById(itemId);
            if (item == null) {
                throw new BusinessException("Item not found");
            }
            if (newQuantity < 0) {
                throw new BusinessException("Stock quantity cannot be negative");
            }
            item.setQuantityInStock(newQuantity);
            return itemDAO.updateItem(item);
        } catch (SQLException e) {
            throw new BusinessException("Error adjusting stock: " + e.getMessage());
        }
    }

    @Override
    public List<Item> getOutOfStockItems() throws BusinessException {
        try {
            return itemDAO.getOutOfStockItems();
        } catch (SQLException e) {
            throw new BusinessException("Error retrieving out of stock items: " + e.getMessage());
        }
    }

    @Override
    public Map<String, Integer> getItemCountByCategory() throws BusinessException {
        try {
            Map<String, Integer> categoryCount = new HashMap<>();
            List<Category> categories = categoryDAO.getAllCategories();
            
            for (Category category : categories) {
                List<Item> items = itemDAO.getItemsByCategory(category.getCategoryId());
                categoryCount.put(category.getCategoryName(), items.size());
            }
            
            return categoryCount;
        } catch (SQLException e) {
            throw new BusinessException("Error getting item count by category: " + e.getMessage());
        }
    }

    @Override
    public double getTotalInventoryValue() throws BusinessException {
        try {
            List<Item> allItems = itemDAO.getAllActiveItems();
            double totalValue = 0.0;
            
            for (Item item : allItems) {
                totalValue += (item.getUnitPrice() * item.getQuantityInStock());
            }
            
            return totalValue;
        } catch (SQLException e) {
            throw new BusinessException("Error calculating inventory value: " + e.getMessage());
        }
    }

    private void validateItem(Item item) throws ValidationException {
        Map<String, List<String>> errors = new HashMap<>();
        
        if (item.getItemCode() == null || item.getItemCode().trim().isEmpty()) {
            errors.put("itemCode", Arrays.asList("Item code is required"));
        }
        
        if (item.getItemName() == null || item.getItemName().trim().isEmpty()) {
            errors.put("itemName", Arrays.asList("Item name is required"));
        }
        
        if (item.getCategoryId() <= 0) {
            errors.put("categoryId", Arrays.asList("Category is required"));
        }
        
        if (item.getUnitPrice() <= 0) {
            errors.put("unitPrice", Arrays.asList("Unit price must be positive"));
        }
        
        if (item.getSellingPrice() <= 0) {
            errors.put("sellingPrice", Arrays.asList("Selling price must be positive"));
        }
        
        if (item.getSellingPrice() < item.getUnitPrice()) {
            errors.put("sellingPrice", Arrays.asList("Selling price cannot be less than unit price"));
        }
        
        if (item.getQuantityInStock() < 0) {
            errors.put("quantityInStock", Arrays.asList("Stock quantity cannot be negative"));
        }
        
        if (item.getReorderLevel() < 0) {
            errors.put("reorderLevel", Arrays.asList("Reorder level cannot be negative"));
        }
        
        if (!errors.isEmpty()) {
            throw new ValidationException(errors);
        }
    }
}