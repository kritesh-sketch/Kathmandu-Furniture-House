package com.kathmanduFurniture.dao.user;

import com.kathmanduFurniture.entity.user.Product;
import com.kathmanduFurniture.utils.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * JDBC implementation of {@link FavoriteDao}.
 * Manages the wishlist table with INSERT IGNORE for safe add operations.
 */
public class FavoriteDaoImpl implements FavoriteDao {

    private static final String SELECT_WISHLIST =
        "SELECT p.id, p.product_name, p.image, p.price, p.availability, " +
        "       p.specifications, p.status, c.name AS category, p.rating, p.created_at, " +
        "       GROUP_CONCAT(pc.color_hex ORDER BY pc.id SEPARATOR ',') AS colors " +
        "FROM wishlist w " +
        "JOIN products p ON w.product_id = p.id " +
        "LEFT JOIN categories c ON p.category_id = c.id " +
        "LEFT JOIN product_colors pc ON p.id = pc.product_id " +
        "WHERE w.user_id = ? " +
        "GROUP BY p.id, p.product_name, p.image, p.price, p.availability, " +
        "         p.specifications, p.status, c.name, p.rating, p.created_at, w.added_at " +
        "ORDER BY w.added_at DESC";

    @Override
    public boolean addToWishlist(int userId, int productId) {
        String sql = "INSERT IGNORE INTO wishlist (user_id, product_id) VALUES (?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean removeFromWishlist(int userId, int productId) {
        String sql = "DELETE FROM wishlist WHERE user_id = ? AND product_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean toggleWishlist(int userId, int productId) {
        if (isInWishlist(userId, productId)) {
            return removeFromWishlist(userId, productId);
        } else {
            return addToWishlist(userId, productId);
        }
    }

    @Override
    public List<Product> getWishlistProducts(int userId) {
        List<Product> products = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_WISHLIST)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setId(rs.getInt("id"));
                    p.setProductName(rs.getString("product_name"));
                    p.setImage(rs.getString("image"));
                    p.setPrice(rs.getDouble("price"));
                    p.setAvailability(rs.getString("availability"));
                    p.setSpecifications(rs.getString("specifications"));
                    p.setStatus(rs.getString("status"));
                    p.setCategory(rs.getString("category"));
                    p.setRating(rs.getDouble("rating"));
                    p.setColors(rs.getString("colors"));
                    products.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    @Override
    public boolean isInWishlist(int userId, int productId) {
        String sql = "SELECT 1 FROM wishlist WHERE user_id = ? AND product_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
