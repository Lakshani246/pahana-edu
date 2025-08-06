package com.pahanaedu.service.impl;

import com.pahanaedu.service.interfaces.ReportService;
import com.pahanaedu.dao.interfaces.*;
import com.pahanaedu.dao.impl.*;
import com.pahanaedu.dto.ReportDTO;
import com.pahanaedu.dto.DashboardDTO;
import com.pahanaedu.exception.DatabaseException;
import com.pahanaedu.exception.BusinessException;
import com.pahanaedu.util.DateUtil;
import com.pahanaedu.model.Bill;
import com.pahanaedu.model.Item;
import com.pahanaedu.model.Category;

import java.util.*;
import java.text.SimpleDateFormat;

/**
 * Implementation of ReportService interface
 * Handles business logic for generating various reports
 */
public class ReportServiceImpl implements ReportService {
    
    private CustomerDAO customerDAO;
    private UserDAO userDAO;
    private ItemDAO itemDAO;
    private BillDAO billDAO;
    private CategoryDAO categoryDAO;
    private BillItemDAO billItemDAO;
    
    public ReportServiceImpl() {
        this.customerDAO = new CustomerDAOImpl();
        this.userDAO = new UserDAOImpl();
        this.itemDAO = new ItemDAOImpl();
        this.billDAO = new BillDAOImpl();
        this.categoryDAO = new CategoryDAOImpl();
        this.billItemDAO = new BillItemDAOImpl();
    }
    
    @Override
    public ReportDTO generateDailySalesReport(Date reportDate) throws DatabaseException {
        if (reportDate == null) {
            reportDate = new Date();
        }
        
        ReportDTO report = new ReportDTO("Daily Sales Report", "DAILY_SALES");
        report.setStartDate(DateUtil.getStartOfDay(reportDate));
        report.setEndDate(DateUtil.getEndOfDay(reportDate));
        
        // Get daily sales summary from BillDAO
        Map<String, Object> dailySummary = billDAO.getDailySalesSummary(reportDate);
        
        report.setTotalSales((Double) dailySummary.get("totalSales"));
        report.setTotalBills((Integer) dailySummary.get("billCount"));
        report.setAverageBillValue((Double) dailySummary.get("averageBill"));
        
        // Get unique customers for the day
        List<Bill> dayBills = billDAO.getBillsByDateRange(
            DateUtil.getStartOfDay(reportDate), 
            DateUtil.getEndOfDay(reportDate)
        );
        Set<Integer> uniqueCustomers = new HashSet<>();
        for (Bill bill : dayBills) {
            uniqueCustomers.add(bill.getCustomerId());
        }
        report.setTotalCustomers(uniqueCustomers.size());
        
        // Generate hourly breakdown
        List<Map<String, Object>> hourlyBreakdown = new ArrayList<>();
        for (int hour = 9; hour <= 18; hour++) {
            Map<String, Object> hourData = new HashMap<>();
            hourData.put("hour", hour + ":00");
            
            // Calculate sales for this hour
            double hourSales = 0.0;
            int hourBills = 0;
            
            for (Bill bill : dayBills) {
                Calendar cal = Calendar.getInstance();
                cal.setTime(bill.getBillTime());
                if (cal.get(Calendar.HOUR_OF_DAY) == hour) {
                    hourSales += bill.getTotalAmount();
                    hourBills++;
                }
            }
            
            hourData.put("sales", hourSales);
            hourData.put("bills", hourBills);
            hourlyBreakdown.add(hourData);
        }
        report.setHourlyBreakdown(hourlyBreakdown);
        
        return report;
    }
    
