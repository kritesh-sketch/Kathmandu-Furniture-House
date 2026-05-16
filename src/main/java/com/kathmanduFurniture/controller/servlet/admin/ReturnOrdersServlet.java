package com.kathmanduFurniture.controller.servlet.admin;

import com.kathmanduFurniture.dao.admin.returnProductDao;
import com.kathmanduFurniture.dao.admin.returnProductDaoImpl;
import com.kathmanduFurniture.entity.user.Return;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ReturnOrdersServlet", value = "/admin/return-orders")
public class ReturnOrdersServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private final returnProductDao dao = new returnProductDaoImpl();

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

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String returnIdStr = req.getParameter("returnId");
        String newStatus   = req.getParameter("status");

        if (returnIdStr != null && newStatus != null) {
            try {
                int returnId = Integer.parseInt(returnIdStr.trim());
                dao.updateReturnStatus(returnId, newStatus.trim());
            } catch (NumberFormatException ignored) {}
        }

        String redirectId = req.getParameter("redirectId");
        if (redirectId != null && !redirectId.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/admin/return-orders?id=" + redirectId + "&toast=updated");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/return-orders?toast=updated");
        }
    }

    private void showDetail(HttpServletRequest req, HttpServletResponse resp, String idParam)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(idParam.trim());
            Return ret = dao.getReturnById(id);
            if (ret == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/return-orders");
                return;
            }
            req.setAttribute("ret", ret);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/return-orders");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/return-order-detail.jsp").forward(req, resp);
    }

    private void showList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String search   = param(req, "search",   "");
        String searchBy = param(req, "searchBy", "name");
        String status   = param(req, "status",   "all");

        int page = 1;
        try { page = Math.max(1, Integer.parseInt(req.getParameter("page"))); }
        catch (Exception ignored) {}

        List<Return> all      = dao.getAllReturns();
        List<Return> filtered = applyFilters(all, search, searchBy, status);

        int totalCount = filtered.size();
        int totalPages = Math.max(1, (int) Math.ceil((double) totalCount / PAGE_SIZE));
        page = Math.min(page, totalPages);
        int startIndex = (page - 1) * PAGE_SIZE;
        int endIndex   = Math.min(startIndex + PAGE_SIZE, totalCount);
        List<Return> pageList = filtered.subList(startIndex, endIndex);

        req.setAttribute("returns",     pageList);
        req.setAttribute("totalCount",  totalCount);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages",  totalPages);
        req.setAttribute("startIndex",  startIndex);
        req.setAttribute("search",      search);
        req.setAttribute("searchBy",    searchBy);
        req.setAttribute("status",      status);
        req.getRequestDispatcher("/WEB-INF/views/admin/return-orders.jsp").forward(req, resp);
    }

    private List<Return> applyFilters(List<Return> all, String search,
                                      String searchBy, String status) {
        List<Return> result = new ArrayList<>();
        String q = search.trim().toLowerCase();
        for (Return r : all) {
            if (!"all".equalsIgnoreCase(status) && !status.equalsIgnoreCase(r.getStatus())) continue;
            if (!q.isEmpty()) {
                boolean match = false;
                switch (searchBy) {
                    case "id":      match = String.valueOf(r.getReturnId()).contains(q); break;
                    case "orderid": match = String.valueOf(r.getOrderId()).contains(q);  break;
                    case "phone":   match = contains(r.getPhoneNumber(), q);             break;
                    case "product": match = contains(r.getProduct(), q);                 break;
                    default:        match = contains(r.getCustomer(), q);                break;
                }
                if (!match) continue;
            }
            result.add(r);
        }
        return result;
    }

    private void exportCsv(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String search   = param(req, "search",   "");
        String searchBy = param(req, "searchBy", "name");
        String status   = param(req, "status",   "all");

        List<Return> filtered = applyFilters(dao.getAllReturns(), search, searchBy, status);

        resp.setContentType("text/csv;charset=UTF-8");
        resp.setHeader("Content-Disposition", "attachment; filename=\"return-orders.csv\"");
        PrintWriter pw = resp.getWriter();
        pw.println("Return ID,Order ID,Customer Name,Phone,Product,Reason,Status,Return Date,Refund Amount");
        for (Return r : filtered) {
            pw.printf("%d,%d,\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%.2f\"%n",
                    r.getReturnId(), r.getOrderId(),
                    esc(r.getCustomer()), esc(r.getPhoneNumber()),
                    esc(r.getProduct()),  esc(r.getReason()),
                    esc(r.getStatus()),   esc(r.getReturnDate()),
                    r.getRefundAmount());
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
