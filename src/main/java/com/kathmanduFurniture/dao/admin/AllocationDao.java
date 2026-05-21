package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.entity.user.Allocation;
import com.kathmanduFurniture.entity.user.Product;
import com.kathmanduFurniture.entity.user.User;

import java.sql.Date;
import java.util.List;

/**
 * DAO interface for furniture allocation records.
 * Supports creating, returning, deleting, and querying allocations,
 * plus helper queries for product and user dropdown data.
 */
public interface AllocationDao {

    /** Returns all allocation records sorted by created_at descending. */
    List<Allocation> getAllAllocations();
    /** Returns a single allocation by primary key, or {@code null}. */
    Allocation getById(int id);
    /** Inserts a new allocation with status 'Issued'. */
    boolean createAllocation(Allocation allocation);
    /** Sets actual_return_date and changes status to 'Returned'. */
    boolean markReturned(int id, Date returnDate);
    /** Permanently removes an allocation record. */
    boolean deleteAllocation(int id);
    /** Returns all active products for the allocation form dropdown. */
    List<Product> getAllProducts();
    /** Returns all Active (non-admin) users for the allocation form dropdown. */
    List<User> getAllActiveUsers();
    /** Returns the count of allocations with the given status. */
    int countByStatus(String status);
}
