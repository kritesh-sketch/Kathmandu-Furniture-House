package com.kathmanduFurniture.dao.user;

import com.kathmanduFurniture.entity.user.Order;
import com.kathmanduFurniture.entity.user.User;
import com.kathmanduFurniture.utils.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

/**
 * JDBC implementation of {@link UserDao}.
 * Each method opens its own connection and closes it in a finally block;
 * there is no connection pool — connections are per-request.
 */
public class UserDaoImpl implements UserDao {

    @Override
    public boolean insertUser(User user) {
        // Check uniqueness only for whichever field is provided
        if (user.getEmail() != null && !user.getEmail().isEmpty()
                && findByEmail(user.getEmail()) != null) {
            return false;
        }
        if (user.getMobileNumber() != null && !user.getMobileNumber().isEmpty()
                && findByPhoneNumber(user.getMobileNumber()) != null) {
            return false;
        }

        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "INSERT INTO users (firstName, lastName, email, phoneNumber, password, dob, gender, status) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, 'Pending')";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, user.getFirstName());
            ps.setString(2, user.getLastName());
            if (user.getEmail() != null && !user.getEmail().isEmpty())
                ps.setString(3, user.getEmail());
            else
                ps.setNull(3, Types.VARCHAR);
            if (user.getMobileNumber() != null && !user.getMobileNumber().isEmpty())
                ps.setString(4, user.getMobileNumber());
            else
                ps.setNull(4, Types.VARCHAR);
            ps.setString(5, user.getPassword());
            ps.setString(6, user.getDob() != null && !user.getDob().isEmpty() ? user.getDob() : null);
            ps.setString(7, user.getGender());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error inserting user: " + e.getMessage());
            return false;
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
    }

    @Override
    public User findByEmail(String email) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT * FROM users WHERE LOWER(email) = LOWER(?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setFirstName(rs.getString("firstName"));
                user.setLastName(rs.getString("lastName"));
                user.setEmail(rs.getString("email"));
                user.setMobileNumber(rs.getString("phoneNumber"));
                user.setPassword(rs.getString("password"));
                user.setDob(rs.getString("dob"));
                user.setGender(rs.getString("gender"));
                user.setStatus(rs.getString("status"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                return user;
            }
        } catch (SQLException e) {
            System.out.println("Error finding user by email: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return null;
    }

    @Override
    public User findById(int id) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE id = ?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setFirstName(rs.getString("firstName"));
                u.setLastName(rs.getString("lastName"));
                u.setEmail(rs.getString("email"));
                u.setMobileNumber(rs.getString("phoneNumber"));
                u.setPassword(rs.getString("password"));
                u.setGender(rs.getString("gender"));
                u.setDob(rs.getString("dob"));
                u.setStatus(rs.getString("status"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                u.setImage(rs.getString("image"));
                return u;
            }
        } catch (SQLException e) {
            System.out.println("Error finding user by id: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return null;
    }

    @Override
    public boolean updateProfile(int id, String firstName, String lastName,
                                 String email, String mobileNumber, String dob, String gender) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE users SET firstName=?, lastName=?, email=?, phoneNumber=?, dob=?, gender=?, updated_at=NOW() WHERE id=?");
            ps.setString(1, firstName);
            ps.setString(2, lastName);
            ps.setString(3, email);
            ps.setString(4, mobileNumber);
            ps.setString(5, dob);
            ps.setString(6, gender);
            ps.setInt(7, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating user profile: " + e.getMessage());
            return false;
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
    }

    @Override
    public boolean updatePassword(int id, String hashedPassword) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE users SET password=?, updated_at=NOW() WHERE id=?");
            ps.setString(1, hashedPassword);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating user password: " + e.getMessage());
            return false;
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
    }

    @Override
    public boolean updateImage(int id, String imagePath) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE users SET image=?, updated_at=NOW() WHERE id=?");
            ps.setString(1, imagePath);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating user image: " + e.getMessage());
            return false;
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
    }

    @Override
    public List<Order> getOrdersByCustomerId(int customerId) {
        List<Order> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            String sql =
                "SELECT o.id, o.order_date, o.total_amount, o.status, o.quantity, " +
                "       o.order_type, o.delivery_location, o.payment_method, " +
                "       o.furniture_type, p.product_name " +
                "FROM orders o " +
                "LEFT JOIN products p ON o.product_id = p.id " +
                "WHERE o.customer_id = ? " +
                "ORDER BY o.order_date DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("id"));
                o.setOrderDate(rs.getTimestamp("order_date"));
                o.setTotalAmount(rs.getDouble("total_amount"));
                o.setStatus(rs.getString("status"));
                o.setQuantity(rs.getInt("quantity"));
                o.setOrderType(rs.getString("order_type"));
                o.setDeliveryLocation(rs.getString("delivery_location"));
                o.setPaymentMethod(rs.getString("payment_method"));
                o.setFurnitureType(rs.getString("furniture_type"));
                o.setProductName(rs.getString("product_name"));
                list.add(o);
            }
        } catch (SQLException e) {
            System.out.println("Error fetching orders by customer: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return list;
    }

    @Override
    public User findByPhoneNumber(String mobileNumber) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT * FROM users WHERE phoneNumber = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, mobileNumber);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setFirstName(rs.getString("firstName"));
                user.setLastName(rs.getString("lastName"));
                user.setEmail(rs.getString("email"));
                user.setMobileNumber(rs.getString("phoneNumber"));
                user.setPassword(rs.getString("password"));
                user.setStatus(rs.getString("status"));
                return user;
            }
        } catch (SQLException e) {
            System.out.println("Error finding user by phone: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return null;
    }
}
