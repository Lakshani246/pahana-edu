package com.pahanaedu.service.interfaces;

import com.pahanaedu.model.Category;
import com.pahanaedu.exception.ValidationException;
import com.pahanaedu.exception.DatabaseException;
import com.pahanaedu.exception.BusinessException;
import java.util.List;

public interface CategoryService {
    void addCategory(Category category, int userId) throws ValidationException, DatabaseException, BusinessException;
    void updateCategory(Category category, int userId) throws ValidationException, DatabaseException, BusinessException;
    void deleteCategory(int categoryId, int userId) throws DatabaseException, BusinessException;
    Category getCategoryById(int categoryId) throws DatabaseException;
    Category getCategoryByName(String categoryName) throws DatabaseException;
    List<Category> getAllCategories() throws DatabaseException;
}