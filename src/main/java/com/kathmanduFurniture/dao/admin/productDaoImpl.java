package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.entity.user.Product;
import com.kathmanduFurniture.utils.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * JDBC implementation of {@link ProductDao}.
 * Uses transactions for add/update to keep products and product_colors in sync.
 */
public class ProductDaoImpl implements ProductDao {

    private static final String SELECT_COLS =
        "SELECT p.id, p.product_name, p.image, p.price, p.availability, " +
        "       p.description, p.specifications, p.status, c.name AS category, p.rating, " +
        "       p.seating_capacity, p.design_style, p.warranty_details, " +
        "       p.return_policy, p.installation_service, " +
        "       p.material, p.frame_material, p.dimensions, " +
        "       p.weight_kg, p.max_weight_capacity, p.assembly_required, p.care_instructions, " +
        "       GROUP_CONCAT(pc.color_hex ORDER BY pc.id SEPARATOR ',') AS colors " +
        "FROM products p " +
        "LEFT JOIN categories c      ON p.category_id = c.id " +
        "LEFT JOIN product_colors pc ON p.id = pc.product_id ";

    private static final String GROUP_BY =
        " GROUP BY p.id, p.product_name, p.image, p.price, p.availability, " +
        "          p.description, p.specifications, p.status, c.name, p.rating, " +
        "          p.seating_capacity, p.design_style, p.warranty_details, " +
        "          p.return_policy, p.installation_service, " +
        "          p.material, p.frame_material, p.dimensions, " +
        "          p.weight_kg, p.max_weight_capacity, p.assembly_required, p.care_instructions";

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
                "description, specifications, status, category_id, rating, " +
                "seating_capacity, design_style, warranty_details, return_policy, installation_service, " +
                "material, frame_material, dimensions, weight_kg, max_weight_capacity, assembly_required, care_instructions) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(prodSql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, product.getProductName());
            ps.setString(2, product.getImage());
            ps.setDouble(3, product.getPrice());
            ps.setString(4, product.getAvailability());
            ps.setString(5, product.getDescription());
            ps.setString(6, product.getSpecifications());
            ps.setString(7, product.getStatus());
            ps.setInt(8, categoryId);
            ps.setDouble(9, product.getRating());
            if (product.getSeatingCapacity() != null) ps.setInt(10, product.getSeatingCapacity()); else ps.setNull(10, java.sql.Types.INTEGER);
            ps.setString(11, product.getDesignStyle());
            ps.setString(12, product.getWarrantyDetails());
            ps.setString(13, product.getReturnPolicy());
            ps.setString(14, product.getInstallationService() != null ? product.getInstallationService() : "No");
            ps.setString(15, product.getMaterial());
            ps.setString(16, product.getFrameMaterial());
            ps.setString(17, product.getDimensions());
            if (product.getWeightKg() != null) ps.setDouble(18, product.getWeightKg()); else ps.setNull(18, java.sql.Types.DECIMAL);
            if (product.getMaxWeightCapacity() != null) ps.setInt(19, product.getMaxWeightCapacity()); else ps.setNull(19, java.sql.Types.INTEGER);
            ps.setString(20, product.getAssemblyRequired() != null ? product.getAssemblyRequired() : "No");
            ps.setString(21, product.getCareInstructions());
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
                "description=?, specifications=?, status=?, category_id=?, rating=?, " +
                "seating_capacity=?, design_style=?, warranty_details=?, " +
                "return_policy=?, installation_service=?, " +
                "material=?, frame_material=?, dimensions=?, weight_kg=?, " +
                "max_weight_capacity=?, assembly_required=?, care_instructions=? WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(prodSql);
            ps.setString(1, product.getProductName());
            ps.setString(2, product.getImage());
            ps.setDouble(3, product.getPrice());
            ps.setString(4, product.getAvailability());
            ps.setString(5, product.getDescription());
            ps.setString(6, product.getSpecifications());
            ps.setString(7, product.getStatus());
            ps.setInt(8, categoryId);
            ps.setDouble(9, product.getRating());
            if (product.getSeatingCapacity() != null) ps.setInt(10, product.getSeatingCapacity()); else ps.setNull(10, java.sql.Types.INTEGER);
            ps.setString(11, product.getDesignStyle());
            ps.setString(12, product.getWarrantyDetails());
            ps.setString(13, product.getReturnPolicy());
            ps.setString(14, product.getInstallationService() != null ? product.getInstallationService() : "No");
            ps.setString(15, product.getMaterial());
            ps.setString(16, product.getFrameMaterial());
            ps.setString(17, product.getDimensions());
            if (product.getWeightKg() != null) ps.setDouble(18, product.getWeightKg()); else ps.setNull(18, java.sql.Types.DECIMAL);
            if (product.getMaxWeightCapacity() != null) ps.setInt(19, product.getMaxWeightCapacity()); else ps.setNull(19, java.sql.Types.INTEGER);
            ps.setString(20, product.getAssemblyRequired() != null ? product.getAssemblyRequired() : "No");
            ps.setString(21, product.getCareInstructions());
            ps.setInt(22, product.getId());
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
        p.setDescription(rs.getString("description"));
        p.setSpecifications(rs.getString("specifications"));
        p.setStatus(rs.getString("status"));
        p.setCategory(rs.getString("category"));
        p.setColors(rs.getString("colors"));
        p.setRating(rs.getDouble("rating"));
        int sc = rs.getInt("seating_capacity");
        p.setSeatingCapacity(rs.wasNull() ? null : sc);
        p.setDesignStyle(rs.getString("design_style"));
        p.setWarrantyDetails(rs.getString("warranty_details"));
        p.setReturnPolicy(rs.getString("return_policy"));
        p.setInstallationService(rs.getString("installation_service"));
        p.setMaterial(rs.getString("material"));
        p.setFrameMaterial(rs.getString("frame_material"));
        p.setDimensions(rs.getString("dimensions"));
        double wkg = rs.getDouble("weight_kg");
        p.setWeightKg(rs.wasNull() ? null : wkg);
        int mwc = rs.getInt("max_weight_capacity");
        p.setMaxWeightCapacity(rs.wasNull() ? null : mwc);
        p.setAssemblyRequired(rs.getString("assembly_required"));
        p.setCareInstructions(rs.getString("care_instructions"));
        return p;
    }
}
