package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.entity.user.User;
import com.kathmanduFurniture.utils.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * JDBC implementation of {@link VerifyUserDao}.
 * Updates user account status and deletes accounts on rejection.
 */
public class VerifyUserDaoImpl implements VerifyUserDao {

    @Override
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT id, firstName, lastName, email, phoneNumber, dob, gender, status, created_at " +
                         "FROM users WHERE (email IS NULL OR LOWER(email) != 'admin@kathmandufurniture.com') " +
                         "ORDER BY created_at DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setFirstName(rs.getString("firstName"));
                user.setLastName(rs.getString("lastName"));
                user.setFullName(rs.getString("firstName") + " " + rs.getString("lastName"));
                user.setEmail(rs.getString("email"));
                user.setMobileNumber(rs.getString("phoneNumber"));
                user.setDob(rs.getString("dob"));
                user.setGender(rs.getString("gender"));
                user.setStatus(rs.getString("status"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(user);
            }
        } catch (SQLException e) {
            System.out.println("Error fetching all users: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return list;
    }

    @Override
    public List<User> getPendingUsers() {
        List<User> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT id, firstName, lastName, email, phoneNumber, dob, gender, status, created_at " +
                         "FROM users WHERE status = 'Pending' ORDER BY created_at DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setFirstName(rs.getString("firstName"));
                user.setLastName(rs.getString("lastName"));
                user.setFullName(rs.getString("firstName") + " " + rs.getString("lastName"));
                user.setEmail(rs.getString("email"));
                user.setMobileNumber(rs.getString("phoneNumber"));
                user.setDob(rs.getString("dob"));
                user.setGender(rs.getString("gender"));
                user.setStatus(rs.getString("status"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(user);
            }
        } catch (SQLException e) {
            System.out.println("Error fetching pending users: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return list;
    }

    @Override
    public boolean approveUser(int userId) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE users SET status = 'Active' WHERE id = ?");
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error approving user: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return false;
    }

    @Override
    public boolean rejectUser(int userId) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "DELETE FROM users WHERE id = ?");
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error rejecting user: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return false;
    }

    @Override
    public boolean deactivateUser(int userId) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE users SET status = 'Inactive' WHERE id = ?");
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error deactivating user: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return false;
    }

    @Override
    public boolean activateUser(int userId) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE users SET status = 'Active' WHERE id = ?");
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error activating user: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return false;
    }

    @Override
    public int getTotalPending() {
        return countByStatus("Pending");
    }

    @Override
    public int getTotalApproved() {
        return countByStatus("Active");
    }

    private int countByStatus(String status) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT COUNT(*) FROM users WHERE status = ?");
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.out.println("Error counting users by status: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return 0;
    }
}
