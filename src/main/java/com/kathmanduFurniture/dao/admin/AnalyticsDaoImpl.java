package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.utils.DatabaseConnection;
import java.sql.*;

public class AnalyticsDaoImpl implements AnalyticsDao {

    @Override
    public String getMonthlyRevenueJson() {
        StringBuilder json = new StringBuilder("[");
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            String sql =
                "SELECT DATE_FORMAT(sale_date, '%b %Y') AS label, " +
                "       DATE_FORMAT(sale_date, '%Y-%m') AS month_key, " +
                "       COALESCE(SUM(selling_price * quantity_sold), 0) AS revenue " +
                "FROM sales " +
                "WHERE sale_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) " +
                "GROUP BY month_key, label " +
                "ORDER BY month_key";
            ResultSet rs = conn.prepareStatement(sql).executeQuery();
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                json.append("{\"label\":\"").append(rs.getString("label"))
                    .append("\",\"value\":").append(rs.getDouble("revenue")).append("}");
                first = false;
            }
        } catch (SQLException e) {
            System.out.println("Error fetching monthly revenue: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return json.append("]").toString();
    }

    @Override
    public String getOrdersByStatusJson() {
        StringBuilder json = new StringBuilder("[");
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT status, COUNT(*) AS cnt FROM orders GROUP BY status ORDER BY cnt DESC";
            ResultSet rs = conn.prepareStatement(sql).executeQuery();
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                json.append("{\"label\":\"").append(rs.getString("status"))
                    .append("\",\"value\":").append(rs.getInt("cnt")).append("}");
                first = false;
            }
        } catch (SQLException e) {
            System.out.println("Error fetching orders by status: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return json.append("]").toString();
    }

    @Override
    public String getTopProductsJson() {
        StringBuilder json = new StringBuilder("[");
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            String sql =
                "SELECT p.product_name, COUNT(o.id) AS order_count " +
                "FROM orders o " +
                "JOIN products p ON o.product_id = p.id " +
                "GROUP BY p.id, p.product_name " +
                "ORDER BY order_count DESC " +
                "LIMIT 5";
            ResultSet rs = conn.prepareStatement(sql).executeQuery();
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                String name = rs.getString("product_name").replace("\\", "\\\\").replace("\"", "\\\"");
                json.append("{\"label\":\"").append(name)
                    .append("\",\"value\":").append(rs.getInt("order_count")).append("}");
                first = false;
            }
        } catch (SQLException e) {
            System.out.println("Error fetching top products: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return json.append("]").toString();
    }

    @Override
    public String getMonthlyNewUsersJson() {
        StringBuilder json = new StringBuilder("[");
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            String sql =
                "SELECT DATE_FORMAT(created_at, '%b %Y') AS label, " +
                "       DATE_FORMAT(created_at, '%Y-%m') AS month_key, " +
                "       COUNT(*) AS user_count " +
                "FROM users " +
                "WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) " +
                "GROUP BY month_key, label " +
                "ORDER BY month_key";
            ResultSet rs = conn.prepareStatement(sql).executeQuery();
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                json.append("{\"label\":\"").append(rs.getString("label"))
                    .append("\",\"value\":").append(rs.getInt("user_count")).append("}");
                first = false;
            }
        } catch (SQLException e) {
            System.out.println("Error fetching monthly new users: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return json.append("]").toString();
    }

    @Override
    public int getTotalFeedback() {
        return querySingleInt("SELECT COUNT(*) AS total FROM feedback", "total",
                "Error fetching total feedback");
    }

    @Override
    public int getPendingFeedback() {
        return querySingleInt("SELECT COUNT(*) AS total FROM feedback WHERE status='Pending'", "total",
                "Error fetching pending feedback");
    }

    @Override
    public int getTotalReturnOrders() {
        return querySingleInt("SELECT COUNT(*) AS total FROM return_orders", "total",
                "Error fetching return orders");
    }

    @Override
    public double getAverageProductRating() {
        double avg = 0;
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            ResultSet rs = conn.prepareStatement(
                "SELECT COALESCE(AVG(rating), 0) AS avg_rating FROM products WHERE status='Active'"
            ).executeQuery();
            if (rs.next()) avg = Math.round(rs.getDouble("avg_rating") * 10.0) / 10.0;
        } catch (SQLException e) {
            System.out.println("Error fetching average rating: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return avg;
    }

    @Override
    public String getCategoryBreakdownJson() {
        StringBuilder json = new StringBuilder("[");
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            String sql =
                "SELECT c.name AS label, COUNT(p.id) AS value " +
                "FROM categories c " +
                "LEFT JOIN products p ON p.category_id = c.id AND p.status IN ('Active','New') " +
                "GROUP BY c.id, c.name " +
                "ORDER BY value DESC";
            ResultSet rs = conn.prepareStatement(sql).executeQuery();
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                String name = rs.getString("label").replace("\\", "\\\\").replace("\"", "\\\"");
                json.append("{\"label\":\"").append(name)
                    .append("\",\"value\":").append(rs.getInt("value")).append("}");
                first = false;
            }
        } catch (SQLException e) {
            System.out.println("Error fetching category breakdown: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return json.append("]").toString();
    }

    @Override
    public String getAvailabilityBreakdownJson() {
        StringBuilder json = new StringBuilder("[");
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            // Products per availability status alongside how many orders exist for each group
            String sql =
                "SELECT p.availability AS label, " +
                "       COUNT(DISTINCT p.id) AS product_count, " +
                "       COUNT(DISTINCT o.id) AS order_count " +
                "FROM products p " +
                "LEFT JOIN orders o ON o.product_id = p.id " +
                "WHERE p.status IN ('Active','New') " +
                "GROUP BY p.availability " +
                "ORDER BY FIELD(p.availability,'In Stock','Out of Stock','Coming Soon')";
            ResultSet rs = conn.prepareStatement(sql).executeQuery();
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                json.append("{\"label\":\"").append(rs.getString("label"))
                    .append("\",\"products\":").append(rs.getInt("product_count"))
                    .append(",\"orders\":").append(rs.getInt("order_count")).append("}");
                first = false;
            }
        } catch (SQLException e) {
            System.out.println("Error fetching availability breakdown: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return json.append("]").toString();
    }

    @Override
    public int getOrdersToday() {
        return querySingleInt(
            "SELECT COUNT(*) AS total FROM orders WHERE DATE(order_date) = CURDATE()",
            "total", "Error fetching orders today");
    }

    @Override
    public int getOrdersThisWeek() {
        return querySingleInt(
            "SELECT COUNT(*) AS total FROM orders " +
            "WHERE WEEK(order_date) = WEEK(CURDATE()) AND YEAR(order_date) = YEAR(CURDATE())",
            "total", "Error fetching orders this week");
    }

    @Override
    public int getNewUsersThisWeek() {
        return querySingleInt(
            "SELECT COUNT(*) AS total FROM users " +
            "WHERE WEEK(created_at) = WEEK(CURDATE()) AND YEAR(created_at) = YEAR(CURDATE())",
            "total", "Error fetching new users this week");
    }

    @Override
    public String getDailyOrdersJson() {
        StringBuilder json = new StringBuilder("[");
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            String sql =
                "SELECT DATE(order_date) AS day, COUNT(*) AS cnt " +
                "FROM orders " +
                "WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 6 DAY) " +
                "GROUP BY day " +
                "ORDER BY day";
            ResultSet rs = conn.prepareStatement(sql).executeQuery();
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                json.append("{\"label\":\"").append(rs.getString("day"))
                    .append("\",\"value\":").append(rs.getInt("cnt")).append("}");
                first = false;
            }
        } catch (SQLException e) {
            System.out.println("Error fetching daily orders: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return json.append("]").toString();
    }

    private int querySingleInt(String sql, String column, String errorMsg) {
        int result = 0;
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            ResultSet rs = conn.prepareStatement(sql).executeQuery();
            if (rs.next()) result = rs.getInt(column);
        } catch (SQLException e) {
            System.out.println(errorMsg + ": " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return result;
    }
}
