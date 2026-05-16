package com.kathmanduFurniture.entity.user;

public class Product {

    private int id;
    private String productName;
    private String image;
    private double price;
    private String availability;
    private String specifications;
    private String status;
    private String category;
    private String colors;   // comma-separated hex values e.g. "#8B4513,#D2691E,#F5DEB3"
    private double rating;   // 0.0 – 5.0

    // Default constructor
    public Product() {}

    // Parameterized constructor
    public Product(int id, String productName, String image,
                   double price, String availability,
                   String specifications, String status, String category) {
        this.id             = id;
        this.productName    = productName;
        this.image          = image;
        this.price          = price;
        this.availability   = availability;
        this.specifications = specifications;
        this.status         = status;
        this.category       = category;
    }

    // Getters and Setters
    public int getId()                       { return id; }
    public void setId(int id)                { this.id = id; }

    public String getProductName()           { return productName; }
    public void setProductName(String p)     { this.productName = p; }

    public String getImage()                 { return image; }
    public void setImage(String image)       { this.image = image; }

    public double getPrice()                 { return price; }
    public void setPrice(double price)       { this.price = price; }

    public String getAvailability()          { return availability; }
    public void setAvailability(String a)    { this.availability = a; }

    public String getSpecifications()        { return specifications; }
    public void setSpecifications(String s)  { this.specifications = s; }

    public String getStatus()                { return status; }
    public void setStatus(String status)     { this.status = status; }

    public String getCategory()              { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getColors()                { return colors; }
    public void setColors(String colors)     { this.colors = colors; }

    public double getRating()                { return rating; }
    public void setRating(double rating)     { this.rating = rating; }
}