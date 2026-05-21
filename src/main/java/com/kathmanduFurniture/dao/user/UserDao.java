package com.kathmanduFurniture.dao.user;

import com.kathmanduFurniture.entity.user.Order;
import com.kathmanduFurniture.entity.user.User;

import java.util.List;

public interface UserDao {

    boolean insertUser(User user);
    User findByEmail(String email);
    User findByPhoneNumber(String phoneNumber);
    User findById(int id);
    boolean updateProfile(int id, String firstName, String lastName, String email, String mobileNumber, String dob, String gender);
    boolean updatePassword(int id, String hashedPassword);
    boolean updateImage(int id, String imagePath);
    List<Order> getOrdersByCustomerId(int customerId);
}
