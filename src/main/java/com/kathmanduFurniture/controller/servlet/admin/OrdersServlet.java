package com.kathmanduFurniture.controller.servlet.admin;

import com.kathmanduFurniture.dao.admin.orderDao;
import com.kathmanduFurniture.dao.admin.orderDaoImpl;
import com.kathmanduFurniture.entity.user.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "OrdersServlet", value = "/admin/orders")
public class OrdersServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private final orderDao dao = new orderDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");

        if (idParam != null && !idParam.isBlank()) {
            showDetail(req, resp, idParam);
            return;
        }

        if ("csv".equals(req.getParameter("export"))) {
            exportCsv(req, resp);
            return;
        }

        showList(req, resp);
    }

    private void showDetail(HttpServletRequest req, HttpServletResponse resp, String idParam)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(idParam.trim());
            Order order = dao.getOrderById(id);
            if (order == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/orders");
                return;
            }
            req.setAttribute("order", order);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/orders");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/order-detail.jsp").forward(req, resp);
    }

    private void showList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String search   = param(req, "search",   "");
        String searchBy = param(req, "searchBy", "name");
        String status   = param(req, "status",   "all");
        String type     = param(req, "type",     "all");

        int page = 1;
        try { page = Math.max(1, Integer.parseInt(req.getParameter("page"))); }
        catch (Exception ignored) {}

        List<Order> all      = dao.getAllOrders();
        List<Order> filtered = applyFilters(all, search, searchBy, status, type);

        int totalCount = filtered.size();
        int totalPages = Math.max(1, (int) Math.ceil((double) totalCount / PAGE_SIZE));
        page = Math.min(page, totalPages);
        int startIndex = (page - 1) * PAGE_SIZE;
        int endIndex   = Math.min(startIndex + PAGE_SIZE, totalCount);
        List<Order> pageList = filtered.subList(startIndex, endIndex);

        req.setAttribute("orders",      pageList);
        req.setAttribute("totalCount",  totalCount);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages",  totalPages);
        req.setAttribute("startIndex",  startIndex);
        req.setAttribute("search",      search);
        req.setAttribute("searchBy",    searchBy);
        req.setAttribute("status",      status);
        req.setAttribute("type",        type);
        req.getRequestDispatcher("/WEB-INF/views/admin/orders.jsp").forward(req, resp);
    }

    private List<Order> applyFilters(List<Order> all, String search,
                                     String searchBy, String status, String type) {
        List<Order> result = new ArrayList<>();
        String q = search.trim().toLowerCase();
        for (Order o : all) {
            if (!"all".equalsIgnoreCase(status)
                    && !status.equalsIgnoreCase(o.getStatus())) continue;
            if (!"all".equalsIgnoreCase(type)
                    && !type.equalsIgnoreCase(o.getOrderType())) continue;
            if (!q.isEmpty()) {
                boolean match = false;
                switch (searchBy) {
                    case "id":      match = String.valueOf(o.getId()).contains(q); break;
                    case "phone":   match = contains(o.getPhoneNumber(), q); break;
                    case "product": match = contains(o.getFurnitureType(), q); break;
                    default:        match = contains(o.getFullName(), q); break;
                }
                if (!match) continue;
            }
            result.add(o);
        }
        return result;
    }

    private void exportCsv(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String search   = param(req, "search",   "");
        String searchBy = param(req, "searchBy", "name");
        String status   = param(req, "status",   "all");
        String type     = param(req, "type",     "all");

        List<Order> filtered = applyFilters(dao.getAllOrders(), search, searchBy, status, type);

        resp.setContentType("text/csv;charset=UTF-8");
        resp.setHeader("Content-Disposition", "attachment; filename=\"orders.csv\"");
        PrintWriter pw = resp.getWriter();
        pw.println("ID,Full Name,Phone,Delivery Address,Product,Qty,Type,Payment,Status,Height,Width");
        for (Order o : filtered) {
            pw.printf("%d,\"%s\",\"%s\",\"%s\",\"%s\",%d,\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"%n",
                    o.getId(),
                    esc(o.getFullName()), esc(o.getPhoneNumber()),
                    esc(o.getDeliveryLocation()), esc(o.getFurnitureType()),
                    o.getQuantity(),
                    esc(o.getOrderType()), esc(o.getPaymentMethod()),
                    esc(o.getStatus()),
                    o.getHeight() != null ? o.getHeight() : "",
                    o.getWidth()  != null ? o.getWidth()  : "");
        }
        pw.flush();
    }

    private static boolean contains(String field, String q) {
        return field != null && field.toLowerCase().contains(q);
    }

    private static String esc(String s) {
        if (s == null) return "";
        return s.replace("\"", "\"\"");
    }

    private static String param(HttpServletRequest req, String name, String def) {
        String v = req.getParameter(name);
        return (v != null && !v.isBlank()) ? v.trim() : def;
    }
}
