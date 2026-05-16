package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.entity.user.Product;
import com.kathmanduFurniture.utils.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class productDaoImpl implements productDao {

    private static final String SELECT_COLS =
        "SELECT p.id, p.product_name, p.image, p.price, p.availability, " +
        "       p.specifications, p.status, c.name AS category, p.rating, " +
        "       GROUP_CONCAT(pc.color_hex ORDER BY pc.id SEPARATOR ',') AS colors " +
        "FROM products p " +
        "LEFT JOIN categories c     ON p.category_id = c.id " +
        "LEFT JOIN product_colors pc ON p.id = pc.product_id ";

    private static final String GROUP_BY =
        " GROUP BY p.id, p.product_name, p.image, p.price, p.availability, " +
        "          p.specifications, p.status, c.name, p.rating";

    @Override
    public List<Product> fetchAllProducts() {
        List<Product> list = new ArrayList<>();
        String sql = SELECT_COLS + GROUP_BY + " ORDER BY p.id DESC";
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            ResultSet rs = conn.prepareStatement(sql).executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.out.println("Error fetching all products: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return list;
    }

    @Override
    public Product fetchProductById(int id) {
        String sql = SELECT_COLS + "WHERE p.id = ?" + GROUP_BY;
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            System.out.println("Error fetching product by id: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return null;
    }

    @Override
    public boolean addProduct(Product product) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            int categoryId = getCategoryId(conn, product.getCategory());

            String prodSql =
                "INSERT INTO products (product_name, image, price, availability, " +
                "specifications, status, category_id, rating) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(prodSql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, product.getProductName());
            ps.setString(2, product.getImage());
            ps.setDouble(3, product.getPrice());
            ps.setString(4, product.getAvailability());
            ps.setString(5, product.getSpecifications());
            ps.setString(6, product.getStatus());
            ps.setInt(7, categoryId);
            ps.setDouble(8, product.getRating());
            ps.executeUpdate();

            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) {
                insertColors(conn, keys.getInt(1), product.getColors());
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            System.out.println("Error adding product: " + e.getMessage());
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); } catch (SQLException ex) { ex.printStackTrace(); }
            DatabaseConnection.closeConnection(conn);
        }
        return false;
    }

    @Override
    public boolean updateProduct(Product product) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            int categoryId = getCategoryId(conn, product.getCategory());

            String prodSql =
                "UPDATE products SET product_name=?, image=?, price=?, availability=?, " +
                "specifications=?, status=?, category_id=?, rating=? WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(prodSql);
            ps.setString(1, product.getProductName());
            ps.setString(2, product.getImage());
            ps.setDouble(3, product.getPrice());
            ps.setString(4, product.getAvailability());
            ps.setString(5, product.getSpecifications());
            ps.setString(6, product.getStatus());
            ps.setInt(7, categoryId);
            ps.setDouble(8, product.getRating());
            ps.setInt(9, product.getId());
            ps.executeUpdate();

            // Replace colors: delete old, insert new
            PreparedStatement del = conn.prepareStatement("DELETE FROM product_colors WHERE product_id = ?");
            del.setInt(1, product.getId());
            del.executeUpdate();
            insertColors(conn, product.getId(), product.getColors());

            conn.commit();
            return true;
        } catch (SQLException e) {
            System.out.println("Error updating product: " + e.getMessage());
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); } catch (SQLException ex) { ex.printStackTrace(); }
            DatabaseConnection.closeConnection(conn);
        }
        return false;
    }

    @Override
    public boolean deleteProduct(int id) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            // product_colors deleted automatically via ON DELETE CASCADE
            PreparedStatement ps = conn.prepareStatement("DELETE FROM products WHERE id = ?");
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting product: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return false;
    }

    // ── helpers ──────────────────────────────────────────────────────────────

    private int getCategoryId(Connection conn, String categoryName) throws SQLException {
        PreparedStatement ps = conn.prepareStatement("SELECT id FROM categories WHERE name = ?");
        ps.setString(1, categoryName);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) return rs.getInt("id");
        throw new SQLException("Category not found: " + categoryName);
    }

    private void insertColors(Connection conn, int productId, String colors) throws SQLException {
        if (colors == null || colors.trim().isEmpty()) return;
        PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO product_colors (product_id, color_hex) VALUES (?, ?)");
        for (String hex : colors.split(",")) {
            String trimmed = hex.trim();
            if (!trimmed.isEmpty()) {
                ps.setInt(1, productId);
                ps.setString(2, trimmed);
                ps.addBatch();
            }
        }
        ps.executeBatch();
    }

    private Product mapRow(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setId(rs.getInt("id"));
        p.setProductName(rs.getString("product_name"));
        p.setImage(rs.getString("image"));
        p.setPrice(rs.getDouble("price"));
        p.setAvailability(rs.getString("availability"));
        p.setSpecifications(rs.getString("specifications"));
        p.setStatus(rs.getString("status"));
        p.setCategory(rs.getString("category"));
        p.setColors(rs.getString("colors"));
        p.setRating(rs.getDouble("rating"));
        return p;
    }
}
