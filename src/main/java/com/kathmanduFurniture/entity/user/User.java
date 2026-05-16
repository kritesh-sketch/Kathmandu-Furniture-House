package com.kathmanduFurniture.entity.user;

import java.sql.Timestamp;

public class User {

    private int id;
    private String firstName;
    private String lastName;
    private String fullName;

    private String email;
    private String mobileNumber;
    private String gender;
    private String dob;
    private String password;
    private String status;
    private String image;

    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Default constructor
    public User() {}

    // Registration constructor
    public User(String firstName, String lastName,
                String dob, String gender,
                String email, String mobileNumber,
                String password) {

        this.firstName = firstName;
        this.lastName = lastName;
        this.dob = dob;
        this.gender = gender;
        this.email = email;
        this.mobileNumber = mobileNumber;
        this.password = password;
    }

    // Full constructor
    public User(int id, String firstName, String lastName,
                String email, String mobileNumber,
                String password,
                Timestamp createdAt, Timestamp updatedAt) {

        this.id = id;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.mobileNumber = mobileNumber;
        this.password = password;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public User(int id, String firstName, String lastName, String dob,
                String gender, String email, String mobileNumber, String password, Timestamp createdAt,
                Timestamp updatedAt) {
        this.id = id;
        this.firstName = firstName;
        this.lastName = lastName;
        this.dob = dob;
        this.gender = gender;
        this.email = email;
        this.mobileNumber = mobileNumber;
        this.password = password;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters & Setters

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

    @Override
    public String toString() {
        return "[" + id + "] " + firstName + " " + lastName +
                " (" + (email != null ? email : mobileNumber) + ")";
    }

    public void setImage(String image) {
        this.image = image;
    }

    public void setContactUs(String contactUs) {
        this.email = contactUs;
    }

    public void setDate(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public void setStatus(String status) {
        this.status = status;
    }


    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getFullName() {
        if (fullName != null && !fullName.isEmpty()) return fullName;
        return (firstName != null ? firstName : "") + " " + (lastName != null ? lastName : "");
    }

    public String getStatus() { return status; }

    public String getImage() { return image; }
}