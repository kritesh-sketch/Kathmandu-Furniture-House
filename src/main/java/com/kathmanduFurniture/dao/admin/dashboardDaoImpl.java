package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.entity.user.Order;
import com.kathmanduFurniture.entity.user.Product;
import com.kathmanduFurniture.entity.user.User;
import com.kathmanduFurniture.utils.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

/**
 * JDBC implementation of {@link DashboardDao}.
 * Calculates KPI metrics and month-over-month trend percentages for the dashboard.
 */
public class DashboardDaoImpl implements DashboardDao {

    // =========================================================
    //                     REVENUE SECTION
    // =========================================================

    /*
    Calculates total revenue of all time by multiplying
    selling price with quantity sold from sales and products table
     */

    @Override
    public double calculateTotalRevenue() {
        double totalRevenue = 0;
        Connection conn = null;

        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT COALESCE(SUM(total_amount), 0) AS total_revenue " +
                         "FROM orders " +
                         "WHERE order_type = 'Normal' AND status != 'Cancelled'";

            PreparedStatement statement = conn.prepareStatement(sql);
            ResultSet rs = statement.executeQuery();

            if (rs.next()) {
                totalRevenue = rs.getDouble("total_revenue");
            }

        } catch (SQLException e) {
            System.out.println("Error calculating total revenue: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return totalRevenue;
    }

    // Returns percentage of increase or decrease in sales
    // between current month and previous month automatically from system date
    @Override
    public double showCurrentMonthSalesReport() {
        double totalSales = 0;
        Connection conn = null;

        try{
            conn = DatabaseConnection.getConnection();
            String sql =
                    "SELECT SUM(s.selling_price * s.quantity_sold) AS total_sales " +
                            "FROM sales s " +
                            "WHERE DATE_FORMAT(s.sale_date, '%Y-%m') = ?";
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM");
            String currentMonth = LocalDate.now().format(formatter);
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setString(1, currentMonth);
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                totalSales = rs.getDouble("total_sales");
            }

        } catch (SQLException e) {
            System.out.println("Error calculating current month sales report: " + e.getMessage());
        }finally {
            DatabaseConnection.closeConnection(conn);
        }
        return totalSales;
    }

