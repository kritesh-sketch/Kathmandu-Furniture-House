package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.entity.user.Order;

import java.util.ArrayList;

public interface orderDao {
    // SELECT BY ID
    Order getOrderById(int id);
    boolean placeOrder(Order order);
    ArrayList<Order> getAllOrders();
    boolean updateOrder(Order order);
    boolean deleteOrderById(int id);
}
