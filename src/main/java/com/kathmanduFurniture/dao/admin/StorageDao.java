package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.entity.user.Product;
import com.kathmanduFurniture.entity.user.StorageAssignment;
import com.kathmanduFurniture.entity.user.StorageLocation;

import java.util.List;

/**
 * DAO interface for warehouse storage management.
 * Covers CRUD on storage locations and product-to-location assignments,
 * plus helper queries for dropdowns and summary statistics.
 */
public interface StorageDao {

    // ── Storage Locations ─────────────────────────────────────────────────────

    /** Returns all storage locations with their aggregated assigned-item count. */
    List<StorageLocation> getAllLocations();
    /** Returns a single storage location by primary key, or {@code null}. */
    StorageLocation       getLocationById(int id);
    /** Inserts a new storage location record. */
    boolean               createLocation(StorageLocation loc);
    /** Updates an existing storage location. */
    boolean               updateLocation(StorageLocation loc);
    /** Deletes a storage location by primary key. */
    boolean               deleteLocation(int id);

    // ── Storage Assignments ───────────────────────────────────────────────────

    /** Returns all product-to-location assignments, sorted by created_at descending. */
    List<StorageAssignment> getAllAssignments();
    /** Returns all assignments for a specific storage location. */
    List<StorageAssignment> getAssignmentsByLocation(int locationId);
    /** Inserts a new product-to-location assignment. */
    boolean                 createAssignment(StorageAssignment a);
    /** Deletes an assignment by primary key. */
    boolean                 deleteAssignment(int id);

    // ── Dropdown helpers ──────────────────────────────────────────────────────

    /** Returns all active products for the assignment form dropdown. */
    List<Product>           getAllProducts();

    // ── Statistics ────────────────────────────────────────────────────────────

    /** Returns the number of locations with the given status (Available/Full/Inactive). */
    int countByStatus(String status);
    /** Returns the total quantity of items across all assignments. */
    int totalAssignedItems();
}
