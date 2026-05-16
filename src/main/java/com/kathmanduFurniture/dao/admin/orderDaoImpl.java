package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.entity.user.Order;
import com.kathmanduFurniture.utils.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;

public class orderDaoImpl implements orderDao {
    public boolean placeOrder(Order order) {
        String sql = "INSERT INTO orders " +
                "(furniture_type, quantity, design, material, size, budget_range, " +
                "delivery_location, deadline, installation_required, purpose, notes, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1,  order.getFurnitureType());
            ps.setInt(2,     order.getQuantity());
            ps.setString(3,  order.getDesign());
            ps.setString(4,  order.getMaterial());
            ps.setInt(5,     order.getSize());
            ps.setString(6,  order.getBudgetRange());
            ps.setString(7,  order.getDeliveryLocation());
            ps.setString(8,  order.getDeadline());
            ps.setString(9,  order.getInstallationRequired());
            ps.setString(10, order.getPurpose());
            ps.setString(11, order.getNotes());
            ps.setString(12, order.getStatus());
            ps.executeUpdate();
            return true;

        } catch (SQLException e) {
            System.out.println("Error placing order: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return false;
    }

    // SELECT BY ID
    @Override
    public Order getOrderById(int id) {
        String sql = "SELECT id, furniture_type, quantity, design, material, size, " +
                     "delivery_location, deadline, installation_required, purpose, " +
                     "recommendation, status, full_name, phone_number, " +
                     "order_type, payment_method, height, width " +
                     "FROM orders WHERE id = ?";
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
            System.out.println("Error retrieving order: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return null;
    }

    private Order mapRow(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setId(rs.getInt("id"));
        o.setFurnitureType(rs.getString("furniture_type"));
        o.setQuantity(rs.getInt("quantity"));
        o.setDesign(rs.getString("design"));
        o.setMaterial(rs.getString("material"));
        o.setSize(rs.getInt("size"));
        o.setDeliveryLocation(rs.getString("delivery_location"));
        o.setDeadline(rs.getString("deadline"));
        o.setInstallationRequired(rs.getString("installation_required"));
        o.setPurpose(rs.getString("purpose"));
        o.setRecommendation(rs.getString("recommendation"));
        o.setStatus(rs.getString("status"));
        o.setFullName(rs.getString("full_name"));
        o.setPhoneNumber(rs.getString("phone_number"));
        o.setOrderType(rs.getString("order_type"));
        o.setPaymentMethod(rs.getString("payment_method"));
        double h = rs.getDouble("height");
        if (!rs.wasNull()) o.setHeight(h);
        double w = rs.getDouble("width");
        if (!rs.wasNull()) o.setWidth(w);
        return o;
    }

    public ArrayList<Order> getAllOrders() {
        ArrayList<Order> orders = new ArrayList<>();
        String sql = "SELECT id, furniture_type, quantity, design, material, size, " +
                     "delivery_location, deadline, installation_required, purpose, " +
                     "recommendation, status, full_name, phone_number, " +
                     "order_type, payment_method, height, width " +
                     "FROM orders ORDER BY id DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement statement = conn.createStatement();
             ResultSet rs = statement.executeQuery(sql)) {

            while (rs.next()) {
                orders.add(mapRow(rs));
            }

        } catch (SQLException e) {
            System.out.println("Error retrieving orders: " + e.getMessage());
        }
        return orders;
    }

    // UPDATE
    public boolean updateOrder(Order order) {
        String sql = "UPDATE orders SET furniture_type=?, quantity=?, design=?, material=?, " +
                "size=?, budget_range=?, delivery_location=?, deadline=?, " +
                "installation_required=?, purpose=?, notes=?, status=? WHERE id=?";
        Connection conn = null;

        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setString(1, order.getFurnitureType());
            statement.setInt(2, order.getQuantity());
            statement.setString(3, order.getDesign());
            statement.setString(4, order.getMaterial());
            statement.setInt(5, order.getSize());
            statement.setString(6, order.getBudgetRange());
            statement.setString(7, order.getDeliveryLocation());
            statement.setString(8, order.getDeadline());
            statement.setString(9, order.getInstallationRequired());
            statement.setString(10, order.getPurpose());
            statement.setString(11, order.getNotes());
            statement.setString(12, order.getStatus());
            statement.setInt(13, order.getId());

            statement.executeUpdate();
            return true;

        } catch (SQLException e) {
            System.out.println("Error updating order: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return false;
    }

    public boolean deleteOrderById(int id) {
        Connection conn = null;
        try{
            String sql = "DELETE FROM orders WHERE id = ?";
            conn = DatabaseConnection.getConnection();
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setInt(1, id);
            statement.executeUpdate();
            return true;

        } catch (Exception e) {
            System.out.println("Error deleting order: " + e.getMessage());
        }
        return false;
    }

}
