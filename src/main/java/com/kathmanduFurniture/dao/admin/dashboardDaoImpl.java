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

public class dashboardDaoImpl implements dashboardDao {

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
            String sql = "SELECT SUM(p.selling_price * s.quantity_sold) AS total_revenue " +
                    "FROM sales s " +
                    "JOIN products p ON s.product_id = p.id";

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
                    "SELECT SUM(p.selling_price * s.quantity_sold) AS total_sales " +
                            "FROM sales s " +
                            "JOIN products p ON s.product_id = p.id " +
                            "WHERE DATE_FORMAT(s.sale_date, '%Y-%m') = ?";
            PreparedStatement statement = conn.prepareStatement(sql);
//            statement.setString(1, month);
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                totalSales = rs.getDouble("totalSales");
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
            String sql = "SELECT COALESCE(SUM(p.selling_price * s.quantity_sold), 0) AS total " +
                    "FROM sales s " +
                    "JOIN products p ON s.product_id = p.id " +
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

        if (previousOrders == 0) return 0.0;

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
            String sql = "SELECT COUNT(*) AS total_products FROM product";
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
            String sql = "SELECT COUNT(*) AS active_products FROM product WHERE status='Active'";
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

        if (previousActive == 0) return 0.0;

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
                    "FROM product " +
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
        int total_customer = 0;
        Connection conn = null;

        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT COUNT(*) AS total_customers FROM users";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                total_customer = rs.getInt("total_customers");
            }

        } catch (Exception e) {
            System.out.println("Error fetching total customers: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return total_customer;
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

        if (previousUsers == 0) return 0.0;

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
                    "u.full_name AS customer_name, " +
                    "p.product_name, " +
                    "o.total_amount AS amount, " +
                    "o.status " +
                    "FROM orders o " +
                    "JOIN users u ON o.customer_id = u.id " +
                    "JOIN products p ON o.product_id = p.id " +
                    "ORDER BY o.id DESC";

            PreparedStatement statement = conn.prepareStatement(sql);
            ResultSet rs = statement.executeQuery();

            while (rs.next()) {
                Order oder = new Order();
                oder.setId(rs.getInt("order_number"));
                oder.setCustomerName(rs.getString("customer_name"));
                oder.setProductName(rs.getString("product_name"));
                oder.setAmount(rs.getDouble("amount"));
                oder.setStatus(rs.getString("status"));
                list.add(oder);
            }

        } catch (SQLException e) {
            System.out.println("Error fetching orders: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return list;
    }


}