    @Override
    public ReportDTO generateSalesReport(Date startDate, Date endDate) 
            throws DatabaseException, BusinessException {
        
        validateDateRange(startDate, endDate);
        
        ReportDTO report = new ReportDTO("Sales Report", "SALES");
        report.setStartDate(startDate);
        report.setEndDate(endDate);
        
        // Get sales total for date range
        double totalSales = billDAO.getSalesTotalByDateRange(startDate, endDate);
        report.setTotalSales(totalSales);
        
        // Get bills for date range
        List<Bill> bills = billDAO.getBillsByDateRange(startDate, endDate);
        report.setTotalBills(bills.size());
        
        // Calculate unique customers
        Set<Integer> uniqueCustomers = new HashSet<>();
        for (Bill bill : bills) {
            uniqueCustomers.add(bill.getCustomerId());
        }
        report.setTotalCustomers(uniqueCustomers.size());
        
        // Calculate average bill value
        report.setAverageBillValue(bills.size() > 0 ? totalSales / bills.size() : 0.0);
        
        return report;
    }
    
    @Override
    public ReportDTO generateStockReport() throws DatabaseException {
        ReportDTO report = new ReportDTO("Stock Report", "STOCK");
        report.setGeneratedDate(new Date());
        
        // Get item statistics
        report.setTotalItems(itemDAO.getTotalItemCount());
        report.setLowStockItems(itemDAO.getLowStockItems().size());
        report.setOutOfStockItems(itemDAO.getOutOfStockItems().size());
        
        // Calculate total stock value
        List<Item> allItems = itemDAO.getAllActiveItems();
        double totalStockValue = 0.0;
        for (Item item : allItems) {
            totalStockValue += (item.getSellingPrice() * item.getQuantityInStock());
        }
        report.setTotalStockValue(totalStockValue);
        
        // Stock by category
        List<Map<String, Object>> stockByCategory = new ArrayList<>();
        List<Category> categories = categoryDAO.getActiveCategories();
        
        for (Category category : categories) {
            Map<String, Object> catData = new HashMap<>();
            catData.put("category", category.getCategoryName());
            
            // Get items for this category
            List<Item> categoryItems = itemDAO.getItemsByCategory(category.getCategoryId());
            int itemCount = categoryItems.size();
            double categoryStockValue = 0.0;
            
            for (Item item : categoryItems) {
                categoryStockValue += (item.getSellingPrice() * item.getQuantityInStock());
            }
            
            catData.put("itemCount", itemCount);
            catData.put("stockValue", categoryStockValue);
            stockByCategory.add(catData);
        }
        report.setStockByCategory(stockByCategory);
        
        return report;
    }
    
    @Override
    public ReportDTO generateLowStockReport(int threshold) throws DatabaseException {
        if (threshold <= 0) {
            threshold = 10; // Default threshold
        }
        
        ReportDTO report = new ReportDTO("Low Stock Report", "LOW_STOCK");
        report.setGeneratedDate(new Date());
        
        // Get low stock items
        List<Item> lowStockItems = itemDAO.getLowStockItems();
        List<Map<String, Object>> lowStockList = new ArrayList<>();
        
        for (Item item : lowStockItems) {
            if (item.getQuantityInStock() <= threshold) {
                Map<String, Object> itemData = new HashMap<>();
                itemData.put("itemCode", item.getItemCode());
                itemData.put("itemName", item.getItemName());
                itemData.put("currentStock", item.getQuantityInStock());
                itemData.put("reorderLevel", item.getReorderLevel());
                lowStockList.add(itemData);
            }
        }
        
        report.setLowStockList(lowStockList);
        report.setLowStockItems(lowStockList.size());
        
        return report;
    }
    
