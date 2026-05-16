package com.kathmanduFurniture.entity.user;

public class Return {
    private int    returnId;
    private int    orderId;
    private String customerName;
    private String phoneNumber;
    private String product;
    private String reason;
    private String status;
    private String returnDate;
    private double refundAmount;

    public Return() {}

    public int    getReturnId()                        { return returnId; }
    public void   setReturnId(int returnId)            { this.returnId = returnId; }

    public int    getOrderId()                         { return orderId; }
    public void   setOrderId(int orderId)              { this.orderId = orderId; }

    public String getCustomer()                        { return customerName; }
    public void   setCustomerName(String customerName) { this.customerName = customerName; }

    public String getPhoneNumber()                     { return phoneNumber; }
    public void   setPhoneNumber(String phoneNumber)   { this.phoneNumber = phoneNumber; }

    public String getProduct()                         { return product; }
    public void   setProduct(String product)           { this.product = product; }

    public String getReason()                          { return reason; }
    public void   setReason(String reason)             { this.reason = reason; }

    public String getStatus()                          { return status; }
    public void   setStatus(String status)             { this.status = status; }

    public String getReturnDate()                      { return returnDate; }
    public void   setReturnDate(String returnDate)     { this.returnDate = returnDate; }

    public double getRefundAmount()                    { return refundAmount; }
    public void   setRefundAmount(double refundAmount) { this.refundAmount = refundAmount; }
}
