package com.kathmanduFurniture.controller.servlet.admin;

import com.kathmanduFurniture.dao.admin.DashboardDao;
import com.kathmanduFurniture.dao.admin.DashboardDaoImpl;
import com.kathmanduFurniture.entity.user.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Servlet serving the admin dashboard at {@code /admin/dashboard}.
 * Populates KPI stat cards (revenue, orders, products, customers),
 * trend percentages, and the recent orders table.
 */
@WebServlet(name = "DashboardServlet", value = "/admin/dashboard")
public class DashboardServlet extends HttpServlet {

    private DashboardDao dashboardDao;

    @Override
    public void init() throws ServletException {
        dashboardDao = new DashboardDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── Stat-card values ──
        double totalRevenue      = dashboardDao.calculateTotalRevenue();
        int    totalOrders       = dashboardDao.getAllOrdersNumber();
        int    activeProducts    = dashboardDao.getActiveProducts();
        int    totalCustomers    = dashboardDao.getTotalCustomers();

        // ── Trend percentages (month-over-month) ──
        double ordersTrend       = dashboardDao.getOrderIncreasePercentage();
        double productsTrend     = dashboardDao.getActiveProductIncreasePercentage();
        double customersTrend    = dashboardDao.getUserIncreasePercentage();

        // ── Recent orders table ──
        List<Order> recentOrders = dashboardDao.getAllOrders();

        // ── Bind to request scope ──
        request.setAttribute("totalRevenue",   totalRevenue);
        request.setAttribute("totalOrders",    totalOrders);
        request.setAttribute("activeProducts", activeProducts);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("ordersTrend",    ordersTrend);
        request.setAttribute("productsTrend",  productsTrend);
        request.setAttribute("customersTrend", customersTrend);
        request.setAttribute("recentOrders",   recentOrders);

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp")
               .forward(request, response);
    }
}
