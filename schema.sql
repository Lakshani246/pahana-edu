-- Drop database if exists and create new one
DROP DATABASE IF EXISTS pahana_edu_db;
CREATE DATABASE pahana_edu_db;
USE pahana_edu_db;

-- Users table for authentication
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role ENUM('ADMIN', 'STAFF', 'MANAGER') NOT NULL DEFAULT 'STAFF',
    is_active BOOLEAN DEFAULT TRUE,
    last_login TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    account_number VARCHAR(20) UNIQUE NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(50),
    postal_code VARCHAR(10),
    telephone VARCHAR(20) NOT NULL,
    mobile VARCHAR(20),
    email VARCHAR(100),
    nic_number VARCHAR(20) UNIQUE,
    registration_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(user_id),
    INDEX idx_account_number (account_number),
    INDEX idx_customer_name (customer_name)
);

-- Item categories table
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Items table (books and educational materials)
CREATE TABLE items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    item_code VARCHAR(20) UNIQUE NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    description TEXT,
    category_id INT,
    author VARCHAR(100),
    publisher VARCHAR(100),
    isbn VARCHAR(20),
    unit_price DECIMAL(10,2) NOT NULL,
    selling_price DECIMAL(10,2) NOT NULL,
    quantity_in_stock INT NOT NULL DEFAULT 0,
    reorder_level INT DEFAULT 10,
    is_active BOOLEAN DEFAULT TRUE,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (created_by) REFERENCES users(user_id),
    INDEX idx_item_code (item_code),
    INDEX idx_item_name (item_name)
);

-- Bills/Invoices table
CREATE TABLE bills (
    bill_id INT PRIMARY KEY AUTO_INCREMENT,
    bill_number VARCHAR(20) UNIQUE NOT NULL,
    customer_id INT NOT NULL,
    user_id INT NOT NULL,
    bill_date DATE NOT NULL,
    bill_time TIME NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    discount_percentage DECIMAL(5,2) DEFAULT 0,
    discount_amount DECIMAL(10,2) DEFAULT 0,
    tax_percentage DECIMAL(5,2) DEFAULT 0,
    tax_amount DECIMAL(10,2) DEFAULT 0,
    total_amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('CASH', 'CARD', 'CHEQUE', 'BANK_TRANSFER') DEFAULT 'CASH',
    payment_status ENUM('PAID', 'PENDING', 'PARTIAL', 'CANCELLED') DEFAULT 'PAID',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    INDEX idx_bill_number (bill_number),
    INDEX idx_bill_date (bill_date)
);

