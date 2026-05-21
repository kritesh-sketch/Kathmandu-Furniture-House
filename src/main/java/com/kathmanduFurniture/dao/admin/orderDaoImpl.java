package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.entity.user.Order;
import com.kathmanduFurniture.utils.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;

/**
 * JDBC implementation of {@link OrderDao}.
 * Executes SQL against the orders table using prepared statements.
 */
public class OrderDaoImpl implements OrderDao {
    public boolean placeOrder(Order order) {
        String sql = "INSERT INTO orders " +
                "(full_name, phone_number, order_type, product_id, customer_id, " +
                " furniture_type, quantity, total_amount, design, material, size, budget_range, " +
                " delivery_location, deadline, installation_required, purpose, description, notes, " +
                " payment_method, height, width, reference_image, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1,  order.getFullName());
            ps.setString(2,  order.getPhoneNumber());
            ps.setString(3,  order.getOrderType() != null ? order.getOrderType() : "Normal");
            if (order.getProductId() > 0) ps.setInt(4, order.getProductId()); else ps.setNull(4, java.sql.Types.INTEGER);
            if (order.getCustomerId() > 0) ps.setInt(5, order.getCustomerId()); else ps.setNull(5, java.sql.Types.INTEGER);
            ps.setString(6,  order.getFurnitureType());
            ps.setInt(7,     order.getQuantity() > 0 ? order.getQuantity() : 1);
            if (order.getTotalAmount() != null) ps.setDouble(8, order.getTotalAmount()); else ps.setNull(8, java.sql.Types.DECIMAL);
            ps.setString(9,  order.getDesign());
            ps.setString(10, order.getMaterial());
            ps.setInt(11,    order.getSize());
            ps.setString(12, order.getBudgetRange());
            ps.setString(13, order.getDeliveryLocation());
            ps.setString(14, order.getDeadline());
            ps.setString(15, order.getInstallationRequired());
            ps.setString(16, order.getPurpose());
            ps.setString(17, order.getDescription());
            ps.setString(18, order.getNotes());
            ps.setString(19, order.getPaymentMethod());
            if (order.getHeight() != null) ps.setDouble(20, order.getHeight()); else ps.setNull(20, java.sql.Types.DECIMAL);
            if (order.getWidth()  != null) ps.setDouble(21, order.getWidth());  else ps.setNull(21, java.sql.Types.DECIMAL);
            ps.setString(22, order.getReferenceImage());
            ps.setString(23, "Pending");
            ps.executeUpdate();
            return true;

        } catch (SQLException e) {
            System.out.println("Error placing order: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return false;
    }

    private static final String SELECT_ALL =
        "SELECT o.id, o.customer_id, o.product_id, o.full_name, o.phone_number, " +
        "       o.order_type, o.quantity, o.total_amount, o.payment_method, " +
        "       o.delivery_location, o.furniture_type, o.design, o.material, " +
        "       o.size, o.height, o.width, o.budget_range, o.deadline, " +
        "       o.installation_required, o.purpose, o.description, o.notes, o.recommendation, " +
        "       o.status, o.order_date, " +
        "       p.product_name " +
        "FROM orders o " +
        "LEFT JOIN products p ON o.product_id = p.id ";

    // SELECT BY ID
    @Override
    public Order getOrderById(int id) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(SELECT_ALL + "WHERE o.id = ?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
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
        o.setCustomerId(rs.getInt("customer_id"));
        o.setProductId(rs.getInt("product_id"));
        o.setFullName(rs.getString("full_name"));
        o.setPhoneNumber(rs.getString("phone_number"));
        o.setOrderType(rs.getString("order_type"));
        o.setQuantity(rs.getInt("quantity"));
        double ta = rs.getDouble("total_amount");
        if (!rs.wasNull()) o.setTotalAmount(ta);
        o.setPaymentMethod(rs.getString("payment_method"));
        o.setDeliveryLocation(rs.getString("delivery_location"));
        o.setFurnitureType(rs.getString("furniture_type"));
        o.setDesign(rs.getString("design"));
        o.setMaterial(rs.getString("material"));
        o.setSize(rs.getInt("size"));
        double h = rs.getDouble("height");
        if (!rs.wasNull()) o.setHeight(h);
        double w = rs.getDouble("width");
        if (!rs.wasNull()) o.setWidth(w);
        o.setBudgetRange(rs.getString("budget_range"));
        o.setDeadline(rs.getString("deadline"));
        o.setInstallationRequired(rs.getString("installation_required"));
        o.setPurpose(rs.getString("purpose"));
        o.setDescription(rs.getString("description"));
        o.setNotes(rs.getString("notes"));
        o.setRecommendation(rs.getString("recommendation"));
        o.setStatus(rs.getString("status"));
        o.setOrderDate(rs.getTimestamp("order_date"));
        o.setProductName(rs.getString("product_name"));
        try { o.setReferenceImage(rs.getString("reference_image")); } catch (SQLException ignored) {}
        return o;
    }

    public ArrayList<Order> getAllOrders() {
        ArrayList<Order> orders = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ALL + "ORDER BY o.order_date DESC");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) orders.add(mapRow(rs));
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
