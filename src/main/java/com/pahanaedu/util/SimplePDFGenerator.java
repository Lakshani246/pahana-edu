package com.pahanaedu.util;

import com.pahanaedu.model.Bill;
import com.pahanaedu.model.BillItem;
import java.text.SimpleDateFormat;
import java.text.DecimalFormat;

/**
 * Simple PDF Generator for bills
 * Note: This creates an HTML string that can be converted to PDF using browser's print functionality
 * For a real PDF, you would need libraries like iText or Apache PDFBox
 */
public class SimplePDFGenerator {
    
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd");
    private static final SimpleDateFormat TIME_FORMAT = new SimpleDateFormat("HH:mm:ss");
    private static final DecimalFormat DECIMAL_FORMAT = new DecimalFormat("#,##0.00");
    
    /**
     * Generate HTML content for bill that can be printed as PDF
     * @param bill Bill object
     * @param companyName Company name
     * @param companyAddress Company address
     * @param companyPhone Company phone
     * @return HTML string
     */
    public static String generateBillHTML(Bill bill, String companyName, 
                                         String companyAddress, String companyPhone) {
        StringBuilder html = new StringBuilder();
        
        // Start HTML
        html.append("<!DOCTYPE html>");
        html.append("<html>");
        html.append("<head>");
        html.append("<meta charset='UTF-8'>");
        html.append("<title>Bill #").append(bill.getBillNumber()).append("</title>");
        html.append(getInlineStyles());
        html.append("</head>");
        html.append("<body>");
        
        // Header
        html.append("<div class='header'>");
        html.append("<h1>").append(companyName).append("</h1>");
        html.append("<p>").append(companyAddress).append("</p>");
        html.append("<p>Tel: ").append(companyPhone).append("</p>");
        html.append("<h2>INVOICE</h2>");
        html.append("<p>Bill No: ").append(bill.getBillNumber()).append("</p>");
        html.append("</div>");
        
        // Customer Info
        html.append("<div class='info'>");
        html.append("<div class='customer'>");
        html.append("<h3>Bill To:</h3>");
        html.append("<p><strong>").append(bill.getCustomer().getCustomerName()).append("</strong></p>");
        html.append("<p>").append(bill.getCustomer().getAddress()).append("</p>");
        if (bill.getCustomer().getCity() != null) {
            html.append("<p>").append(bill.getCustomer().getCity()).append("</p>");
        }
        html.append("<p>Tel: ").append(bill.getCustomer().getTelephone()).append("</p>");
        html.append("</div>");
        
        html.append("<div class='details'>");
        html.append("<p><strong>Date:</strong> ").append(DATE_FORMAT.format(bill.getBillDate())).append("</p>");
        html.append("<p><strong>Time:</strong> ").append(TIME_FORMAT.format(bill.getBillTime())).append("</p>");
        html.append("<p><strong>Account:</strong> ").append(bill.getCustomer().getAccountNumber()).append("</p>");
        html.append("<p><strong>Payment:</strong> ").append(bill.getPaymentMethod()).append("</p>");
        html.append("</div>");
        html.append("</div>");
        
        // Items Table
        html.append("<table class='items'>");
        html.append("<thead>");
        html.append("<tr>");
        html.append("<th>#</th>");
        html.append("<th>Item Code</th>");
        html.append("<th>Description</th>");
        html.append("<th>Qty</th>");
        html.append("<th>Unit Price</th>");
        html.append("<th>Total</th>");
        html.append("</tr>");
        html.append("</thead>");
        html.append("<tbody>");
        
        int count = 1;
        for (BillItem item : bill.getBillItems()) {
            html.append("<tr>");
            html.append("<td>").append(count++).append("</td>");
            html.append("<td>").append(item.getItem().getItemCode()).append("</td>");
            html.append("<td>").append(item.getItem().getItemName()).append("</td>");
            html.append("<td class='center'>").append(item.getQuantity()).append("</td>");
            html.append("<td class='right'>").append(DECIMAL_FORMAT.format(item.getUnitPrice())).append("</td>");
            html.append("<td class='right'>").append(DECIMAL_FORMAT.format(item.getTotalPrice())).append("</td>");
            html.append("</tr>");
        }
        
        html.append("</tbody>");
        html.append("</table>");
        
        // Summary
        html.append("<div class='summary'>");
        html.append("<table>");
        html.append("<tr><td>Subtotal:</td><td>").append(DECIMAL_FORMAT.format(bill.getSubtotal())).append("</td></tr>");
        if (bill.getDiscountAmount() > 0) {
            html.append("<tr><td>Discount:</td><td>-").append(DECIMAL_FORMAT.format(bill.getDiscountAmount())).append("</td></tr>");
        }
        if (bill.getTaxAmount() > 0) {
            html.append("<tr><td>Tax:</td><td>+").append(DECIMAL_FORMAT.format(bill.getTaxAmount())).append("</td></tr>");
        }
        html.append("<tr class='total'><td><strong>Total:</strong></td><td><strong>LKR ").append(DECIMAL_FORMAT.format(bill.getTotalAmount())).append("</strong></td></tr>");
        html.append("</table>");
        html.append("</div>");
        
        // Footer
        html.append("<div class='footer'>");
        html.append("<p class='thank-you'>Thank you for your business!</p>");
        html.append("<div class='signatures'>");
        html.append("<div class='signature'>");
        html.append("<p>_____________________</p>");
        html.append("<p>Authorized Signature</p>");
        html.append("</div>");
        html.append("<div class='signature'>");
        html.append("<p>_____________________</p>");
        html.append("<p>Customer Signature</p>");
        html.append("</div>");
        html.append("</div>");
        html.append("</div>");
        
        html.append("</body>");
        html.append("</html>");
        
        return html.toString();
    }
    
