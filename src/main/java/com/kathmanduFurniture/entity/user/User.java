package com.kathmanduFurniture.entity.user;

import java.sql.Timestamp;

/**
 * Entity class representing a registered user of the Kathmandu Furniture House application.
 * Maps to the {@code users} table in the database.
 * Status values: "Pending" (awaiting admin approval), "Active", "Inactive".
 */
public class User {

    // Primary key
    private int id;

    // Name fields
    private String firstName;
    private String lastName;
    private String fullName; // computed or joined value, not stored separately in DB

    // Contact details
    private String email;
    private String mobileNumber;

    // Profile details
    private String gender;
    private String dob;       // date of birth stored as "YYYY-MM-DD" string
    private String password;  // BCrypt hashed password
    private String status;    // Pending | Active | Inactive
    private String image;     // relative path to profile image

    // Audit timestamps from the database
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Default constructor — required for manual field-by-field population (e.g., from ResultSet)
    public User() {}

    /**
     * Constructor used during user self-registration.
     * Status is set to "Pending" by the DAO after insertion.
     */
    public User(String firstName, String lastName,
                String dob, String gender,
                String email, String mobileNumber,
                String password) {

        this.firstName    = firstName;
        this.lastName     = lastName;
        this.dob          = dob;
        this.gender       = gender;
        this.email        = email;
        this.mobileNumber = mobileNumber;
        this.password     = password;
    }

    /**
     * Constructor used when loading users from the database (without dob/gender).
     */
    public User(int id, String firstName, String lastName,
                String email, String mobileNumber,
                String password,
                Timestamp createdAt, Timestamp updatedAt) {

        this.id           = id;
        this.firstName    = firstName;
        this.lastName     = lastName;
        this.email        = email;
        this.mobileNumber = mobileNumber;
        this.password     = password;
        this.createdAt    = createdAt;
        this.updatedAt    = updatedAt;
    }

    /**
     * Full constructor including all profile fields.
     */
    public User(int id, String firstName, String lastName, String dob,
                String gender, String email, String mobileNumber, String password,
                Timestamp createdAt, Timestamp updatedAt) {
        this.id           = id;
        this.firstName    = firstName;
        this.lastName     = lastName;
        this.dob          = dob;
        this.gender       = gender;
        this.email        = email;
        this.mobileNumber = mobileNumber;
        this.password     = password;
        this.createdAt    = createdAt;
        this.updatedAt    = updatedAt;
    }

    // ── Getters & Setters ────────────────────────────────────────────────────

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getMobileNumber() { return mobileNumber; }
    public void setMobileNumber(String mobileNumber) { this.mobileNumber = mobileNumber; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getDob() { return dob; }
    public void setDob(String dob) { this.dob = dob; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public void setImage(String image) { this.image = image; }

    // setContactUs maps the contact value to the email field (used in legacy register form)
    public void setContactUs(String contactUs) { this.email = contactUs; }

    // setDate aliases setCreatedAt for older code paths
    public void setDate(Timestamp createdAt) { this.createdAt = createdAt; }

    public void setStatus(String status) { this.status = status; }

    public void setFullName(String fullName) { this.fullName = fullName; }

    /**
     * Returns the full name. If a combined fullName was explicitly set (e.g., from a JOIN),
     * it is returned directly; otherwise firstName and lastName are concatenated.
     */
    public String getFullName() {
        if (fullName != null && !fullName.isEmpty()) return fullName;
        return (firstName != null ? firstName : "") + " " + (lastName != null ? lastName : "");
    }

    public String getStatus() { return status; }

    public String getImage() { return image; }

    /**
     * Returns a concise debug representation showing the user's ID and primary contact.
     */
    @Override
    public String toString() {
        return "[" + id + "] " + firstName + " " + lastName +
                " (" + (email != null ? email : mobileNumber) + ")";
    }
}