    @Override
    public ReportDTO generateCustomerReport(Date startDate, Date endDate) 
            throws DatabaseException {
        
        ReportDTO report = new ReportDTO("Customer Report", "CUSTOMER");
        report.setStartDate(startDate);
        report.setEndDate(endDate);
        
        // Get actual customer data
        int totalCustomers = customerDAO.getTotalCustomerCount();
        int activeCustomers = customerDAO.getActiveCustomerCount();
        
        report.setTotalCustomers(totalCustomers);
        report.setActiveCustomers(activeCustomers);
        report.setInactiveCustomers(totalCustomers - activeCustomers);
        
        // Get customers by city
        List<Map<String, Object>> customersByCity = new ArrayList<>();
        List<String> cities = Arrays.asList("Colombo", "Kandy", "Galle", "Negombo", "Matara", "Jaffna");
        
        for (String city : cities) {
            Map<String, Object> cityData = new HashMap<>();
            List<com.pahanaedu.model.Customer> cityCustomers = customerDAO.getCustomersByCity(city);
            cityData.put("city", city);
            cityData.put("customerCount", cityCustomers.size());
            cityData.put("percentage", totalCustomers > 0 ? 
                (cityCustomers.size() * 100.0 / totalCustomers) : 0);
            customersByCity.add(cityData);
        }
        report.setCustomersByCity(customersByCity);
        
        // Get top customers based on purchase history
        List<com.pahanaedu.model.Customer> allCustomers = customerDAO.getActiveCustomers();
        List<Map<String, Object>> topCustomers = new ArrayList<>();
        
        // Sort customers by total purchases
        Map<Integer, Double> customerPurchases = new HashMap<>();
        Map<Integer, Integer> customerBillCounts = new HashMap<>();
        
        for (com.pahanaedu.model.Customer customer : allCustomers) {
            Map<String, Object> purchaseSummary = billDAO.getCustomerPurchaseSummary(customer.getCustomerId());
            double totalSpent = (Double) purchaseSummary.get("totalSpent");
            int billCount = (Integer) purchaseSummary.get("totalBills");
            
            if (totalSpent > 0) {
                customerPurchases.put(customer.getCustomerId(), totalSpent);
                customerBillCounts.put(customer.getCustomerId(), billCount);
            }
        }
        
        // Sort by total purchases and get top 5
        List<Map.Entry<Integer, Double>> sortedCustomers = new ArrayList<>(customerPurchases.entrySet());
        sortedCustomers.sort((e1, e2) -> e2.getValue().compareTo(e1.getValue()));
        
        int count = 0;
        for (Map.Entry<Integer, Double> entry : sortedCustomers) {
            if (count >= 5) break;
            
            com.pahanaedu.model.Customer customer = customerDAO.getCustomerById(entry.getKey());
            Map<String, Object> custData = new HashMap<>();
            custData.put("customerId", customer.getCustomerId());
            custData.put("customerName", customer.getCustomerName());
            custData.put("accountNumber", customer.getAccountNumber());
            custData.put("totalPurchases", entry.getValue());
            custData.put("billCount", customerBillCounts.get(entry.getKey()));
            topCustomers.add(custData);
            count++;
        }
        
        report.setTopCustomers(topCustomers);
        
        return report;
    }
    
    @Override
    public DashboardDTO generateDashboardStatistics() throws DatabaseException {
        DashboardDTO dashboard = new DashboardDTO();
        
        // User statistics
        dashboard.setTotalUsers(userDAO.getTotalUserCount());
        dashboard.setActiveUsers(userDAO.getActiveUserCount());
        
        // Customer statistics
        dashboard.setTotalCustomers(customerDAO.getTotalCustomerCount());
        dashboard.setActiveCustomers(customerDAO.getActiveCustomerCount());
        
        // Calculate new customers today
        List<com.pahanaedu.model.Customer> allCustomers = customerDAO.getAllCustomers();
        int newCustomersToday = 0;
        int newCustomersThisMonth = 0;
        
        Calendar today = Calendar.getInstance();
        today.set(Calendar.HOUR_OF_DAY, 0);
        today.set(Calendar.MINUTE, 0);
        today.set(Calendar.SECOND, 0);
        
        Calendar monthStart = Calendar.getInstance();
        monthStart.set(Calendar.DAY_OF_MONTH, 1);
        monthStart.set(Calendar.HOUR_OF_DAY, 0);
        monthStart.set(Calendar.MINUTE, 0);
        monthStart.set(Calendar.SECOND, 0);
        
        for (com.pahanaedu.model.Customer customer : allCustomers) {
            if (customer.getCreatedAt().after(today.getTime())) {
                newCustomersToday++;
            }
            if (customer.getCreatedAt().after(monthStart.getTime())) {
                newCustomersThisMonth++;
            }
        }
        
        dashboard.setNewCustomersToday(newCustomersToday);
        dashboard.setNewCustomersThisMonth(newCustomersThisMonth);
        
        // Item statistics
        dashboard.setTotalItems(itemDAO.getTotalItemCount());
        dashboard.setActiveItems(itemDAO.getActiveItemCount());
        dashboard.setLowStockItems(itemDAO.getLowStockItems().size());
        dashboard.setOutOfStockItems(itemDAO.getOutOfStockItems().size());
        
        // Sales statistics
        List<Bill> todaysBills = billDAO.getTodaysBills();
        dashboard.setTodaysBills(todaysBills.size());
        dashboard.setTodaysSales(billDAO.getTodaysSalesTotal());
        
        // Calculate weekly and monthly sales
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DAY_OF_MONTH, -7);
        Date weekAgo = cal.getTime();
        
