package com.kathmanduFurniture.dao.user;

import com.kathmanduFurniture.entity.user.Product;
import com.kathmanduFurniture.utils.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class HomeDaoImpl implements HomeDao {

    @Override
    public List<Product> getSpotlightProducts() {
        List<Product> products = new ArrayList<>();
        String sql =
            "SELECT p.id, p.product_name, p.image, p.price, p.availability, " +
            "       p.specifications, p.status, c.name AS category, p.rating, " +
            "       GROUP_CONCAT(pc.color_hex ORDER BY pc.id SEPARATOR ',') AS colors " +
            "FROM products p " +
            "LEFT JOIN categories c     ON p.category_id = c.id " +
            "LEFT JOIN product_colors pc ON p.id = pc.product_id " +
            "WHERE p.status = 'Active' " +
            "GROUP BY p.id, p.product_name, p.image, p.price, p.availability, " +
            "         p.specifications, p.status, c.name, p.rating " +
            "LIMIT 16";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setProductName(rs.getString("product_name"));
                product.setImage(rs.getString("image"));
                product.setPrice(rs.getDouble("price"));
                product.setAvailability(rs.getString("availability"));
                product.setSpecifications(rs.getString("specifications"));
                product.setStatus(rs.getString("status"));
                product.setCategory(rs.getString("category"));
                product.setColors(rs.getString("colors"));
                product.setRating(rs.getDouble("rating"));
                products.add(product);
            }
        } catch (SQLException e) {
            System.out.println("Error in displaying all spotlight" + e.getMessage());
        }
        return products;
    }
}
