package com.pahanaedu.service.impl;

import com.pahanaedu.dao.interfaces.ItemDAO;
import com.pahanaedu.dao.interfaces.CategoryDAO;
import com.pahanaedu.dao.impl.ItemDAOImpl;
import com.pahanaedu.dao.impl.CategoryDAOImpl;
import com.pahanaedu.exception.BusinessException;
import com.pahanaedu.exception.ValidationException;
import com.pahanaedu.exception.DatabaseException;
import com.pahanaedu.model.Item;
import com.pahanaedu.model.Category;
import com.pahanaedu.service.interfaces.ItemService;
import com.pahanaedu.util.ValidationUtil;

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
            // Check if item code already exists
            if (itemDAO.isItemCodeExists(item.getItemCode())) {
                throw new BusinessException("Item code already exists: " + item.getItemCode());
            }
            
            // Check if ISBN already exists (if provided)
            if (item.getIsbn() != null && !item.getIsbn().trim().isEmpty()) {
                if (itemDAO.isISBNExists(item.getIsbn())) {
                    throw new BusinessException("ISBN already exists: " + item.getIsbn());
                }
            }
            
            return itemDAO.addItem(item);
        } catch (DatabaseException e) {
            throw new BusinessException("Error adding item to database: " + e.getMessage(), e);
        }
    }

    @Override
    public boolean updateItem(Item item) throws ValidationException, BusinessException {
        validateItem(item);
        
        try {
            // Check if item exists
            Item existingItem = itemDAO.getItemById(item.getItemId());
            if (existingItem == null) {
                throw new BusinessException("Item not found");
            }
            
            // Check if item code is being changed and if new code already exists
            if (!existingItem.getItemCode().equals(item.getItemCode())) {
                if (itemDAO.isItemCodeExists(item.getItemCode())) {
                    throw new BusinessException("Item code already exists: " + item.getItemCode());
                }
            }
            
            // Check if ISBN is being changed and if new ISBN already exists
            if (item.getIsbn() != null && !item.getIsbn().trim().isEmpty()) {
                if (!item.getIsbn().equals(existingItem.getIsbn()) && itemDAO.isISBNExists(item.getIsbn())) {
                    throw new BusinessException("ISBN already exists: " + item.getIsbn());
                }
            }
            
            return itemDAO.updateItem(item);
        } catch (DatabaseException e) {
            throw new BusinessException("Error updating item: " + e.getMessage(), e);
        }
    }

    @Override
    public boolean deactivateItem(int itemId) throws BusinessException {
        try {
            // Check if item exists
            Item item = itemDAO.getItemById(itemId);
            if (item == null) {
                throw new BusinessException("Item not found");
            }
            
            // Check if item has stock
            if (item.getQuantityInStock() > 0) {
                throw new BusinessException("Cannot deactivate item with existing stock. Current stock: " + item.getQuantityInStock());
            }
            
            return itemDAO.deactivateItem(itemId);
        } catch (DatabaseException e) {
            throw new BusinessException("Error deactivating item: " + e.getMessage(), e);
        }
    }

    @Override
    public Item getItemById(int itemId) throws BusinessException {
        try {
            return itemDAO.getItemById(itemId);
        } catch (DatabaseException e) {
            throw new BusinessException("Error retrieving item: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Item> getAllActiveItems() throws BusinessException {
        try {
            return itemDAO.getAllActiveItems();
        } catch (DatabaseException e) {
            throw new BusinessException("Error retrieving active items: " + e.getMessage(), e);
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
            if (searchTerm == null || searchTerm.trim().isEmpty()) {
                return getAllActiveItems();
            }
            return itemDAO.searchItems(searchTerm);
        } catch (DatabaseException e) {
            throw new BusinessException("Error searching items: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Item> getItemsByCategory(int categoryId) throws BusinessException {
        try {
            return itemDAO.getItemsByCategory(categoryId);
        } catch (DatabaseException e) {
            throw new BusinessException("Error retrieving items by category: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Item> getLowStockItems() throws BusinessException {
        try {
            return itemDAO.getLowStockItems();
        } catch (DatabaseException e) {
            throw new BusinessException("Error retrieving low stock items: " + e.getMessage(), e);
        }
    }
    
    @Override
    public List<Category> getAllCategories() throws BusinessException {
        try {
            return categoryDAO.getAllCategories();
        } catch (DatabaseException e) {
            throw new BusinessException("Error retrieving categories: " + e.getMessage(), e);
        }
    }
    
    @Override
    public boolean increaseStock(int itemId, int quantity) throws BusinessException {
        if (quantity <= 0) {
            throw new BusinessException("Quantity to increase must be positive");
        }
        
        try {
            Item item = itemDAO.getItemById(itemId);
            if (item == null) {
                throw new BusinessException("Item not found");
            }
            
            int newQuantity = item.getQuantityInStock() + quantity;
            return itemDAO.updateItemStock(itemId, newQuantity);
        } catch (DatabaseException e) {
            throw new BusinessException("Error increasing stock: " + e.getMessage(), e);
        }
    }

    @Override
    public boolean decreaseStock(int itemId, int quantity) throws BusinessException {
        if (quantity <= 0) {
            throw new BusinessException("Quantity to decrease must be positive");
        }
        
        try {
            Item item = itemDAO.getItemById(itemId);
            if (item == null) {
                throw new BusinessException("Item not found");
            }
            
            if (item.getQuantityInStock() < quantity) {
                throw new BusinessException("Insufficient stock. Available: " + item.getQuantityInStock() + ", Requested: " + quantity);
            }
            
            int newQuantity = item.getQuantityInStock() - quantity;
            return itemDAO.updateItemStock(itemId, newQuantity);
        } catch (DatabaseException e) {
            throw new BusinessException("Error decreasing stock: " + e.getMessage(), e);
        }
    }

    @Override
    public boolean adjustStock(int itemId, int newQuantity) throws BusinessException {
        if (newQuantity < 0) {
            throw new BusinessException("Stock quantity cannot be negative");
        }
        
        try {
            Item item = itemDAO.getItemById(itemId);
            if (item == null) {
                throw new BusinessException("Item not found");
            }
            
            return itemDAO.updateItemStock(itemId, newQuantity);
        } catch (DatabaseException e) {
            throw new BusinessException("Error adjusting stock: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Item> getOutOfStockItems() throws BusinessException {
        try {
            return itemDAO.getOutOfStockItems();
        } catch (DatabaseException e) {
            throw new BusinessException("Error retrieving out of stock items: " + e.getMessage(), e);
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
        } catch (DatabaseException e) {
            throw new BusinessException("Error getting item count by category: " + e.getMessage(), e);
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
        } catch (DatabaseException e) {
            throw new BusinessException("Error calculating inventory value: " + e.getMessage(), e);
        }
    }

    private void validateItem(Item item) throws ValidationException {
        Map<String, List<String>> errors = new HashMap<>();
        
        if (item.getItemCode() == null || item.getItemCode().trim().isEmpty()) {
            errors.put("itemCode", Arrays.asList("Item code is required"));
        } else if (item.getItemCode().length() > 20) {
            errors.put("itemCode", Arrays.asList("Item code must not exceed 20 characters"));
        }
        
        if (item.getItemName() == null || item.getItemName().trim().isEmpty()) {
            errors.put("itemName", Arrays.asList("Item name is required"));
        } else if (item.getItemName().length() > 100) {
            errors.put("itemName", Arrays.asList("Item name must not exceed 100 characters"));
        }
        
        if (item.getCategoryId() <= 0) {
            errors.put("categoryId", Arrays.asList("Category is required"));
        }
        
        if (item.getUnitPrice() < 0) {
            errors.put("unitPrice", Arrays.asList("Unit price cannot be negative"));
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
        
        // Validate ISBN format if provided
        if (item.getIsbn() != null && !item.getIsbn().trim().isEmpty()) {
            String isbn = item.getIsbn().replaceAll("-", "").replaceAll(" ", "");
            if (isbn.length() != 10 && isbn.length() != 13) {
                errors.put("isbn", Arrays.asList("ISBN must be 10 or 13 digits"));
            }
        }
        
        if (!errors.isEmpty()) {
            throw new ValidationException(errors);
        }
    }
}