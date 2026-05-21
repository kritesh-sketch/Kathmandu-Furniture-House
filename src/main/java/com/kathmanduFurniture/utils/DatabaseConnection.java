package com.kathmanduFurniture.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Utility class for managing JDBC connections to the MySQL database.
 * The MySQL driver is registered once via a static initialiser block.
 * Each call to {@link #getConnection()} opens a new connection — this
 * application does not use a connection pool.
 */
public class DatabaseConnection {

    // JDBC connection URL pointing to the local MySQL instance
    private static final String DB_URL      = "jdbc:mysql://localhost:3306/kathmandu_furniture";
    private static final String DB_USER     = "root";
    private static final String DB_PASSWORD = "";

    // Register the MySQL JDBC driver when the class is first loaded
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("MySQL Driver not found: " + e.getMessage());
        }
    }

    /**
     * Opens and returns a new JDBC connection to the database.
     * Callers are responsible for closing the connection (see {@link #closeConnection}).
     *
     * @return an open {@link Connection}
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    /**
     * Safely closes a JDBC connection, suppressing any exception that occurs.
     * Passing null is safe and has no effect.
     *
     * @param connection the connection to close (may be null)
     */
    public static void closeConnection(Connection connection) {
        try {
            if (connection != null) {
                connection.close(); // release the connection back to the driver
            }
        } catch (SQLException e) {
            System.out.println("Error closing connection: " + e.getMessage());
        }
    }
}
