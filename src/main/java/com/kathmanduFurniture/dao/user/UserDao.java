package com.kathmanduFurniture.dao.user;

import com.kathmanduFurniture.entity.user.Order;
import com.kathmanduFurniture.entity.user.User;

import java.util.List;

/**
 * DAO interface for user account operations.
 * Covers registration, lookup, profile/password/image updates, and order history.
 */
public interface UserDao {

    /** Inserts a new user row; returns {@code false} if the email/phone is already taken. */
    boolean insertUser(User user);
    /** Finds a user by email (case-insensitive), or returns {@code null}. */
    User findByEmail(String email);
    /** Finds a user by phone number, or returns {@code null}. */
    User findByPhoneNumber(String phoneNumber);
    /** Finds a user by primary key, or returns {@code null}. */
    User findById(int id);
    /** Updates editable profile fields and sets updated_at to NOW(). */
    boolean updateProfile(int id, String firstName, String lastName, String email, String mobileNumber, String dob, String gender);
    /** Replaces the stored BCrypt hash for the user's password. */
    boolean updatePassword(int id, String hashedPassword);
    /** Saves a new profile image path for the user. */
    boolean updateImage(int id, String imagePath);
    /** Returns all orders placed by the given customer, newest first. */
    List<Order> getOrdersByCustomerId(int customerId);
}
