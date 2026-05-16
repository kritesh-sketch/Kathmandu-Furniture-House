package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.entity.user.Discount;
import com.kathmanduFurniture.utils.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class discountDaoImpl implements discountDao {

    @Override
    public boolean createOffer(Discount o) {
        String sql = "INSERT INTO offers " +
                     "(title, event_name, discount_code, discount_type, discount_percent, " +
                     "discount_amount, description, status, start_date, end_date) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, o.getTitle());
            ps.setString(2, o.getEventName());
            ps.setString(3, o.getDiscountCode());
            ps.setString(4, o.getDiscountType());
            ps.setDouble(5, o.getDiscountPercent());
            ps.setDouble(6, o.getDiscountAmount());
            ps.setString(7, o.getDescription());
            ps.setString(8, o.getStatus() != null ? o.getStatus() : "Active");
            ps.setDate(9,  o.getStartDate() != null ? new java.sql.Date(o.getStartDate().getTime()) : null);
            ps.setDate(10, o.getEndDate()   != null ? new java.sql.Date(o.getEndDate().getTime())   : null);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.out.println("Error creating offer: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return false;
    }

    @Override
    public boolean updateOffer(Discount o) {
        String sql = "UPDATE offers SET title=?, event_name=?, discount_code=?, discount_type=?, " +
                     "discount_percent=?, discount_amount=?, description=?, status=?, " +
                     "start_date=?, end_date=? WHERE id=?";
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, o.getTitle());
            ps.setString(2, o.getEventName());
            ps.setString(3, o.getDiscountCode());
            ps.setString(4, o.getDiscountType());
            ps.setDouble(5, o.getDiscountPercent());
            ps.setDouble(6, o.getDiscountAmount());
            ps.setString(7, o.getDescription());
            ps.setString(8, o.getStatus());
            ps.setDate(9,  o.getStartDate() != null ? new java.sql.Date(o.getStartDate().getTime()) : null);
            ps.setDate(10, o.getEndDate()   != null ? new java.sql.Date(o.getEndDate().getTime())   : null);
            ps.setInt(11, o.getId());
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.out.println("Error updating offer: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return false;
    }

    @Override
    public boolean deleteOffer(int id) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement("DELETE FROM offers WHERE id=?");
            ps.setInt(1, id);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.out.println("Error deleting offer: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return false;
    }

    @Override
    public boolean updateStatus(int id, String status) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement("UPDATE offers SET status=? WHERE id=?");
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.out.println("Error updating offer status: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return false;
    }

    @Override
    public List<Discount> getAllOffers() {
        List<Discount> list = new ArrayList<>();
        String sql = "SELECT id, title, event_name, discount_code, discount_type, " +
                     "discount_percent, discount_amount, description, status, start_date, end_date " +
                     "FROM offers ORDER BY id DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement st   = conn.createStatement();
             ResultSet rs   = st.executeQuery(sql)) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.out.println("Error retrieving offers: " + e.getMessage());
        }
        return list;
    }

    @Override
    public Discount getOfferById(int id) {
        String sql = "SELECT id, title, event_name, discount_code, discount_type, " +
                     "discount_percent, discount_amount, description, status, start_date, end_date " +
                     "FROM offers WHERE id=?";
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            System.out.println("Error retrieving offer: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return null;
    }

    private Discount mapRow(ResultSet rs) throws SQLException {
        Discount o = new Discount();
        o.setId(rs.getInt("id"));
        o.setTitle(rs.getString("title"));
        o.setEventName(rs.getString("event_name"));
        o.setDiscountCode(rs.getString("discount_code"));
        o.setDiscountType(rs.getString("discount_type"));
        o.setDiscountPercent(rs.getDouble("discount_percent"));
        o.setDiscountAmount(rs.getDouble("discount_amount"));
        o.setDescription(rs.getString("description"));
        o.setStatus(rs.getString("status"));
        o.setStartDate(rs.getDate("start_date"));
        o.setEndDate(rs.getDate("end_date"));
        return o;
    }
}
