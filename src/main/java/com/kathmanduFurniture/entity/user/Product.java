package com.kathmanduFurniture.entity.user;

/**
 * Entity class representing a furniture product in the catalogue.
 * Maps to the {@code products} table (with category resolved via JOIN to {@code categories}).
 * Color swatches are stored as a comma-separated list of hex values in the {@code colors} field.
 */
public class Product {

    // Primary key
    private int id;

    // Core catalogue fields
    private String productName;
    private String image;           // relative path stored in the DB, e.g. "products/filename.jpg"
    private double price;
    private String availability;    // In Stock | Out of Stock | Coming Soon
    private String description;
    private String specifications;
    private String status;          // Active | Inactive
    private String category;        // resolved category name via JOIN to categories table

    private String colors;               // comma-separated hex values e.g. "#8B4513,#D2691E"
    private double rating;               // average rating 0.0 – 5.0

    // Optional detailed product attributes
    private Integer seatingCapacity;
    private String  designStyle;
    private String  warrantyDetails;
    private String  returnPolicy;
    private String  installationService; // Yes / No / Optional
    private String  material;
    private String  frameMaterial;
    private String  dimensions;          // stored as "L|B|H" pipe-separated values in cm
    private Double  weightKg;
    private Integer maxWeightCapacity;   // maximum load in kg
    private String  assemblyRequired;    // Yes / No
    private String  careInstructions;

    // Default constructor — used when populating from ResultSet
    public Product() {}

    /**
     * Constructor for basic product data used in list views and cart operations.
     */
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

    // ── Getters and Setters ──────────────────────────────────────────────────

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

    public String getDescription()           { return description; }
    public void setDescription(String d)     { this.description = d; }

    public String getSpecifications()        { return specifications; }
    public void setSpecifications(String s)  { this.specifications = s; }

    public String getStatus()                { return status; }
    public void setStatus(String status)     { this.status = status; }

    public String getCategory()              { return category; }
    public void setCategory(String category) { this.category = category; }

    // Comma-separated hex color swatches
    public String getColors()                { return colors; }
    public void setColors(String colors)     { this.colors = colors; }

    public double getRating()                       { return rating; }
    public void setRating(double rating)            { this.rating = rating; }

    public Integer getSeatingCapacity()             { return seatingCapacity; }
    public void setSeatingCapacity(Integer v)       { this.seatingCapacity = v; }

    public String getDesignStyle()                  { return designStyle; }
    public void setDesignStyle(String v)            { this.designStyle = v; }

    public String getWarrantyDetails()              { return warrantyDetails; }
    public void setWarrantyDetails(String v)        { this.warrantyDetails = v; }

    public String getReturnPolicy()                 { return returnPolicy; }
    public void setReturnPolicy(String v)           { this.returnPolicy = v; }

    public String getInstallationService()          { return installationService; }
    public void setInstallationService(String v)    { this.installationService = v; }

    public String getMaterial()                     { return material; }
    public void setMaterial(String v)               { this.material = v; }

    public String getFrameMaterial()                { return frameMaterial; }
    public void setFrameMaterial(String v)          { this.frameMaterial = v; }

    // Dimensions stored as pipe-separated "L|B|H" for easy splitting in the form
    public String getDimensions()                   { return dimensions; }
    public void setDimensions(String v)             { this.dimensions = v; }

    public Double getWeightKg()                     { return weightKg; }
    public void setWeightKg(Double v)               { this.weightKg = v; }

    public Integer getMaxWeightCapacity()           { return maxWeightCapacity; }
    public void setMaxWeightCapacity(Integer v)     { this.maxWeightCapacity = v; }

    public String getAssemblyRequired()             { return assemblyRequired; }
    public void setAssemblyRequired(String v)       { this.assemblyRequired = v; }

    public String getCareInstructions()             { return careInstructions; }
    public void setCareInstructions(String v)       { this.careInstructions = v; }
}