        cal = Calendar.getInstance();
        cal.set(Calendar.DAY_OF_MONTH, 1);
        Date monthStart2 = cal.getTime();
        
        List<Bill> weeklyBills = billDAO.getBillsByDateRange(weekAgo, new Date());
        List<Bill> monthlyBills = billDAO.getBillsByDateRange(monthStart2, new Date());
        
        double weeklySales = 0.0;
        for (Bill bill : weeklyBills) {
            if ("PAID".equals(bill.getPaymentStatus())) {
                weeklySales += bill.getTotalAmount();
            }
        }
        
        double monthlySales = 0.0;
        for (Bill bill : monthlyBills) {
            if ("PAID".equals(bill.getPaymentStatus())) {
                monthlySales += bill.getTotalAmount();
            }
        }
        
        dashboard.setWeeklyBills(weeklyBills.size());
        dashboard.setWeeklySales(weeklySales);
        dashboard.setMonthlyBills(monthlyBills.size());
        dashboard.setMonthlySales(monthlySales);
        
        // Calculate average bill value
        dashboard.setAverageBillValue(todaysBills.size() > 0 ? 
            dashboard.getTodaysSales() / todaysBills.size() : 0.0);
        
        // Recent bills
        List<Bill> recentBills = billDAO.getRecentBills(5);
        List<Map<String, Object>> recentBillsList = new ArrayList<>();
        
        for (Bill bill : recentBills) {
            Map<String, Object> billMap = new HashMap<>();
            billMap.put("billId", bill.getBillId());
            billMap.put("billNumber", bill.getBillNumber());
            billMap.put("customerName", bill.getCustomerName());
            billMap.put("totalAmount", bill.getTotalAmount());
            billMap.put("billDate", bill.getBillDate());
            billMap.put("paymentStatus", bill.getPaymentStatus());
            recentBillsList.add(billMap);
        }
        dashboard.setRecentBills(recentBillsList);
        
        // Recent customers
        List<com.pahanaedu.model.Customer> recentCustomers = customerDAO.getRecentCustomers(5);
        List<Map<String, Object>> recentCustomersList = new ArrayList<>();
        
        for (com.pahanaedu.model.Customer customer : recentCustomers) {
            Map<String, Object> custMap = new HashMap<>();
            custMap.put("customerId", customer.getCustomerId());
            custMap.put("customerName", customer.getCustomerName());
            custMap.put("accountNumber", customer.getAccountNumber());
            custMap.put("registrationDate", customer.getRegistrationDate());
            recentCustomersList.add(custMap);
        }
        dashboard.setRecentCustomers(recentCustomersList);
        
        // Low stock alerts
        List<Item> lowStockItems = itemDAO.getLowStockItems();
        List<Map<String, Object>> lowStockAlerts = new ArrayList<>();
        
