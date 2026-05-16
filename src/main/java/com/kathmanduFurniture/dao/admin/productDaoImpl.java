package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.entity.user.Product;
import com.kathmanduFurniture.utils.DatabaseConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class productDaoImpl implements productDao {

    @Override
    public List<Product> fetchAllProducts() {
        List<Product> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT id, product_name, image, price, " +
                         "availability, specifications, status, category, colors, rating " +
                         "FROM product ORDER BY id DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
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
                list.add(product);
            }
        } catch (SQLException e) {
            System.out.println("Error fetching all products: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return list;
    }

    @Override
    public Product fetchProductById(int id) {
        Product product = null;
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT id, product_name, image, price, " +
                         "availability, specifications, status, category, colors, rating " +
                         "FROM product WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                product = new Product();
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
            }
        } catch (SQLException e) {
            System.out.println("Error fetching product by id: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return product;
    }

    @Override
    public boolean addProduct(Product product) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "INSERT INTO product (product_name, image, price, availability, " +
                         "specifications, status, category, colors, rating) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, product.getProductName());
            ps.setString(2, product.getImage());
            ps.setDouble(3, product.getPrice());
            ps.setString(4, product.getAvailability());
            ps.setString(5, product.getSpecifications());
            ps.setString(6, product.getStatus());
            ps.setString(7, product.getCategory());
            ps.setString(8, product.getColors());
            ps.setDouble(9, product.getRating());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error adding product: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return false;
    }

    @Override
    public boolean updateProduct(Product product) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "UPDATE product SET product_name=?, image=?, price=?, " +
                         "availability=?, specifications=?, status=?, category=?, " +
                         "colors=?, rating=? WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, product.getProductName());
            ps.setString(2, product.getImage());
            ps.setDouble(3, product.getPrice());
            ps.setString(4, product.getAvailability());
            ps.setString(5, product.getSpecifications());
            ps.setString(6, product.getStatus());
            ps.setString(7, product.getCategory());
            ps.setString(8, product.getColors());
            ps.setDouble(9, product.getRating());
            ps.setInt(10, product.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating product: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return false;
    }

    @Override
    public boolean deleteProduct(int id) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement("DELETE FROM product WHERE id = ?");
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting product: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return false;
    }
}
