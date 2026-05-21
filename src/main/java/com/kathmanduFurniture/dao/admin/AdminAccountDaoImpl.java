package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.entity.user.User;
import com.kathmanduFurniture.utils.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * JDBC implementation of {@link AdminAccountDao}.
 * Reads and writes to the shared users table — the admin record is
 * identified by its email matching the hard-coded admin address.
 */
public class AdminAccountDaoImpl implements AdminAccountDao {

    @Override
    public User findById(int id) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT * FROM users WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setFirstName(rs.getString("firstName"));
                u.setLastName(rs.getString("lastName"));
                u.setEmail(rs.getString("email"));
                u.setMobileNumber(rs.getString("phoneNumber"));
                u.setGender(rs.getString("gender"));
                u.setDob(rs.getString("dob"));
                u.setStatus(rs.getString("status"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                u.setImage(rs.getString("image"));
                return u;
            }
        } catch (SQLException e) {
            System.out.println("AdminAccountDao.findById error: " + e.getMessage());
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
            String sql = "UPDATE users SET firstName=?, lastName=?, email=?, phoneNumber=?, dob=?, gender=?, updated_at=NOW() WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, firstName);
            ps.setString(2, lastName);
            ps.setString(3, email);
            ps.setString(4, mobileNumber);
            ps.setString(5, dob);
            ps.setString(6, gender);
            ps.setInt(7, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("AdminAccountDao.updateProfile error: " + e.getMessage());
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
            String sql = "UPDATE users SET password=?, updated_at=NOW() WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, hashedPassword);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("AdminAccountDao.updatePassword error: " + e.getMessage());
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
            String sql = "UPDATE users SET image=?, updated_at=NOW() WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, imagePath);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("AdminAccountDao.updateImage error: " + e.getMessage());
            return false;
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
    }
}
