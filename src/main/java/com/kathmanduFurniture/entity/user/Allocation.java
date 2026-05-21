package com.kathmanduFurniture.entity.user;

import java.sql.Date;
import java.sql.Timestamp;

/**
 * Entity class representing a furniture allocation record.
 * An allocation tracks a product that has been issued to a user or department
 * for internal use, along with expected and actual return dates.
 * Maps to the {@code allocations} table.
 * Status values: "Issued" | "Returned" | "Overdue"
 */
public class Allocation {

    // Primary key
    private int     id;

    // Product being allocated
    private int     productId;
    private String  productName;    // populated via JOIN with products table
    private String  productImage;   // product image path
    private String  productCategory;// category name via JOIN

    // Who the product is allocated to (either a user OR a department, not both)
    private Integer allocatedToUserId;
    private String  allocatedToUserName; // user's full name via JOIN
    private String  department;          // used when allocating to a department instead of a user

    // Allocation details
    private int     quantity;
    private Date    issueDate;
    private Date    expectedReturnDate;
    private Date    actualReturnDate;   // null until the item is returned
    private String  status;             // Issued | Returned | Overdue
    private String  notes;
    private Timestamp createdAt;

    // Default constructor
    public Allocation() {}

    // ── Getters and Setters ──────────────────────────────────────────────────

    public int     getId()                          { return id; }
    public void    setId(int id)                    { this.id = id; }

    public int     getProductId()                   { return productId; }
    public void    setProductId(int v)              { this.productId = v; }

    public String  getProductName()                 { return productName; }
    public void    setProductName(String v)         { this.productName = v; }

    public String  getProductImage()                { return productImage; }
    public void    setProductImage(String v)        { this.productImage = v; }

    public String  getProductCategory()             { return productCategory; }
    public void    setProductCategory(String v)     { this.productCategory = v; }

    // Nullable — null when allocation is to a department rather than a specific user
    public Integer getAllocatedToUserId()            { return allocatedToUserId; }
    public void    setAllocatedToUserId(Integer v)  { this.allocatedToUserId = v; }

    public String  getAllocatedToUserName()          { return allocatedToUserName; }
    public void    setAllocatedToUserName(String v) { this.allocatedToUserName = v; }

    public String  getDepartment()                  { return department; }
    public void    setDepartment(String v)          { this.department = v; }

    public int     getQuantity()                    { return quantity; }
    public void    setQuantity(int v)               { this.quantity = v; }

    public Date    getIssueDate()                   { return issueDate; }
    public void    setIssueDate(Date v)             { this.issueDate = v; }

    public Date    getExpectedReturnDate()          { return expectedReturnDate; }
    public void    setExpectedReturnDate(Date v)    { this.expectedReturnDate = v; }

    public Date    getActualReturnDate()            { return actualReturnDate; }
    public void    setActualReturnDate(Date v)      { this.actualReturnDate = v; }

    public String  getStatus()                      { return status; }
    public void    setStatus(String v)              { this.status = v; }

    public String  getNotes()                       { return notes; }
    public void    setNotes(String v)               { this.notes = v; }

    public Timestamp getCreatedAt()                 { return createdAt; }
    public void      setCreatedAt(Timestamp v)      { this.createdAt = v; }

    /**
     * Returns a display label for who the product is allocated to.
     * Prefers the user's name if available; falls back to department; defaults to "—".
     */
    public String getAllocatedTo() {
        if (allocatedToUserName != null && !allocatedToUserName.isEmpty()) return allocatedToUserName;
        if (department != null && !department.isEmpty()) return department;
        return "—";
    }
}
