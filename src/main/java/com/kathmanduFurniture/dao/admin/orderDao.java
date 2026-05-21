package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.entity.user.Order;

import java.util.ArrayList;

/**
 * DAO interface for managing customer orders.
 * Provides CRUD operations on the orders table, supporting both
 * Normal and Customize order types.
 */
public interface OrderDao {

    /**
     * Retrieves a single order by its primary key.
     *
     * @param id the order ID
     * @return the Order, or null if not found
     */
    Order getOrderById(int id);

    /**
     * Inserts a new order record into the database.
     *
     * @param order the order to persist
     * @return true if the insert succeeded
     */
    boolean placeOrder(Order order);

    /**
     * Returns all orders sorted by order date descending.
     *
     * @return list of all orders
     */
    ArrayList<Order> getAllOrders();

    /**
     * Updates editable fields (status, dimensions, notes, etc.) of an existing order.
     *
     * @param order the order with updated values and a valid ID
     * @return true if the update succeeded
     */
    boolean updateOrder(Order order);

    /**
     * Permanently deletes an order by its primary key.
     *
     * @param id the order ID to delete
     * @return true if the delete succeeded
     */
    boolean deleteOrderById(int id);
}
