package com.kathmanduFurniture.entity.user;

import java.sql.Date;
import java.sql.Timestamp;

public class StorageAssignment {

    private int    id;
    private int    productId;
    private String productName;
    private String productImage;
    private String productCategory;
    private int    storageLocationId;
    private String zone;
    private String rackNumber;
    private int    quantity;
    private Date   assignedDate;
    private String notes;
    private Timestamp createdAt;

    public StorageAssignment() {}

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

    public String    getLocationLabel()             { return zone + " / " + rackNumber; }
}
