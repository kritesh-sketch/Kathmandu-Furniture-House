package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.entity.user.User;

public interface AdminAccountDao {
    User findById(int id);
    boolean updateProfile(int id, String firstName, String lastName, String email, String mobileNumber, String dob, String gender);
    boolean updatePassword(int id, String hashedPassword);
    boolean updateImage(int id, String imagePath);
}
