package com.kathmanduFurniture.dao.admin;

public interface AnalyticsDao {
    String getMonthlyRevenueJson();
    String getOrdersByStatusJson();
    String getTopProductsJson();
    String getMonthlyNewUsersJson();
    int getTotalFeedback();
    int getPendingFeedback();
    int getTotalReturnOrders();
    double getAverageProductRating();
    String getCategoryBreakdownJson();
    String getAvailabilityBreakdownJson();

    // Daily / weekly KPI metrics (week-10 workshop pattern)
    int getOrdersToday();
    int getOrdersThisWeek();
    int getNewUsersThisWeek();
    String getDailyOrdersJson();
}
