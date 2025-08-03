package com.pahanaedu.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Singleton class for database connection management
 * This class ensures only one database connection instance is created
 */
public class DBConnection {
    
    private static DBConnection instance;
    private Connection connection;
    
    // Database configuration constants
    private static final String DB_URL = "jdbc:mysql://localhost:3306/pahana_edu_db?useSSL=false&serverTimezone=UTC";
    private static final String DB_USERNAME = "root";
    private static final String DB_PASSWORD = "2001kkkK@@"; 
    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";
    
    /**
     * Private constructor to prevent instantiation from outside
     */
    private DBConnection() throws SQLException {
        try {
            // Load MySQL JDBC driver
            Class.forName(DB_DRIVER);
            
            // Create database connection
            this.connection = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
            
            System.out.println("Database connection established successfully!");
            
        } catch (ClassNotFoundException ex) {
            throw new SQLException("Database Driver not found: " + ex.getMessage());
        } catch (SQLException ex) {
            throw new SQLException("Failed to connect to database: " + ex.getMessage());
        }
    }
    
    /**
     * Get singleton instance of DBConnection
     * @return DBConnection instance
     * @throws SQLException if connection fails
     */
    public static DBConnection getInstance() throws SQLException {
        if (instance == null) {
            instance = new DBConnection();
        } else if (instance.getConnection().isClosed()) {
            instance = new DBConnection();
        }
        return instance;
    }
    
    /**
     * Get database connection
     * @return Connection object
     */
    public Connection getConnection() {
        return connection;
    }
    
    /**
     * Close database connection
     */
    public void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                System.out.println("Database connection closed.");
            }
        } catch (SQLException e) {
            System.err.println("Error closing connection: " + e.getMessage());
        }
    }
    
    /**
     * Check if connection is valid
     * @return true if connection is valid, false otherwise
     */
    public boolean isConnectionValid() {
        try {
            return connection != null && !connection.isClosed() && connection.isValid(5);
        } catch (SQLException e) {
            return false;
        }
    }
}