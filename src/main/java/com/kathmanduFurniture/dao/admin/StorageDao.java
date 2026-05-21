package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.entity.user.Product;
import com.kathmanduFurniture.entity.user.StorageAssignment;
import com.kathmanduFurniture.entity.user.StorageLocation;

import java.util.List;

public interface StorageDao {

    // Storage Locations
    List<StorageLocation> getAllLocations();
    StorageLocation       getLocationById(int id);
    boolean               createLocation(StorageLocation loc);
    boolean               updateLocation(StorageLocation loc);
    boolean               deleteLocation(int id);

    // Assignments
    List<StorageAssignment> getAllAssignments();
    List<StorageAssignment> getAssignmentsByLocation(int locationId);
    boolean                 createAssignment(StorageAssignment a);
    boolean                 deleteAssignment(int id);

    // For dropdowns
    List<Product>           getAllProducts();

    // Stats
    int countByStatus(String status);
    int totalAssignedItems();
}
