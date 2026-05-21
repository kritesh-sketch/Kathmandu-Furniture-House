package com.kathmanduFurniture.entity.user;

import java.sql.Date;
import java.sql.Timestamp;

/**
 * Entity class representing the assignment of a product to a specific storage location.
 * Maps to the {@code storage_assignments} table.
 * Multiple products can be assigned to the same storage location,
 * and the same product may appear in multiple locations.
 */
public class StorageAssignment {

    // Primary key
    private int    id;

    // Product being stored
    private int    productId;
    private String productName;     // populated via JOIN with products table
    private String productImage;    // product image path
    private String productCategory; // category name via JOIN

    // Storage location details
    private int    storageLocationId;
    private String zone;            // e.g. "A", "B", "Warehouse-1" — populated via JOIN
    private String rackNumber;      // rack identifier within the zone — populated via JOIN

    // Assignment details
    private int    quantity;        // number of units stored at this location
    private Date   assignedDate;    // date the product was assigned to this location
    private String notes;
    private Timestamp createdAt;

    // Default constructor
    public StorageAssignment() {}

    // ── Getters and Setters ──────────────────────────────────────────────────

    public int       getId()                        { return id; }
    public void      setId(int id)                  { this.id = id; }

    public int       getProductId()                 { return productId; }
    public void      setProductId(int v)            { this.productId = v; }

    public String    getProductName()               { return productName; }
    public void      setProductName(String v)       { this.productName = v; }

    public String    getProductImage()              { return productImage; }
    public void      setProductImage(String v)      { this.productImage = v; }

    public String    getProductCategory()           { return productCategory; }
    public void      setProductCategory(String v)   { this.productCategory = v; }

    public int       getStorageLocationId()         { return storageLocationId; }
    public void      setStorageLocationId(int v)    { this.storageLocationId = v; }

    public String    getZone()                      { return zone; }
    public void      setZone(String v)              { this.zone = v; }

    public String    getRackNumber()                { return rackNumber; }
    public void      setRackNumber(String v)        { this.rackNumber = v; }

    public int       getQuantity()                  { return quantity; }
    public void      setQuantity(int v)             { this.quantity = v; }

    public Date      getAssignedDate()              { return assignedDate; }
    public void      setAssignedDate(Date v)        { this.assignedDate = v; }

    public String    getNotes()                     { return notes; }
    public void      setNotes(String v)             { this.notes = v; }

    public Timestamp getCreatedAt()                 { return createdAt; }
    public void      setCreatedAt(Timestamp v)      { this.createdAt = v; }

    /**
     * Returns a combined "Zone / Rack" label for display in the admin UI.
     */
    public String    getLocationLabel()             { return zone + " / " + rackNumber; }
}
