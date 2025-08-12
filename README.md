# Pahana Edu Bookshop Management System

A comprehensive web-based billing and inventory management system for Pahana Edu Bookshop, built with Java EE technologies.

## 📋 About The Project

This system streamlines bookshop operations by providing integrated modules for customer management, inventory control, billing, and reporting. Developed as a final year project, it demonstrates enterprise-level Java web application development using MVC architecture.

## 🚀 Features

- **Customer Management**: Register and manage customer information with unique account numbers
- **Inventory Management**: Track stock levels, manage items, and monitor stock movements
- **Billing System**: Create bills with automatic calculations, discounts, and tax handling
- **PDF Generation**: Generate professional invoice PDFs for customers
- **Stock Tracking**: Real-time stock updates with movement history
- **User Authentication**: Secure login system with role-based access control
- **Dashboard Analytics**: View sales summaries and business metrics
- **Reporting**: Generate various business reports

## 🛠️ Built With

- **Backend**: Java 17, Servlets 4.0, JSP 2.3, JSTL 1.2
- **Frontend**: HTML5, CSS3, JavaScript, Bootstrap 5.3, jQuery 3.6
- **Database**: MySQL 8.0
- **Server**: Apache Tomcat 9.0
- **Build Tool**: Apache Maven 3.8.6
- **PDF Generation**: OpenPDF
- **IDE**: Eclipse IDE for Enterprise Java Developers

## 📁 Project Structure

```
pahana-edu-system/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/pahanaedu/
│       │       ├── controller/     # Servlet controllers
│       │       ├── service/        # Business logic
│       │       ├── dao/           # Data access layer
│       │       ├── model/         # Entity classes
│       │       ├── dto/           # Data transfer objects
│       │       ├── util/          # Utility classes
│       │       ├── constant/      # System constants
│       │       ├── filter/        # Security filters
│       │       └── exception/     # Custom exceptions
│       └── webapp/
│           ├── views/             # JSP pages
│           ├── assets/            # CSS, JS, images
│           └── WEB-INF/          # Configuration files
├── pom.xml                       # Maven configuration
└── README.md                     # Project documentation
```

## 🔧 Installation

### Prerequisites
- JDK 17 or higher
- Apache Tomcat 9.0
- MySQL 8.0
- Maven 3.8+

### Setup Steps

1. **Clone the repository**
```bash
git clone https://github.com/Lakshani246/Pahana-Edu-Books-shop-system.git
cd Pahana-Edu-Books-shop-system
```

2. **Create MySQL Database**
```sql
CREATE DATABASE pahana_edu_db;
```

3. **Configure Database Connection**
- Update database credentials in `src/main/java/com/pahanaedu/util/DBConnection.java`
```java
private static final String DB_URL = "jdbc:mysql://localhost:3306/pahana_edu_db";
private static final String DB_USERNAME = "your_username";
private static final String DB_PASSWORD = "your_password";
```

4. **Build the Project**
```bash
mvn clean install
```

5. **Deploy to Tomcat**
- Copy the generated WAR file from `target/` to Tomcat's `webapps/` directory
- Start Tomcat server

6. **Access the Application**
```
http://localhost:8080/pahana-edu-system
```

## 💻 Usage

### Default Login Credentials
- **Username**: admin
- **Password**: admin123

### Main Modules

1. **Customer Management**
   - Add new customers with auto-generated account numbers
   - View and update customer information
   - Track customer purchase history

2. **Inventory Management**
   - Add new items with categories
   - Update stock quantities
   - Monitor low stock items

3. **Billing**
   - Create new bills with multiple items
   - Apply discounts and calculate taxes
   - Generate PDF invoices

4. **Reports**
   - View daily/monthly sales reports
   - Track inventory movements
   - Customer purchase analytics

## 📊 Database Schema

The system uses a normalized MySQL database with the following main tables:
- `users` - System users and authentication
- `customers` - Customer information
- `items` - Product inventory
- `categories` - Item categories
- `bills` - Sales transactions
- `bill_items` - Bill line items
- `stock_movements` - Inventory tracking

## 🔒 Security Features

- Password hashing using BCrypt
- Session-based authentication
- SQL injection prevention via prepared statements
- Input validation and sanitization
- Role-based access control

## 📈 Future Enhancements

- [ ] RESTful API implementation
- [ ] Email notification system
- [ ] Advanced reporting with charts
- [ ] Barcode scanning support
- [ ] Multi-branch support
- [ ] Online payment integration

## 🤝 Contributing

This is a university project and is not open for contributions. However, feel free to fork and adapt for your own use.

## 📝 License

This project is developed for educational purposes as part of academic requirements.

## 👨‍💻 Developer

**Lakshani246**
- Assignment Project
- BSc (Hons) in Software Engineering

## 🙏 Acknowledgments

- University supervisor for guidance
- Pahana Edu Bookshop for requirements
- Open source community for libraries used

---
*Last Updated: January 2025*
