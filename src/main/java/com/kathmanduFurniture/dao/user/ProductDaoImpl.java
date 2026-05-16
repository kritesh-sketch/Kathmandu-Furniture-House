package com.kathmanduFurniture.dao.user;

import com.kathmanduFurniture.entity.user.Product;
import com.kathmanduFurniture.utils.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductDaoImpl implements ProductDao {

    private static final String SELECT_COLS =
        "SELECT p.id, p.product_name, p.image, p.price, p.availability, " +
        "       p.specifications, p.status, c.name AS category, p.rating, p.created_at, " +
        "       GROUP_CONCAT(pc.color_hex ORDER BY pc.id SEPARATOR ',') AS colors " +
        "FROM products p " +
        "LEFT JOIN categories c  ON p.category_id = c.id " +
        "LEFT JOIN product_colors pc ON p.id = pc.product_id ";

    private static final String GROUP_BY =
        " GROUP BY p.id, p.product_name, p.image, p.price, p.availability, " +
        "          p.specifications, p.status, c.name, p.rating, p.created_at";

    @Override
    public List<Product> getAllActiveProducts() {
        List<Product> products = new ArrayList<>();
        String sql = SELECT_COLS + "WHERE p.status = 'Active'" + GROUP_BY + " ORDER BY p.id DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) products.add(map(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    @Override
    public List<Product> getProductsByCategory(String category) {
        List<Product> products = new ArrayList<>();
        String sql = SELECT_COLS + "WHERE p.status = 'Active' AND c.name = ?" + GROUP_BY + " ORDER BY p.id DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) products.add(map(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    @Override
    public Product getProductById(int id) {
        String sql = SELECT_COLS + "WHERE p.id = ?" + GROUP_BY;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Product map(ResultSet rs) throws SQLException {
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
