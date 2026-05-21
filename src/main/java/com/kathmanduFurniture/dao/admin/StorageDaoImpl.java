package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.entity.user.Product;
import com.kathmanduFurniture.entity.user.StorageAssignment;
import com.kathmanduFurniture.entity.user.StorageLocation;
import com.kathmanduFurniture.utils.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StorageDaoImpl implements StorageDao {

    @Override
    public List<StorageLocation> getAllLocations() {
        List<StorageLocation> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT sl.*, COALESCE(SUM(sa.quantity),0) AS assigned_count " +
                "FROM storage_locations sl " +
                "LEFT JOIN storage_assignments sa ON sa.storage_location_id = sl.id " +
                "GROUP BY sl.id ORDER BY sl.zone, sl.rack_number");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapLocation(rs));
        } catch (SQLException e) {
            System.out.println("Error fetching storage locations: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return list;
    }

    @Override
    public StorageLocation getLocationById(int id) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT sl.*, COALESCE(SUM(sa.quantity),0) AS assigned_count " +
                "FROM storage_locations sl " +
                "LEFT JOIN storage_assignments sa ON sa.storage_location_id = sl.id " +
                "WHERE sl.id = ? GROUP BY sl.id");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapLocation(rs);
        } catch (SQLException e) {
            System.out.println("Error fetching location by id: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return null;
    }

    @Override
    public boolean createLocation(StorageLocation loc) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO storage_locations (zone, rack_number, description, capacity, status) " +
                "VALUES (?, ?, ?, ?, ?)");
            ps.setString(1, loc.getZone());
            ps.setString(2, loc.getRackNumber());
            ps.setString(3, loc.getDescription());
            ps.setInt(4, loc.getCapacity());
            ps.setString(5, loc.getStatus() != null ? loc.getStatus() : "Available");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error creating storage location: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return false;
    }

    @Override
    public boolean updateLocation(StorageLocation loc) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE storage_locations SET zone=?, rack_number=?, description=?, " +
                "capacity=?, status=?, updated_at=NOW() WHERE id=?");
            ps.setString(1, loc.getZone());
            ps.setString(2, loc.getRackNumber());
            ps.setString(3, loc.getDescription());
            ps.setInt(4, loc.getCapacity());
            ps.setString(5, loc.getStatus());
            ps.setInt(6, loc.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating storage location: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return false;
    }

    @Override
    public boolean deleteLocation(int id) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "DELETE FROM storage_locations WHERE id=?");
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting storage location: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return false;
    }

    @Override
    public List<StorageAssignment> getAllAssignments() {
        List<StorageAssignment> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT sa.id, sa.product_id, p.product_name, p.image AS product_image, " +
                "c.name AS category, sa.storage_location_id, sl.zone, sl.rack_number, " +
                "sa.quantity, sa.assigned_date, sa.notes, sa.created_at " +
                "FROM storage_assignments sa " +
                "JOIN products p ON sa.product_id = p.id " +
                "JOIN categories c ON p.category_id = c.id " +
                "JOIN storage_locations sl ON sa.storage_location_id = sl.id " +
                "ORDER BY sa.created_at DESC");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapAssignment(rs));
        } catch (SQLException e) {
            System.out.println("Error fetching assignments: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return list;
    }

    @Override
    public List<StorageAssignment> getAssignmentsByLocation(int locationId) {
        List<StorageAssignment> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT sa.id, sa.product_id, p.product_name, p.image AS product_image, " +
                "c.name AS category, sa.storage_location_id, sl.zone, sl.rack_number, " +
                "sa.quantity, sa.assigned_date, sa.notes, sa.created_at " +
                "FROM storage_assignments sa " +
                "JOIN products p ON sa.product_id = p.id " +
                "JOIN categories c ON p.category_id = c.id " +
                "JOIN storage_locations sl ON sa.storage_location_id = sl.id " +
                "WHERE sa.storage_location_id = ? ORDER BY sa.created_at DESC");
            ps.setInt(1, locationId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapAssignment(rs));
        } catch (SQLException e) {
            System.out.println("Error fetching assignments by location: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return list;
    }

    @Override
    public boolean createAssignment(StorageAssignment a) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO storage_assignments " +
                "(product_id, storage_location_id, quantity, assigned_date, notes) " +
                "VALUES (?, ?, ?, ?, ?)");
            ps.setInt(1, a.getProductId());
            ps.setInt(2, a.getStorageLocationId());
            ps.setInt(3, a.getQuantity());
            ps.setDate(4, a.getAssignedDate());
            ps.setString(5, a.getNotes());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error creating assignment: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return false;
    }

    @Override
    public boolean deleteAssignment(int id) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "DELETE FROM storage_assignments WHERE id=?");
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting assignment: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return false;
    }

    @Override
    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT p.id, p.product_name, c.name AS category " +
                "FROM products p JOIN categories c ON p.category_id = c.id " +
                "WHERE p.status = 'Active' ORDER BY p.product_name");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setProductName(rs.getString("product_name"));
                p.setCategory(rs.getString("category"));
                list.add(p);
            }
        } catch (SQLException e) {
            System.out.println("Error fetching products: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return list;
    }

    @Override
    public int countByStatus(String status) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT COUNT(*) FROM storage_locations WHERE status=?");
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.out.println("Error counting locations: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return 0;
    }

    @Override
    public int totalAssignedItems() {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT COALESCE(SUM(quantity),0) FROM storage_assignments");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.out.println("Error counting assigned items: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return 0;
    }

    private StorageLocation mapLocation(ResultSet rs) throws SQLException {
        StorageLocation sl = new StorageLocation();
        sl.setId(rs.getInt("id"));
        sl.setZone(rs.getString("zone"));
        sl.setRackNumber(rs.getString("rack_number"));
        sl.setDescription(rs.getString("description"));
        sl.setCapacity(rs.getInt("capacity"));
        sl.setStatus(rs.getString("status"));
        sl.setCreatedAt(rs.getTimestamp("created_at"));
        sl.setAssignedCount(rs.getInt("assigned_count"));
        return sl;
    }

    private StorageAssignment mapAssignment(ResultSet rs) throws SQLException {
        StorageAssignment a = new StorageAssignment();
        a.setId(rs.getInt("id"));
        a.setProductId(rs.getInt("product_id"));
        a.setProductName(rs.getString("product_name"));
        a.setProductImage(rs.getString("product_image"));
        a.setProductCategory(rs.getString("category"));
        a.setStorageLocationId(rs.getInt("storage_location_id"));
        a.setZone(rs.getString("zone"));
        a.setRackNumber(rs.getString("rack_number"));
        a.setQuantity(rs.getInt("quantity"));
        a.setAssignedDate(rs.getDate("assigned_date"));
        a.setNotes(rs.getString("notes"));
        a.setCreatedAt(rs.getTimestamp("created_at"));
        return a;
    }
}
