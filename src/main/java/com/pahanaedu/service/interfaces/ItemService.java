package com.pahanaedu.service.interfaces;

import com.pahanaedu.model.Item;
import com.pahanaedu.exception.BusinessException;
import com.pahanaedu.exception.ValidationException;
import java.util.List;

public interface ItemService {
    int addItem(Item item, int createdBy) throws ValidationException, BusinessException;
    boolean updateItem(Item item) throws ValidationException, BusinessException;
    boolean deactivateItem(int itemId) throws BusinessException;
    
    Item getItemById(int itemId) throws BusinessException;
    List<Item> getAllActiveItems() throws BusinessException;
    List<Item> searchItems(String searchTerm) throws BusinessException;
    List<Item> getItemsByCategory(int categoryId) throws BusinessException;
    List<Item> getLowStockItems() throws BusinessException;
    
    // Business logic methods
    boolean increaseStock(int itemId, int quantity) throws BusinessException;
    boolean decreaseStock(int itemId, int quantity) throws BusinessException;
    boolean adjustStock(int itemId, int newQuantity) throws BusinessException;
    
    // Reporting methods
    List<Item> getOutOfStockItems() throws BusinessException;
    Map<String, Integer> getItemCountByCategory() throws BusinessException;
    double getTotalInventoryValue() throws BusinessException;
}