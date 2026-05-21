package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.entity.user.Allocation;
import com.kathmanduFurniture.entity.user.Product;
import com.kathmanduFurniture.entity.user.User;
import com.kathmanduFurniture.utils.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * JDBC implementation of {@link AllocationDao}.
 * Uses a shared SELECT_COLS constant with JOINs to products, categories,
 * and users so all queries return fully populated Allocation objects.
 */
public class AllocationDaoImpl implements AllocationDao {

    // Base SELECT with JOINs; append WHERE clause as needed
    private static final String SELECT_COLS =
        "SELECT a.id, a.product_id, p.product_name, p.image AS product_image, " +
        "       c.name AS category, a.allocated_to_user_id, " +
        "       CONCAT(u.firstName,' ',u.lastName) AS user_name, " +
        "       a.department, a.quantity, a.issue_date, " +
        "       a.expected_return_date, a.actual_return_date, " +
        "       a.status, a.notes, a.created_at " +
        "FROM allocations a " +
        "JOIN products p ON a.product_id = p.id " +
        "JOIN categories c ON p.category_id = c.id " +
        "LEFT JOIN users u ON a.allocated_to_user_id = u.id ";

    @Override
    public List<Allocation> getAllAllocations() {
        List<Allocation> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                SELECT_COLS + "ORDER BY a.created_at DESC");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) {
            System.out.println("Error fetching allocations: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return list;
    }

    @Override
    public Allocation getById(int id) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SELECT_COLS + "WHERE a.id = ?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        } catch (SQLException e) {
            System.out.println("Error fetching allocation by id: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return null;
    }

    @Override
    public boolean createAllocation(Allocation a) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO allocations (product_id, allocated_to_user_id, department, " +
                "quantity, issue_date, expected_return_date, status, notes) " +
                "VALUES (?, ?, ?, ?, ?, ?, 'Issued', ?)");
            ps.setInt(1, a.getProductId());
            if (a.getAllocatedToUserId() != null)
                ps.setInt(2, a.getAllocatedToUserId());
            else
                ps.setNull(2, Types.INTEGER);
            ps.setString(3, a.getDepartment());
            ps.setInt(4, a.getQuantity());
            ps.setDate(5, a.getIssueDate());
            ps.setDate(6, a.getExpectedReturnDate());
            ps.setString(7, a.getNotes());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error creating allocation: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return false;
    }

    @Override
    public boolean markReturned(int id, Date returnDate) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE allocations SET actual_return_date=?, status='Returned', " +
                "updated_at=NOW() WHERE id=?");
            ps.setDate(1, returnDate);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error marking allocation returned: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return false;
    }

    @Override
    public boolean deleteAllocation(int id) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement("DELETE FROM allocations WHERE id=?");
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting allocation: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return false;
    }

    @Override
    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT p.id, p.product_name, c.name AS category " +
                "FROM products p JOIN categories c ON p.category_id = c.id " +
                "WHERE p.status = 'Active' ORDER BY p.product_name");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setProductName(rs.getString("product_name"));
                p.setCategory(rs.getString("category"));
                list.add(p);
            }
        } catch (SQLException e) {
            System.out.println("Error fetching products: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return list;
    }

    @Override
    public List<User> getAllActiveUsers() {
        List<User> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT id, firstName, lastName, email, phoneNumber FROM users " +
                "WHERE status='Active' AND LOWER(email) != 'admin@kathmandufurniture.com' " +
                "ORDER BY firstName, lastName");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setFirstName(rs.getString("firstName"));
                u.setLastName(rs.getString("lastName"));
                u.setEmail(rs.getString("email"));
                u.setMobileNumber(rs.getString("phoneNumber"));
                list.add(u);
            }
        } catch (SQLException e) {
            System.out.println("Error fetching active users: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return list;
    }

    @Override
    public int countByStatus(String status) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT COUNT(*) FROM allocations WHERE status=?");
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.out.println("Error counting allocations: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return 0;
    }

    private Allocation map(ResultSet rs) throws SQLException {
        Allocation a = new Allocation();
        a.setId(rs.getInt("id"));
        a.setProductId(rs.getInt("product_id"));
        a.setProductName(rs.getString("product_name"));
        a.setProductImage(rs.getString("product_image"));
        a.setProductCategory(rs.getString("category"));
        // allocated_to_user_id is nullable — use wasNull() to avoid mapping 0 as a real user id
        int uid = rs.getInt("allocated_to_user_id");
        if (!rs.wasNull()) a.setAllocatedToUserId(uid);
        a.setAllocatedToUserName(rs.getString("user_name"));
        a.setDepartment(rs.getString("department"));
        a.setQuantity(rs.getInt("quantity"));
        a.setIssueDate(rs.getDate("issue_date"));
        a.setExpectedReturnDate(rs.getDate("expected_return_date"));
        a.setActualReturnDate(rs.getDate("actual_return_date"));
        a.setStatus(rs.getString("status"));
        a.setNotes(rs.getString("notes"));
        a.setCreatedAt(rs.getTimestamp("created_at"));
        return a;
    }
}
