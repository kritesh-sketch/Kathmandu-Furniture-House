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
        "       p.description, p.specifications, p.status, c.name AS category, p.rating, p.created_at, " +
        "       GROUP_CONCAT(pc.color_hex ORDER BY pc.id SEPARATOR ',') AS colors " +
        "FROM products p " +
        "LEFT JOIN categories c  ON p.category_id = c.id " +
        "LEFT JOIN product_colors pc ON p.id = pc.product_id ";

    private static final String GROUP_BY =
        " GROUP BY p.id, p.product_name, p.image, p.price, p.availability, " +
        "          p.description, p.specifications, p.status, c.name, p.rating, p.created_at";

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

    @Override
    public List<Product> getFilteredProducts(String category, Double minPrice, Double maxPrice,
                                              String availability, String sort, String search) {
        List<Product> products = new ArrayList<>();
        StringBuilder sql = new StringBuilder(SELECT_COLS);
        List<Object> params = new ArrayList<>();

        sql.append("WHERE p.status = 'Active' ");
        if (category != null && !category.isEmpty()) {
            sql.append("AND c.name = ? ");
            params.add(category);
        }
        if (search != null && !search.isEmpty()) {
            sql.append("AND p.product_name LIKE ? ");
            params.add("%" + search + "%");
        }
        if (availability != null && !availability.isEmpty()) {
            sql.append("AND p.availability = ? ");
            params.add(availability);
        }
        if (minPrice != null) {
            sql.append("AND p.price >= ? ");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            sql.append("AND p.price <= ? ");
            params.add(maxPrice);
        }
        sql.append(GROUP_BY);
        if ("price-asc".equals(sort))   sql.append(" ORDER BY p.price ASC");
        else if ("price-desc".equals(sort)) sql.append(" ORDER BY p.price DESC");
        else if ("rating".equals(sort)) sql.append(" ORDER BY p.rating DESC");
        else                            sql.append(" ORDER BY p.id DESC");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object v = params.get(i);
                if (v instanceof String)  ps.setString(i + 1, (String) v);
                else if (v instanceof Double) ps.setDouble(i + 1, (Double) v);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) products.add(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return products;
    }

    @Override
    public List<String> getAllCategories() {
        List<String> cats = new ArrayList<>();
        String sql = "SELECT name FROM categories ORDER BY name";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) cats.add(rs.getString("name"));
        } catch (SQLException e) { e.printStackTrace(); }
        return cats;
    }

    @Override
    public double getMaxPrice() {
        String sql = "SELECT COALESCE(MAX(price), 100000) FROM products WHERE status = 'Active'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 100000;
    }

    private Product map(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setId(rs.getInt("id"));
        p.setProductName(rs.getString("product_name"));
        p.setImage(rs.getString("image"));
        p.setPrice(rs.getDouble("price"));
        p.setAvailability(rs.getString("availability"));
        p.setDescription(rs.getString("description"));
        p.setSpecifications(rs.getString("specifications"));
        p.setStatus(rs.getString("status"));
        p.setCategory(rs.getString("category"));
        p.setColors(rs.getString("colors"));
        p.setRating(rs.getDouble("rating"));
        return p;
    }
}
