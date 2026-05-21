package com.kathmanduFurniture.controller.servlet.admin;

import com.kathmanduFurniture.dao.admin.AnalyticsDao;
import com.kathmanduFurniture.dao.admin.AnalyticsDaoImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Servlet serving the admin analytics page at {@code /admin/analytics}.
 * Gathers all chart data and KPI metrics from {@link AnalyticsDao}
 * and forwards them to the analytics JSP view.
 */
@WebServlet(name = "AnalyticsServlet", value = "/admin/analytics")
public class AnalyticsServlet extends HttpServlet {

    private AnalyticsDao analyticsDao;

    @Override
    public void init() throws ServletException {
        analyticsDao = new AnalyticsDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("monthlyRevenueJson",        analyticsDao.getMonthlyRevenueJson());
        request.setAttribute("ordersByStatusJson",        analyticsDao.getOrdersByStatusJson());
        request.setAttribute("topProductsJson",           analyticsDao.getTopProductsJson());
        request.setAttribute("monthlyNewUsersJson",       analyticsDao.getMonthlyNewUsersJson());
        request.setAttribute("totalFeedback",             analyticsDao.getTotalFeedback());
        request.setAttribute("pendingFeedback",           analyticsDao.getPendingFeedback());
        request.setAttribute("totalReturnOrders",         analyticsDao.getTotalReturnOrders());
        request.setAttribute("avgProductRating",          analyticsDao.getAverageProductRating());
        request.setAttribute("categoryBreakdownJson",     analyticsDao.getCategoryBreakdownJson());
        request.setAttribute("availabilityBreakdownJson", analyticsDao.getAvailabilityBreakdownJson());

        // Daily / weekly KPI metrics
        request.setAttribute("ordersToday",              analyticsDao.getOrdersToday());
        request.setAttribute("ordersThisWeek",           analyticsDao.getOrdersThisWeek());
        request.setAttribute("newUsersThisWeek",         analyticsDao.getNewUsersThisWeek());
        request.setAttribute("dailyOrdersJson",          analyticsDao.getDailyOrdersJson());

        request.getRequestDispatcher("/WEB-INF/views/admin/analytics.jsp")
               .forward(request, response);
    }
}
