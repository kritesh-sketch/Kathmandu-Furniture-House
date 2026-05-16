package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.entity.user.Return;
import com.kathmanduFurniture.utils.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class returnProductDaoImpl implements returnProductDao {

    @Override
    public boolean insertReturn(Return r) {
        String sql = "INSERT INTO return_orders " +
                     "(order_id, customer_name, phone_number, product, reason, status, return_date, refund_amount) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1,    r.getOrderId());
            ps.setString(2, r.getCustomer());
            ps.setString(3, r.getPhoneNumber());
            ps.setString(4, r.getProduct());
            ps.setString(5, r.getReason());
            ps.setString(6, r.getStatus() != null ? r.getStatus() : "Pending");
            ps.setString(7, r.getReturnDate());
            ps.setDouble(8, r.getRefundAmount());
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.out.println("Error inserting return: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return false;
    }

    @Override
    public List<Return> getAllReturns() {
        List<Return> list = new ArrayList<>();
        String sql = "SELECT id, order_id, customer_name, phone_number, product, reason, " +
                     "status, return_date, refund_amount " +
                     "FROM return_orders ORDER BY id DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement st   = conn.createStatement();
             ResultSet rs   = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving returns: " + e.getMessage());
        }
        return list;
    }

    @Override
    public Return getReturnById(int id) {
        String sql = "SELECT id, order_id, customer_name, phone_number, product, reason, " +
                     "status, return_date, refund_amount " +
                     "FROM return_orders WHERE id = ?";
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
            System.out.println("Error retrieving return: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return null;
    }

    @Override
    public boolean updateReturnStatus(int id, String status) {
        String sql = "UPDATE return_orders SET status = ? WHERE id = ?";
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.out.println("Error updating return status: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return false;
    }

    private Return mapRow(ResultSet rs) throws SQLException {
        Return r = new Return();
        r.setReturnId(rs.getInt("id"));
        r.setOrderId(rs.getInt("order_id"));
        r.setCustomerName(rs.getString("customer_name"));
        r.setPhoneNumber(rs.getString("phone_number"));
        r.setProduct(rs.getString("product"));
        r.setReason(rs.getString("reason"));
        r.setStatus(rs.getString("status"));
        r.setReturnDate(rs.getString("return_date"));
        r.setRefundAmount(rs.getDouble("refund_amount"));
        return r;
    }
}
