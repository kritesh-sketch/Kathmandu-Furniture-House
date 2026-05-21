package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.entity.user.User;
import java.util.List;

/**
 * DAO interface for admin-managed user account operations.
 * Covers approval, rejection, activation, and deactivation of user accounts.
 */
public interface VerifyUserDao {

    List<User> getAllUsers();

    List<User> getPendingUsers();

    boolean approveUser(int userId);

    boolean rejectUser(int userId);

    boolean deactivateUser(int userId);

    boolean activateUser(int userId);

    int getTotalPending();

    int getTotalApproved();
}
