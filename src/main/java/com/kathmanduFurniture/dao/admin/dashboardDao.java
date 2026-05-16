package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.entity.user.Order;
import java.util.List;

public interface dashboardDao {

    // Overall information of product
    double calculateTotalRevenue();
    int getTotalProducts();
    int getActiveProducts();
    int getTotalCustomers();
    int getAllOrdersNumber();
    double showCurrentMonthSalesReport();
    double getOrderIncreasePercentage();
    double getActiveProductIncreasePercentage();
    double getUserIncreasePercentage();

    // Upper part
    List<Order> getAllOrders();
}