package com.kathmanduFurniture.entity.user;

import java.util.Date;

public class Discount {
    private int    id;
    private String title;
    private String eventName;
    private String discountCode;
    private String discountType;
    private double discountPercent;
    private double discountAmount;
    private String description;
    private String status;
    private Date   startDate;
    private Date   endDate;

    public int    getId()                          { return id; }
    public void   setId(int id)                    { this.id = id; }

    public String getTitle()                       { return title; }
    public void   setTitle(String title)           { this.title = title; }

    public String getEventName()                   { return eventName; }
    public void   setEventName(String eventName)   { this.eventName = eventName; }

    public String getDiscountCode()                { return discountCode; }
    public void   setDiscountCode(String code)     { this.discountCode = code; }

    public String getDiscountType()                { return discountType; }
    public void   setDiscountType(String type)     { this.discountType = type; }

    public double getDiscountPercent()             { return discountPercent; }
    public void   setDiscountPercent(double p)     { this.discountPercent = p; }

    public double getDiscountAmount()              { return discountAmount; }
    public void   setDiscountAmount(double a)      { this.discountAmount = a; }

    public String getDescription()                 { return description; }
    public void   setDescription(String desc)      { this.description = desc; }

    public String getStatus()                      { return status; }
    public void   setStatus(String status)         { this.status = status; }

    public Date   getStartDate()                   { return startDate; }
    public void   setStartDate(Date startDate)     { this.startDate = startDate; }

    public Date   getEndDate()                     { return endDate; }
    public void   setEndDate(Date endDate)         { this.endDate = endDate; }
}
