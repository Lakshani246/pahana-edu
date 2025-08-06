package com.pahanaedu.dto;

import java.io.Serializable;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * DTO for dashboard statistics and summary data
 */
public class DashboardDTO implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    // User statistics
    private int totalUsers;
    private int activeUsers;
    private int onlineUsers;
    
    // Customer statistics
    private int totalCustomers;
    private int activeCustomers;
    private int newCustomersToday;
    private int newCustomersThisMonth;
    
    // Item/Inventory statistics
    private int totalItems;
    private int activeItems;
    private int lowStockItems;
    private int outOfStockItems;
    
    // Sales statistics
    private int todaysBills;
    private double todaysSales;
    private int weeklyBills;
    private double weeklySales;
    private int monthlyBills;
    private double monthlySales;
    private double averageBillValue;
    
    // Recent activities
    private List<Map<String, Object>> recentBills;
    private List<Map<String, Object>> recentCustomers;
    private List<Map<String, Object>> lowStockAlerts;
    
    // Chart data for dashboard graphs
    private List<String> salesChartLabels;
    private List<Double> salesChartData;
    private List<String> categoryChartLabels;
    private List<Double> categoryChartData;
    
    // Performance metrics
    private double salesGrowthPercentage;
    private double customerGrowthPercentage;
    private Date lastUpdated;
    
    // Constructor
    public DashboardDTO() {
        this.lastUpdated = new Date();
    }
    
    // Getters and Setters
    public int getTotalUsers() {
        return totalUsers;
    }
    
    public void setTotalUsers(int totalUsers) {
        this.totalUsers = totalUsers;
    }
    
    public int getActiveUsers() {
        return activeUsers;
    }
    
    public void setActiveUsers(int activeUsers) {
        this.activeUsers = activeUsers;
    }
    
    public int getOnlineUsers() {
        return onlineUsers;
    }
    
    public void setOnlineUsers(int onlineUsers) {
        this.onlineUsers = onlineUsers;
    }
    
    public int getTotalCustomers() {
        return totalCustomers;
    }
    
    public void setTotalCustomers(int totalCustomers) {
        this.totalCustomers = totalCustomers;
    }
    
    public int getActiveCustomers() {
        return activeCustomers;
    }
    
    public void setActiveCustomers(int activeCustomers) {
        this.activeCustomers = activeCustomers;
    }
    
    public int getNewCustomersToday() {
        return newCustomersToday;
    }
    
    public void setNewCustomersToday(int newCustomersToday) {
        this.newCustomersToday = newCustomersToday;
    }
    
    public int getNewCustomersThisMonth() {
        return newCustomersThisMonth;
    }
    
    public void setNewCustomersThisMonth(int newCustomersThisMonth) {
        this.newCustomersThisMonth = newCustomersThisMonth;
    }
    
    public int getTotalItems() {
        return totalItems;
    }
    
    public void setTotalItems(int totalItems) {
        this.totalItems = totalItems;
    }
    
    public int getActiveItems() {
        return activeItems;
    }
    
    public void setActiveItems(int activeItems) {
        this.activeItems = activeItems;
    }
    
    public int getLowStockItems() {
        return lowStockItems;
    }
    
    public void setLowStockItems(int lowStockItems) {
        this.lowStockItems = lowStockItems;
    }
    
    public int getOutOfStockItems() {
        return outOfStockItems;
    }
    
    public void setOutOfStockItems(int outOfStockItems) {
        this.outOfStockItems = outOfStockItems;
    }
    
    public int getTodaysBills() {
        return todaysBills;
    }
    
    public void setTodaysBills(int todaysBills) {
        this.todaysBills = todaysBills;
    }
    
    public double getTodaysSales() {
        return todaysSales;
    }
    
    public void setTodaysSales(double todaysSales) {
        this.todaysSales = todaysSales;
    }
    
    public int getWeeklyBills() {
        return weeklyBills;
    }
    
    public void setWeeklyBills(int weeklyBills) {
        this.weeklyBills = weeklyBills;
    }
    
    public double getWeeklySales() {
        return weeklySales;
    }
    
    public void setWeeklySales(double weeklySales) {
        this.weeklySales = weeklySales;
    }
    
    public int getMonthlyBills() {
        return monthlyBills;
    }
    
    public void setMonthlyBills(int monthlyBills) {
        this.monthlyBills = monthlyBills;
    }
    
    public double getMonthlySales() {
        return monthlySales;
    }
    
    public void setMonthlySales(double monthlySales) {
        this.monthlySales = monthlySales;
    }
    
    public double getAverageBillValue() {
        return averageBillValue;
    }
    
    public void setAverageBillValue(double averageBillValue) {
        this.averageBillValue = averageBillValue;
    }
    
    public List<Map<String, Object>> getRecentBills() {
        return recentBills;
    }
    
    public void setRecentBills(List<Map<String, Object>> recentBills) {
        this.recentBills = recentBills;
    }
    
    public List<Map<String, Object>> getRecentCustomers() {
        return recentCustomers;
    }
    
    public void setRecentCustomers(List<Map<String, Object>> recentCustomers) {
        this.recentCustomers = recentCustomers;
    }
    
    public List<Map<String, Object>> getLowStockAlerts() {
        return lowStockAlerts;
    }
    
    public void setLowStockAlerts(List<Map<String, Object>> lowStockAlerts) {
        this.lowStockAlerts = lowStockAlerts;
    }
    
    public List<String> getSalesChartLabels() {
        return salesChartLabels;
    }
    
    public void setSalesChartLabels(List<String> salesChartLabels) {
        this.salesChartLabels = salesChartLabels;
    }
    
    public List<Double> getSalesChartData() {
        return salesChartData;
    }
    
    public void setSalesChartData(List<Double> salesChartData) {
        this.salesChartData = salesChartData;
    }
    
    public List<String> getCategoryChartLabels() {
        return categoryChartLabels;
    }
    
    public void setCategoryChartLabels(List<String> categoryChartLabels) {
        this.categoryChartLabels = categoryChartLabels;
    }
    
    public List<Double> getCategoryChartData() {
        return categoryChartData;
    }
    
    public void setCategoryChartData(List<Double> categoryChartData) {
        this.categoryChartData = categoryChartData;
    }
    
    public double getSalesGrowthPercentage() {
        return salesGrowthPercentage;
    }
    
    public void setSalesGrowthPercentage(double salesGrowthPercentage) {
        this.salesGrowthPercentage = salesGrowthPercentage;
    }
    
    public double getCustomerGrowthPercentage() {
        return customerGrowthPercentage;
    }
    
    public void setCustomerGrowthPercentage(double customerGrowthPercentage) {
        this.customerGrowthPercentage = customerGrowthPercentage;
    }
    
    public Date getLastUpdated() {
        return lastUpdated;
    }
    
    public void setLastUpdated(Date lastUpdated) {
        this.lastUpdated = lastUpdated;
    }
    
    // Utility methods
    public boolean hasLowStockAlerts() {
        return lowStockItems > 0 || outOfStockItems > 0;
    }
    
    public String getStockStatus() {
        if (outOfStockItems > 0) {
            return "Critical";
        } else if (lowStockItems > 0) {
            return "Warning";
        }
        return "Good";
    }
    
    public String getStockStatusClass() {
        if (outOfStockItems > 0) {
            return "danger";
        } else if (lowStockItems > 0) {
            return "warning";
        }
        return "success";
    }
    
    public double calculateDailyAverage() {
        if (todaysBills > 0) {
            return todaysSales / todaysBills;
        }
        return 0.0;
    }
}