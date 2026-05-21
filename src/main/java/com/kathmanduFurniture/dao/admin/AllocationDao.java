package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.entity.user.Allocation;
import com.kathmanduFurniture.entity.user.Product;
import com.kathmanduFurniture.entity.user.User;

import java.sql.Date;
import java.util.List;

public interface AllocationDao {

    List<Allocation> getAllAllocations();
    Allocation getById(int id);
    boolean createAllocation(Allocation allocation);
    boolean markReturned(int id, Date returnDate);
    boolean deleteAllocation(int id);
    List<Product> getAllProducts();
    List<User> getAllActiveUsers();
    int countByStatus(String status);
}