    /**
     * Get inline styles for the HTML
     */
    private static String getInlineStyles() {
        return "<style>" +
            "body { font-family: Arial, sans-serif; font-size: 12pt; margin: 20px; }" +
            ".header { text-align: center; border-bottom: 2px solid #333; padding-bottom: 20px; margin-bottom: 20px; }" +
            ".header h1 { margin: 0; color: #2c3e50; }" +
            ".header h2 { margin: 10px 0; }" +
            ".info { display: flex; justify-content: space-between; margin-bottom: 30px; }" +
            ".customer { flex: 1; }" +
            ".details { text-align: right; }" +
            ".items { width: 100%; border-collapse: collapse; margin-bottom: 30px; }" +
            ".items th { background: #2c3e50; color: white; padding: 10px; text-align: left; }" +
            ".items td { padding: 8px; border-bottom: 1px solid #ddd; }" +
            ".center { text-align: center; }" +
            ".right { text-align: right; }" +
            ".summary { text-align: right; margin-bottom: 30px; }" +
            ".summary table { margin-left: auto; }" +
            ".summary td { padding: 5px 10px; }" +
            ".total { border-top: 2px solid #333; font-size: 14pt; }" +
            ".footer { border-top: 1px solid #ddd; padding-top: 20px; }" +
            ".thank-you { text-align: center; font-size: 14pt; font-style: italic; margin-bottom: 30px; }" +
            ".signatures { display: flex; justify-content: space-around; }" +
            ".signature { text-align: center; }" +
            "@media print { body { margin: 0; } }" +
            "</style>";
    }
    
    /**
     * Generate a simple text-based bill (for email or basic printing)
     */
    public static String generateBillText(Bill bill, String companyName) {
        StringBuilder text = new StringBuilder();
        String line = "=".repeat(60);
        
        text.append(line).append("\n");
        text.append(centerText(companyName, 60)).append("\n");
        text.append(centerText("INVOICE", 60)).append("\n");
        text.append(line).append("\n\n");
        
        text.append("Bill No: ").append(bill.getBillNumber()).append("\n");
        text.append("Date: ").append(DATE_FORMAT.format(bill.getBillDate())).append("\n");
        text.append("Time: ").append(TIME_FORMAT.format(bill.getBillTime())).append("\n\n");
        
        text.append("BILL TO:\n");
        text.append(bill.getCustomer().getCustomerName()).append("\n");
        text.append(bill.getCustomer().getAddress()).append("\n");
        text.append("Tel: ").append(bill.getCustomer().getTelephone()).append("\n\n");
        
        text.append(line).append("\n");
        text.append(String.format("%-20s %-5s %-10s %10s\n", "ITEM", "QTY", "PRICE", "TOTAL"));
        text.append(line).append("\n");
        
        for (BillItem item : bill.getBillItems()) {
            text.append(String.format("%-20s %5d %10s %10s\n",
                truncate(item.getItem().getItemName(), 20),
                item.getQuantity(),
                DECIMAL_FORMAT.format(item.getUnitPrice()),
                DECIMAL_FORMAT.format(item.getTotalPrice())
            ));
        }
        
        text.append(line).append("\n");
        text.append(String.format("%36s %10s\n", "Subtotal:", DECIMAL_FORMAT.format(bill.getSubtotal())));
        if (bill.getDiscountAmount() > 0) {
            text.append(String.format("%36s -%9s\n", "Discount:", DECIMAL_FORMAT.format(bill.getDiscountAmount())));
        }
        if (bill.getTaxAmount() > 0) {
            text.append(String.format("%36s +%9s\n", "Tax:", DECIMAL_FORMAT.format(bill.getTaxAmount())));
        }
        text.append(line).append("\n");
        text.append(String.format("%36s %10s\n", "TOTAL:", "LKR " + DECIMAL_FORMAT.format(bill.getTotalAmount())));
        text.append(line).append("\n\n");
        
        text.append(centerText("Thank you for your business!", 60)).append("\n");
        
        return text.toString();
    }
    
    private static String centerText(String text, int width) {
        int padding = (width - text.length()) / 2;
        return " ".repeat(Math.max(0, padding)) + text;
    }
    
    private static String truncate(String text, int maxLength) {
        if (text.length() <= maxLength) {
            return text;
        }
        return text.substring(0, maxLength - 3) + "...";
    }
}