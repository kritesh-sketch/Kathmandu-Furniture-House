package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.entity.user.Feedback;
import com.kathmanduFurniture.utils.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class feedbackDaoImpl implements feedbackDao {

    @Override
    public boolean saveFeedback(Feedback f) {
        String sql = "INSERT INTO feedback (user_name, mail, field, cv, status) VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, f.getUserName());
            ps.setString(2, f.getEmail());
            ps.setString(3, f.getSubject());
            ps.setString(4, f.getMessage());
            ps.setString(5, f.getStatus() != null ? f.getStatus() : "New");
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.out.println("Error saving feedback: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return false;
    }

    @Override
    public List<Feedback> getAllFeedbacks() {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT id, user_name, mail, field, cv, status, created_at " +
                     "FROM feedback ORDER BY id DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement st   = conn.createStatement();
             ResultSet rs   = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving feedbacks: " + e.getMessage());
        }
        return list;
    }

    @Override
    public Feedback getFeedbackById(int id) {
        String sql = "SELECT id, user_name, mail, field, cv, status, created_at " +
                     "FROM feedback WHERE id = ?";
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving feedback: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return null;
    }

    @Override
    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE feedback SET status = ? WHERE id = ?";
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.out.println("Error updating feedback status: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return false;
    }

    private Feedback mapRow(ResultSet rs) throws SQLException {
        Feedback f = new Feedback();
        f.setId(rs.getInt("id"));
        f.setUserName(rs.getString("user_name"));
        f.setEmail(rs.getString("mail"));
        f.setSubject(rs.getString("field"));
        f.setMessage(rs.getString("cv"));
        f.setStatus(rs.getString("status"));
        f.setCreatedAt(rs.getTimestamp("created_at"));
        return f;
    }
}
