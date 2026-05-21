package com.kathmanduFurniture.entity.user;

import java.sql.Timestamp;

/**
 * Entity class representing a customer order.
 * Maps to the {@code orders} table. Supports two order types:
 * <ul>
 *   <li>"Normal"    — a standard product purchase from the catalogue</li>
 *   <li>"Customize" — a custom furniture request with specifications</li>
 * </ul>
 */
public class Order {

    // Primary key
    private int id;

    // Furniture/customization details (primarily used for Customize orders)
    private String furnitureType;
    private int    quantity;
    private String design;
    private String material;
    private int    size;
    private String deliveryLocation;
    private String deadline;
    private String installationRequired;
    private String purpose;
    private String recommendation;
    private String budgetRange;
    private String description;
    private String notes;
    private Double amount;      // general amount field
    private String status;      // Pending | Confirmed | Processing | Delivered | Cancelled

    // Customer contact fields (captured at order time, independent of user account)
    private String fullName;
    private String phoneNumber;

    // Order classification and payment
    private String orderType;       // "Customize" or "Normal"
    private String paymentMethod;

    // Custom dimensions for Customize orders
    private Double height;
    private Double width;
    private Double breadth;

    // Standard DB fields from the orders table
    private Double      totalAmount;  // total price at time of order
    private Timestamp   orderDate;    // timestamp when order was placed
    private int         productId;    // foreign key to products table
    private int         customerId;   // foreign key to users table

    // Reference image path uploaded with a custom furniture request
    private String referenceImage;

    // Populated via JOIN queries (not stored in orders table)
    private String customerName;  // resolved from users table
    private String productName;   // resolved from products table
    private String productImage;  // resolved from products table

    // ── Getters and Setters ──────────────────────────────────────────────────

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getFurnitureType() { return furnitureType; }
    public void setFurnitureType(String furnitureType) { this.furnitureType = furnitureType; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getDesign() { return design; }
    public void setDesign(String design) { this.design = design; }

    public String getMaterial() { return material; }
    public void setMaterial(String material) { this.material = material; }

    public int getSize() { return size; }
    public void setSize(int size) { this.size = size; }

    public String getDeliveryLocation() { return deliveryLocation; }
    public void setDeliveryLocation(String deliveryLocation) { this.deliveryLocation = deliveryLocation; }

    public String getInstallationRequired() { return installationRequired; }
    public void setInstallationRequired(String installationRequired) { this.installationRequired = installationRequired; }

    public String getDeadline() { return deadline; }
    public void setDeadline(String deadline) { this.deadline = deadline; }

    public String getPurpose() { return purpose; }
    public void setPurpose(String purpose) { this.purpose = purpose; }

    public String getRecommendation() { return recommendation; }
    public void setRecommendation(String recommendation) { this.recommendation = recommendation; }

    public String getBudgetRange()                    { return budgetRange; }
    public void setBudgetRange(String budgetRange)    { this.budgetRange = budgetRange; }

    public String getDescription()                 { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getNotes()               { return notes; }
    public void setNotes(String notes)     { this.notes = notes; }

    public Double getAmount() { return amount; }
    public void setAmount(Double amount) { this.amount = amount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    // Fields populated from JOIN queries for display purposes
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getProductImage() { return productImage; }
    public void setProductImage(String productImage) { this.productImage = productImage; }

    public String getFullName()                  { return fullName; }
    public void setFullName(String fullName)     { this.fullName = fullName; }

    public String getPhoneNumber()                     { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber)     { this.phoneNumber = phoneNumber; }

    public String getOrderType()                     { return orderType; }
    public void setOrderType(String orderType)       { this.orderType = orderType; }

    public String getPaymentMethod()                       { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod)     { this.paymentMethod = paymentMethod; }

    public Double getHeight()                { return height; }
    public void setHeight(Double height)     { this.height = height; }

    public Double getWidth()               { return width; }
    public void setWidth(Double width)     { this.width = width; }

    public Double getBreadth()             { return breadth; }
    public void setBreadth(Double breadth) { this.breadth = breadth; }

    public Double    getTotalAmount()                  { return totalAmount; }
    public void      setTotalAmount(Double v)          { this.totalAmount = v; }

    public Timestamp getOrderDate()                    { return orderDate; }
    public void      setOrderDate(Timestamp v)         { this.orderDate = v; }

    public int       getProductId()                    { return productId; }
    public void      setProductId(int v)               { this.productId = v; }

    public int       getCustomerId()                   { return customerId; }
    public void      setCustomerId(int v)              { this.customerId = v; }

    public String getReferenceImage()                        { return referenceImage; }
    public void   setReferenceImage(String referenceImage)   { this.referenceImage = referenceImage; }
}
