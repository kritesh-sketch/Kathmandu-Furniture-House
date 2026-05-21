package com.kathmanduFurniture.entity.user;

import java.sql.Timestamp;

public class StorageLocation {

    private int    id;
    private String zone;
    private String rackNumber;
    private String description;
    private int    capacity;
    private String status;       // Available | Full | Inactive
    private Timestamp createdAt;
    private int    assignedCount; // sum of quantities assigned to this location

    public StorageLocation() {}

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

    public int       getAssignedCount()             { return assignedCount; }
    public void      setAssignedCount(int v)        { this.assignedCount = v; }

    public String getLabel() { return zone + " / " + rackNumber; }
}