        int alertCount = 0;
        for (Item item : lowStockItems) {
            if (alertCount >= 5) break;
            
            Map<String, Object> alert = new HashMap<>();
            alert.put("itemId", item.getItemId());
            alert.put("itemCode", item.getItemCode());
            alert.put("itemName", item.getItemName());
            alert.put("currentStock", item.getQuantityInStock());
            alert.put("reorderLevel", item.getReorderLevel());
            lowStockAlerts.add(alert);
            alertCount++;
        }
        dashboard.setLowStockAlerts(lowStockAlerts);
        
        // Chart data - Sales for last 7 days
        List<String> salesChartLabels = new ArrayList<>();
        List<Double> salesChartData = new ArrayList<>();
        SimpleDateFormat sdf = new SimpleDateFormat("MMM dd");
        
        for (int i = 6; i >= 0; i--) {
            Calendar dayCal = Calendar.getInstance();
            dayCal.add(Calendar.DATE, -i);
            salesChartLabels.add(sdf.format(dayCal.getTime()));
            
            // Get sales for this day
            Date dayStart = DateUtil.getStartOfDay(dayCal.getTime());
            Date dayEnd = DateUtil.getEndOfDay(dayCal.getTime());
            double daySales = billDAO.getSalesTotalByDateRange(dayStart, dayEnd);
            salesChartData.add(daySales);
        }
        
        dashboard.setSalesChartLabels(salesChartLabels);
        dashboard.setSalesChartData(salesChartData);
        
