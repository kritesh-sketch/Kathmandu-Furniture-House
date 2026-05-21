package com.kathmanduFurniture.entity.user;

import java.sql.Timestamp;

/**
 * Entity class representing a physical storage location in the warehouse.
 * Maps to the {@code storage_locations} table.
 * Products are assigned to locations via {@link StorageAssignment}.
 * Status values: "Available" | "Full" | "Inactive"
 */
public class StorageLocation {

    // Primary key
    private int    id;

    // Location identifiers
    private String zone;        // high-level area, e.g. "Zone A", "Warehouse-2"
    private String rackNumber;  // specific rack within the zone, e.g. "R-01"
    private String description; // optional free-text description of the location

    // Capacity management
    private int    capacity;       // maximum number of items the location can hold
    private String status;         // Available | Full | Inactive
    private Timestamp createdAt;

    // Computed field: sum of quantities from all assignments to this location
    // populated by a SUM(sa.quantity) in the SQL query, not stored in the table
    private int    assignedCount;

    // Default constructor
    public StorageLocation() {}

    // ── Getters and Setters ──────────────────────────────────────────────────

    public int       getId()                        { return id; }
    public void      setId(int id)                  { this.id = id; }

    public String    getZone()                      { return zone; }
    public void      setZone(String v)              { this.zone = v; }

    public String    getRackNumber()                { return rackNumber; }
    public void      setRackNumber(String v)        { this.rackNumber = v; }

    public String    getDescription()               { return description; }
    public void      setDescription(String v)       { this.description = v; }

    public int       getCapacity()                  { return capacity; }
    public void      setCapacity(int v)             { this.capacity = v; }

    public String    getStatus()                    { return status; }
    public void      setStatus(String v)            { this.status = v; }

    public Timestamp getCreatedAt()                 { return createdAt; }
    public void      setCreatedAt(Timestamp v)      { this.createdAt = v; }

    // Total items currently assigned to this location (aggregated in the query)
    public int       getAssignedCount()             { return assignedCount; }
    public void      setAssignedCount(int v)        { this.assignedCount = v; }

    /**
     * Returns a combined "Zone / Rack" label for display in the admin UI.
     */
    public String getLabel() { return zone + " / " + rackNumber; }
}
