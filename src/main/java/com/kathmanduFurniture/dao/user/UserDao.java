package com.kathmanduFurniture.dao.user;

import com.kathmanduFurniture.entity.user.User;

public interface UserDao {

    boolean insertUser(User user);
    User findByEmail(String email);
    User findByPhoneNumber(String  phoneNumber);
}