        return dashboard;
    }
    
    @Override
    public List<Map<String, Object>> getSalesByCategory(Date startDate, Date endDate) 
            throws DatabaseException {
        
        List<Map<String, Object>> salesByCategory = billItemDAO.getRevenueByCategory(
            DateUtil.formatDate(startDate), 
            DateUtil.formatDate(endDate)
        );
        
        // Calculate percentages
        double totalSales = 0.0;
        for (Map<String, Object> cat : salesByCategory) {
            totalSales += (Double) cat.get("totalRevenue");
        }
        
        for (Map<String, Object> cat : salesByCategory) {
            double revenue = (Double) cat.get("totalRevenue");
            cat.put("sales", revenue);
            cat.put("percentage", totalSales > 0 ? (revenue / totalSales * 100) : 0.0);
        }
        
        return salesByCategory;
    }
    
    @Override
    public List<Map<String, Object>> getTopSellingItems(Date startDate, Date endDate, int limit) 
            throws DatabaseException {
        
        if (limit <= 0) {
            limit = 10;
        }
        
        return billDAO.getTopSellingItems(startDate, endDate, limit);
    }
    
    @Override
    public Map<String, List<?>> getSalesTrend(int days) throws DatabaseException {
        if (days <= 0) {
            days = 7;
        }
        
        Map<String, List<?>> trend = new HashMap<>();
        List<String> labels = new ArrayList<>();
        List<Double> data = new ArrayList<>();
        
        SimpleDateFormat sdf = new SimpleDateFormat("MMM dd");
        
        for (int i = days - 1; i >= 0; i--) {
            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.DATE, -i);
            labels.add(sdf.format(cal.getTime()));
            
            // Get actual sales for this day
            Date dayStart = DateUtil.getStartOfDay(cal.getTime());
            Date dayEnd = DateUtil.getEndOfDay(cal.getTime());
            double daySales = billDAO.getSalesTotalByDateRange(dayStart, dayEnd);
            data.add(daySales);
        }
        
        trend.put("labels", labels);
        trend.put("data", data);
        
        return trend;
    }
    
    @Override
    public ReportDTO getMonthlySummary(int year, int month) throws DatabaseException {
        Calendar cal = Calendar.getInstance();
        cal.set(year, month - 1, 1);
        Date startDate = cal.getTime();
        
        cal.add(Calendar.MONTH, 1);
        cal.add(Calendar.DATE, -1);
        Date endDate = cal.getTime();
        
        try {
            return generateSalesReport(startDate, endDate);
        } catch (BusinessException e) {
            // This shouldn't happen as we're constructing valid dates
            throw new DatabaseException("Error generating monthly summary: " + e.getMessage(), e);
        }
    }
    
    @Override
    public String exportReportToCSV(ReportDTO report) {
        StringBuilder csv = new StringBuilder();
        
        // Header
        csv.append("Report: ").append(report.getReportTitle()).append("\n");
        csv.append("Generated: ").append(new Date()).append("\n");
        if (report.getStartDate() != null && report.getEndDate() != null) {
            csv.append("Period: ").append(report.getDateRangeText()).append("\n");
        }
        csv.append("\n");
        
        // Content based on report type
        if ("DAILY_SALES".equals(report.getReportType()) || "SALES".equals(report.getReportType())) {
            csv.append("Total Sales,").append(report.getTotalSales()).append("\n");
            csv.append("Total Bills,").append(report.getTotalBills()).append("\n");
            csv.append("Total Customers,").append(report.getTotalCustomers()).append("\n");
            csv.append("Average Bill Value,").append(report.getAverageBillValue()).append("\n");
            
            // Add hourly breakdown for daily sales
            if ("DAILY_SALES".equals(report.getReportType()) && report.getHourlyBreakdown() != null) {
                csv.append("\nHourly Breakdown\n");
                csv.append("Hour,Bills,Sales Amount\n");
                for (Map<String, Object> hour : report.getHourlyBreakdown()) {
                    csv.append(hour.get("hour")).append(",");
                    csv.append(hour.get("bills")).append(",");
                    csv.append(hour.get("sales")).append("\n");
                }
            }
        } else if ("STOCK".equals(report.getReportType())) {
            csv.append("Total Items,").append(report.getTotalItems()).append("\n");
            csv.append("Low Stock Items,").append(report.getLowStockItems()).append("\n");
            csv.append("Out of Stock Items,").append(report.getOutOfStockItems()).append("\n");
            csv.append("Total Stock Value,").append(report.getTotalStockValue()).append("\n");
            
            // Add stock by category
            if (report.getStockByCategory() != null) {
                csv.append("\nStock by Category\n");
                csv.append("Category,Item Count,Stock Value\n");
                for (Map<String, Object> cat : report.getStockByCategory()) {
                    csv.append(cat.get("category")).append(",");
                    csv.append(cat.get("itemCount")).append(",");
                    csv.append(cat.get("stockValue")).append("\n");
                }
            }
        } else if ("CUSTOMER".equals(report.getReportType())) {
            csv.append("Total Customers,").append(report.getTotalCustomers()).append("\n");
            csv.append("Active Customers,").append(report.getActiveCustomers()).append("\n");
            csv.append("Inactive Customers,").append(report.getInactiveCustomers()).append("\n");
            
            // Add top customers
            if (report.getTopCustomers() != null) {
                csv.append("\nTop Customers\n");
                csv.append("Account Number,Customer Name,Total Purchases,Bill Count\n");
                for (Map<String, Object> cust : report.getTopCustomers()) {
                    csv.append(cust.get("accountNumber")).append(",");
                    csv.append(cust.get("customerName")).append(",");
                    csv.append(cust.get("totalPurchases")).append(",");
                    csv.append(cust.get("billCount")).append("\n");
                }
            }
        }
        
        return csv.toString();
    }
    
    @Override
    public List<String> getAvailableReportTypes() {
        return Arrays.asList(
            "Daily Sales Report",
            "Sales Report",
            "Stock Report",
            "Low Stock Report",
            "Customer Report",
            "Monthly Summary"
        );
    }
    
    @Override
    public void validateDateRange(Date startDate, Date endDate) throws BusinessException {
        if (startDate == null || endDate == null) {
            throw new BusinessException("Start date and end date are required");
        }
        
        if (startDate.after(endDate)) {
            throw new BusinessException("Start date cannot be after end date");
        }
        
        // Check if date range is not too large (e.g., more than 1 year)
        long diffInMillis = endDate.getTime() - startDate.getTime();
        long diffInDays = diffInMillis / (1000 * 60 * 60 * 24);
        
        if (diffInDays > 365) {
            throw new BusinessException("Date range cannot exceed 365 days");
        }
    }
}