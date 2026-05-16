package com.kathmanduFurniture.dao.user;

import com.kathmanduFurniture.entity.user.Product;
import com.kathmanduFurniture.utils.DatabaseConnection;
//import com.kathmanduFurniture.utils.DatabaseConnection;

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
        String sql = "SELECT * FROM product LIMIT 16"; // Spotlight usually shows a limited set
        
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
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }
}