    // Fetches total sales amount for a given month
    // used internally by showCurrentMonthSalesReport()
    private double getSalesByMonth(String month) {
        double total = 0;
        Connection conn = null;

        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT COALESCE(SUM(s.selling_price * s.quantity_sold), 0) AS total " +
                    "FROM sales s " +
                    "WHERE DATE_FORMAT(s.sale_date, '%Y-%m') = ?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, month);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                total = rs.getDouble("total");
            }

        } catch (SQLException e) {
            System.out.println("Error fetching sales by month: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return total;
    }


    // =========================================================
    //                     ORDER SECTION
    // =========================================================

    // Returns list of all orders with customer name,
    // product name, amount and status from orders table
    @Override
    public int getAllOrdersNumber() {
        int totalOrder = 0;
        Connection conn = null;

        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT COUNT(*) AS total_order FROM orders";

            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                totalOrder = rs.getInt("total_order");
            }

        } catch (SQLException e) {
            System.out.println("Error fetching orders: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return totalOrder;
    }

    // Returns percentage of increase or decrease in orders
    // between current month and previous month automatically from system date
    @Override
    public double getOrderIncreasePercentage() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM");
        String currentMonth  = LocalDate.now().format(formatter);
        String previousMonth = LocalDate.now().minusMonths(1).format(formatter);

        double currentOrders  = getOrdersByMonth(currentMonth);
        double previousOrders = getOrdersByMonth(previousMonth);

        if (previousOrders == 0) return currentOrders > 0 ? 100.0 : 0.0;

        double percentage = ((currentOrders - previousOrders) / previousOrders) * 100;
        return Math.round(percentage * 100.0) / 100.0;
    }

    // Fetches total order count for a given month
    // used internally by getOrderIncreasePercentage()
    private double getOrdersByMonth(String month) {
        double total = 0;
        Connection conn = null;

        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT COUNT(*) AS total_orders " +
                    "FROM orders " +
                    "WHERE DATE_FORMAT(order_date, '%Y-%m') = ?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, month);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                total = rs.getDouble("total_orders");
            }

        } catch (SQLException e) {
            System.out.println("Error fetching orders by month: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return total;
    }


    // =========================================================
    //                     PRODUCT SECTION
    // =========================================================

    // Returns total count of all products in the system
    @Override
    public int getTotalProducts() {
        int total = 0;
        Connection conn = null;

        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT COUNT(*) AS total_products FROM products";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                total = rs.getInt("total_products");
            }

        } catch (Exception e) {
            System.out.println("Error counting all products: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return total;
    }

    // Returns total count of products with status Active
    // these are products currently available for customers to buy
    @Override
    public int getActiveProducts() {
        int active = 0;
        Connection conn = null;

        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT COUNT(*) AS active_products FROM products WHERE status='Active'";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                active = rs.getInt("active_products");
            }

        } catch (Exception e) {
            System.out.println("Error fetching active products: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return active;
    }

    // Returns percentage of increase or decrease in active products
    // between current month and previous month automatically from system date
    @Override
    public double getActiveProductIncreasePercentage() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM");
        String currentMonth  = LocalDate.now().format(formatter);
        String previousMonth = LocalDate.now().minusMonths(1).format(formatter);

        double currentActive  = getActiveProductsByMonth(currentMonth);
        double previousActive = getActiveProductsByMonth(previousMonth);

        if (previousActive == 0) return currentActive > 0 ? 100.0 : 0.0;

        double percentage = ((currentActive - previousActive) / previousActive) * 100;
        return Math.round(percentage * 100.0) / 100.0;
    }

    // Fetches total active product count for a given month
    // used internally by getActiveProductIncreasePercentage()
    private double getActiveProductsByMonth(String month) {
        double total = 0;
        Connection conn = null;

        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT COUNT(*) AS active_products " +
                    "FROM products " +
                    "WHERE status = 'Active' " +
                    "AND DATE_FORMAT(created_at, '%Y-%m') = ?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, month);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                total = rs.getDouble("active_products");
            }

        } catch (SQLException e) {
            System.out.println("Error fetching active products by month: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return total;
    }


    // =========================================================
    //                     USER SECTION
    // =========================================================

    // Returns total count of all customers registered in the system
    @Override
    public int getTotalCustomers() {
        int totalCustomer = 0;
        Connection conn = null;

        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT COUNT(*) AS total_customers FROM users";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                totalCustomer = rs.getInt("total_customers");
            }

        } catch (Exception e) {
            System.out.println("Error fetching total customers: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return totalCustomer;
    }

    // Returns percentage of increase or decrease in new users
    // between current month and previous month automatically from system date
    @Override
    public double getUserIncreasePercentage() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM");
        String currentMonth  = LocalDate.now().format(formatter);
        String previousMonth = LocalDate.now().minusMonths(1).format(formatter);

        double currentUsers  = getUsersByMonth(currentMonth);
        double previousUsers = getUsersByMonth(previousMonth);

        if (previousUsers == 0) return currentUsers > 0 ? 100.0 : 0.0;

        double percentage = ((currentUsers - previousUsers) / previousUsers) * 100;
        return Math.round(percentage * 100.0) / 100.0;
    }

    // Fetches total user count registered in a given month
    // used internally by getUserIncreasePercentage()
    private double getUsersByMonth(String month) {
        double total = 0;
        Connection conn = null;

        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT COUNT(*) AS total_users " +
                    "FROM users " +
                    "WHERE DATE_FORMAT(created_at, '%Y-%m') = ?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, month);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                total = rs.getDouble("total_users");
            }

        } catch (SQLException e) {
            System.out.println("Error fetching users by month: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return total;
    }

    // -----------------------------------------------------------------------------------------//
    @Override
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        Connection conn = null;

        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT o.id AS order_number, " +
                    "CONCAT(u.firstName, ' ', u.lastName) AS customer_name, " +
                    "p.product_name, " +
                    "o.total_amount AS amount, " +
                    "o.status " +
                    "FROM orders o " +
                    "JOIN users u ON o.customer_id = u.id " +
                    "JOIN products p ON o.product_id = p.id " +
                    "ORDER BY o.id DESC LIMIT 5";

            PreparedStatement statement = conn.prepareStatement(sql);
            ResultSet rs = statement.executeQuery();

            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("order_number"));
                order.setCustomerName(rs.getString("customer_name"));
                order.setProductName(rs.getString("product_name"));
                order.setAmount(rs.getDouble("amount"));
                order.setStatus(rs.getString("status"));
                list.add(order);
            }

        } catch (SQLException e) {
            System.out.println("Error fetching orders: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return list;
    }


}
