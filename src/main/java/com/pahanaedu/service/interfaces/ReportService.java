package com.pahanaedu.service.interfaces;

import com.pahanaedu.dto.ReportDTO;
import com.pahanaedu.dto.DashboardDTO;
import com.pahanaedu.exception.DatabaseException;
import com.pahanaedu.exception.BusinessException;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Interface for Report Service
 * Handles business logic for generating various reports
 */
public interface ReportService {
    
    /**
     * Generate daily sales report
     * @param reportDate Date for the report (null for today)
     * @return ReportDTO with daily sales data
     * @throws DatabaseException if database operation fails
     */
    ReportDTO generateDailySalesReport(Date reportDate) throws DatabaseException;
    
    /**
     * Generate sales report for date range
     * @param startDate Start date
     * @param endDate End date
     * @return ReportDTO with sales data
     * @throws DatabaseException if database operation fails
     * @throws BusinessException if date range is invalid
     */
    ReportDTO generateSalesReport(Date startDate, Date endDate) 
            throws DatabaseException, BusinessException;
    
    /**
     * Generate stock report
     * @return ReportDTO with current stock data
     * @throws DatabaseException if database operation fails
     */
    ReportDTO generateStockReport() throws DatabaseException;
    
    /**
     * Generate low stock report
     * @param threshold Stock level threshold
     * @return ReportDTO with low stock items
     * @throws DatabaseException if database operation fails
     */
    ReportDTO generateLowStockReport(int threshold) throws DatabaseException;
    
    /**
     * Generate customer report
     * @param startDate Start date (null for all time)
     * @param endDate End date (null for all time)
     * @return ReportDTO with customer data
     * @throws DatabaseException if database operation fails
     */
    ReportDTO generateCustomerReport(Date startDate, Date endDate) 
            throws DatabaseException;
    
    /**
     * Generate dashboard statistics
     * @return DashboardDTO with current statistics
     * @throws DatabaseException if database operation fails
     */
    DashboardDTO generateDashboardStatistics() throws DatabaseException;
    
    /**
     * Get sales by category for a period
     * @param startDate Start date
     * @param endDate End date
     * @return List of category sales data
     * @throws DatabaseException if database operation fails
     */
    List<Map<String, Object>> getSalesByCategory(Date startDate, Date endDate) 
            throws DatabaseException;
    
    /**
     * Get top selling items for a period
     * @param startDate Start date
     * @param endDate End date
     * @param limit Number of items to return
     * @return List of top selling items
     * @throws DatabaseException if database operation fails
     */
    List<Map<String, Object>> getTopSellingItems(Date startDate, Date endDate, int limit) 
            throws DatabaseException;
    
    /**
     * Get sales trend for last N days
     * @param days Number of days
     * @return Map with date labels and sales data
     * @throws DatabaseException if database operation fails
     */
    Map<String, List<?>> getSalesTrend(int days) throws DatabaseException;
    
    /**
     * Get monthly sales summary
     * @param year Year
     * @param month Month (1-12)
     * @return ReportDTO with monthly summary
     * @throws DatabaseException if database operation fails
     */
    ReportDTO getMonthlySummary(int year, int month) throws DatabaseException;
    
    /**
     * Export report to CSV
     * @param report ReportDTO to export
     * @return CSV string
     */
    String exportReportToCSV(ReportDTO report);
    
    /**
     * Get report types available
     * @return List of report types
     */
    List<String> getAvailableReportTypes();
    
    /**
     * Validate date range for reports
     * @param startDate Start date
     * @param endDate End date
     * @throws BusinessException if validation fails
     */
    void validateDateRange(Date startDate, Date endDate) throws BusinessException;
}