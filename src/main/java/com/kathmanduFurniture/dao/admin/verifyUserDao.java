package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.entity.user.User;
import java.util.List;

public interface verifyUserDao {

    List<User> getPendingUsers();

    boolean approveUser(int userId);

    boolean rejectUser(int userId);

    int getTotalPending();

    int getTotalApproved();
}
