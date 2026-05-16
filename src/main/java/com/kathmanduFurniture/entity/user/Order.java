package com.kathmanduFurniture.entity.user;

public class Order {
    private int id;
    private String furnitureType;
    private int quantity;
    private String design;
    private String material;
    private int size;
    private String deliveryLocation;
    private String deadline;
    private String installationRequired;
    private String purpose;
    private String recommendation;
    private Double amount;
    private String status;

    // New order fields
    private String fullName;
    private String phoneNumber;
    private String orderType;       // "Customize" or "Normal"
    private String paymentMethod;
    private Double height;
    private Double width;

    // Dashboard-only fields (populated from JOIN queries)
    private String customerName;
    private String productName;

    // Getter and setter for order id
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    // Getter and setter for furniture types
    public String getFurnitureType() {
        return furnitureType;
    }
    public void setFurnitureType(String furnitureType) {
        this.furnitureType = furnitureType;
    }

    // getter and setter for quantity
    public int getQuantity() {
        return quantity;
    }
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    // Getter and setter for furniture design
    public String getDesign() {
        return design;
    }
    public void setDesign(String design) {
        this.design = design;
    }

    // Getter and setter for furniture material
    public String getMaterial() {
        return material;
    }
    public void setMaterial(String material) {
        this.material = material;
    }

    // getter and setter for furniture items size
    public int getSize() {
        return size;
    }
    public void setSize(int size) {
        this.size = size;
    }

    // Getter and setter for location to be deliver product
    public String getDeliveryLocation() {
        return deliveryLocation;
    }
    public void setDeliveryLocation(String deliveryLocation) {
        this.deliveryLocation = deliveryLocation;
    }

    // getter and setter for instrument requried
    public String getInstallationRequired() {
        return installationRequired;
    }
    public void setInstallationRequired(String installationRequired) {
        this.installationRequired = installationRequired;
    }

    // Getter and setter date to delivery product
    public String getDeadline() {
        return deadline;
    }
    public void setDeadline(String deadline) {
        this.deadline = deadline;
    }

    // getter and setter for purpose of funiture items
    public String getPurpose() {
        return purpose;
    }
    public void setPurpose(String purpose) {
        this.purpose = purpose;
    }

    // getter and setter for recommendation
    public String getRecommendation() {
        return recommendation;
    }
    public void setRecommendation(String recommendation) {
        this.recommendation = recommendation;
    }

    // getter and setter for Total bill produce
    public Double getAmount() { return amount; }
    public void setAmount(Double amount) { this.amount = amount; }

    // getter and setter for status of order
    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }

    // Getter and setter for customer name (from JOIN)
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    // Getter and setter for product name (from JOIN)
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

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
}