-- Bill items table (items in each bill)
CREATE TABLE bill_items (
    bill_item_id INT PRIMARY KEY AUTO_INCREMENT,
    bill_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    discount_percentage DECIMAL(5,2) DEFAULT 0,
    discount_amount DECIMAL(10,2) DEFAULT 0,
    total_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (bill_id) REFERENCES bills(bill_id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES items(item_id),
    INDEX idx_bill_id (bill_id)
);

-- Stock movements table (for tracking inventory)
CREATE TABLE stock_movements (
    movement_id INT PRIMARY KEY AUTO_INCREMENT,
    item_id INT NOT NULL,
    movement_type ENUM('IN', 'OUT', 'ADJUSTMENT', 'RETURN') NOT NULL,
    quantity INT NOT NULL,
    reference_type VARCHAR(50),
    reference_id INT,
    reason TEXT,
    user_id INT,
    movement_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (item_id) REFERENCES items(item_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    INDEX idx_item_movement (item_id, movement_date)
);

-- Insert default data

-- Default admin user (password: admin123 - should be hashed in real implementation)
INSERT INTO users (username, password, email, full_name, role) VALUES 
('admin', 'admin123', 'admin@pahanaedu.lk', 'System Administrator', 'ADMIN'),
('staff1', 'staff123', 'staff1@pahanaedu.lk', 'John Silva', 'STAFF'),
('manager1', 'manager123', 'manager@pahanaedu.lk', 'Sarah Perera', 'MANAGER');

-- Default categories
INSERT INTO categories (category_name, description) VALUES 
('Text Books', 'Academic text books for all grades'),
('Stationery', 'Pens, pencils, notebooks, and other stationery items'),
('Reference Books', 'Dictionaries, encyclopedias, and reference materials'),
('Workbooks', 'Exercise and practice workbooks'),
('Past Papers', 'Past examination papers and model papers');

-- Sample items
INSERT INTO items (item_code, item_name, description, category_id, author, publisher, unit_price, selling_price, quantity_in_stock) VALUES 
('TB001', 'Mathematics Grade 10', 'Grade 10 Mathematics textbook', 1, 'Dr. K. Jayawardena', 'Educational Publications', 450.00, 500.00, 50),
('TB002', 'Science Grade 9', 'Grade 9 Science textbook', 1, 'Prof. S. Fernando', 'Educational Publications', 400.00, 450.00, 45),
('ST001', 'Blue Pen Pack (10)', 'Pack of 10 blue ballpoint pens', 2, NULL, 'Atlas', 80.00, 100.00, 100),
('ST002', 'Exercise Book 200pg', '200 page ruled exercise book', 2, NULL, 'CR Books', 60.00, 75.00, 200),
('REF001', 'Oxford Dictionary', 'Oxford Advanced Learner Dictionary', 3, NULL, 'Oxford Press', 2500.00, 2800.00, 20);

-- Sample customers
INSERT INTO customers (account_number, customer_name, address, city, telephone, email, nic_number, registration_date, created_by) VALUES 
('CUST001', 'Nimal Perera', '123, Main Street', 'Colombo', '0112345678', 'nimal@email.com', '851234567V', CURDATE(), 1),
('CUST002', 'Kamani Silva', '45, Lake Road', 'Kandy', '0812234567', 'kamani@email.com', '925678901V', CURDATE(), 1),
('CUST003', 'Ruwan Fernando', '78, Hill Street', 'Galle', '0912345678', 'ruwan@email.com', '783456789V', CURDATE(), 1);

-- Create views for reporting

-- View for low stock items
CREATE VIEW low_stock_items AS
SELECT 
    i.item_code,
    i.item_name,
    c.category_name,
    i.quantity_in_stock,
    i.reorder_level,
    i.selling_price
FROM items i
JOIN categories c ON i.category_id = c.category_id
WHERE i.quantity_in_stock <= i.reorder_level
AND i.is_active = TRUE;

-- View for daily sales summary
CREATE VIEW daily_sales_summary AS
SELECT 
    DATE(b.bill_date) as sale_date,
    COUNT(DISTINCT b.bill_id) as total_bills,
    COUNT(DISTINCT b.customer_id) as unique_customers,
    SUM(b.total_amount) as total_sales,
    AVG(b.total_amount) as average_bill_value
FROM bills b
WHERE b.payment_status = 'PAID'
GROUP BY DATE(b.bill_date);

-- View for customer purchase history
CREATE VIEW customer_purchase_summary AS
SELECT 
    c.customer_id,
    c.account_number,
    c.customer_name,
    COUNT(DISTINCT b.bill_id) as total_purchases,
    SUM(b.total_amount) as total_spent,
    MAX(b.bill_date) as last_purchase_date
FROM customers c
LEFT JOIN bills b ON c.customer_id = b.customer_id
GROUP BY c.customer_id;

-- Create stored procedures

DELIMITER //

-- Procedure to generate next bill number
CREATE PROCEDURE generate_bill_number(OUT bill_number VARCHAR(20))
BEGIN
    DECLARE prefix VARCHAR(10) DEFAULT 'INV';
    DECLARE last_number INT;
    
    SELECT COALESCE(MAX(CAST(SUBSTRING(bill_number, LENGTH(prefix) + 1) AS UNSIGNED)), 0) + 1
    INTO last_number
    FROM bills
    WHERE bill_number LIKE CONCAT(prefix, '%');
    
    SET bill_number = CONCAT(prefix, LPAD(last_number, 6, '0'));
END//

-- Procedure to update stock after sale
CREATE PROCEDURE update_stock_after_sale(IN p_bill_id INT)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_item_id INT;
    DECLARE v_quantity INT;
    
    DECLARE cur CURSOR FOR 
        SELECT item_id, quantity 
        FROM bill_items 
        WHERE bill_id = p_bill_id;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO v_item_id, v_quantity;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Update item stock
        UPDATE items 
        SET quantity_in_stock = quantity_in_stock - v_quantity 
        WHERE item_id = v_item_id;
        
        -- Record stock movement
        INSERT INTO stock_movements (item_id, movement_type, quantity, reference_type, reference_id)
        VALUES (v_item_id, 'OUT', v_quantity, 'BILL', p_bill_id);
    END LOOP;
    
    CLOSE cur;
END//

DELIMITER ;

-- Create indexes for better performance
CREATE INDEX idx_customer_search ON customers(customer_name, telephone, email);
CREATE INDEX idx_item_search ON items(item_name, item_code);
CREATE INDEX idx_bill_search ON bills(bill_date, customer_id, payment_status);

-- Grant privileges (adjust as needed)
-- GRANT ALL PRIVILEGES ON pahana_edu_db.* TO 'pahana_user'@'localhost' IDENTIFIED BY 'your_password';
-- FLUSH PRIVILEGES;