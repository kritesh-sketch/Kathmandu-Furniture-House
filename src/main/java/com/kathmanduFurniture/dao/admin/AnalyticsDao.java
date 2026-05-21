package com.kathmanduFurniture.dao.admin;

/**
 * DAO interface for admin analytics data.
 * All chart methods return JSON arrays in the form
 * {@code [{"label":"...","value":...}, ...]}, ready for consumption
 * by Chart.js in the analytics JSP.
 */
public interface AnalyticsDao {
    /** Returns monthly revenue totals for the last 6 months as a JSON array. */
    String getMonthlyRevenueJson();
    /** Returns order counts grouped by status as a JSON array. */
    String getOrdersByStatusJson();
    /** Returns the top 5 most-ordered products as a JSON array. */
    String getTopProductsJson();
    /** Returns new-user registration counts by month for the last 6 months. */
    String getMonthlyNewUsersJson();
    /** Returns the total number of feedback submissions. */
    int getTotalFeedback();
    /** Returns the number of feedback submissions with status 'Pending'. */
    int getPendingFeedback();
    /** Returns the total number of return orders. */
    int getTotalReturnOrders();
    /** Returns the average star rating across all active products. */
    double getAverageProductRating();
    /** Returns product counts grouped by category as a JSON array. */
    String getCategoryBreakdownJson();
    /** Returns product and order counts grouped by availability status as a JSON array. */
    String getAvailabilityBreakdownJson();
    /** Returns the number of orders placed today. */
    int getOrdersToday();
    /** Returns the number of orders placed in the current calendar week. */
    int getOrdersThisWeek();
    /** Returns the number of new users registered in the current calendar week. */
    int getNewUsersThisWeek();
    /** Returns daily order counts for the last 7 days as a JSON array. */
    String getDailyOrdersJson();
}
