package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.entity.user.Order;
import java.util.List;

/**
 * DAO interface for the admin dashboard.
 * Provides KPI metrics (revenue, orders, products, customers) and
 * month-over-month trend percentages used by the dashboard overview page.
 */
public interface DashboardDao {

    /** Returns the total revenue from all non-cancelled Normal orders. */
    double calculateTotalRevenue();

    /** Returns the total number of products in the catalogue. */
    int getTotalProducts();

    /** Returns the number of products with status 'Active'. */
    int getActiveProducts();

    /** Returns the total number of registered customers. */
    int getTotalCustomers();

    /** Returns the total number of orders placed. */
    int getAllOrdersNumber();

    /** Returns the revenue total for the current calendar month (uses sales table). */
    double showCurrentMonthSalesReport();

    /**
     * Returns the month-over-month order count change as a percentage.
     * Positive value = growth; negative = decline.
     */
    double getOrderIncreasePercentage();

    /**
     * Returns the month-over-month active-product count change as a percentage.
     * Positive value = growth; negative = decline.
     */
    double getActiveProductIncreasePercentage();

    /**
     * Returns the month-over-month new-user count change as a percentage.
     * Positive value = growth; negative = decline.
     */
    double getUserIncreasePercentage();

    /** Returns the five most recent orders for the dashboard overview table. */
    List<Order> getAllOrders();
}
