package com.kathmanduFurniture.controller.servlet.admin;

import com.kathmanduFurniture.dao.admin.discountDao;
import com.kathmanduFurniture.dao.admin.discountDaoImpl;
import com.kathmanduFurniture.entity.user.Discount;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "OffersServlet", value = "/admin/offers")
public class OffersServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private static final SimpleDateFormat SDF = new SimpleDateFormat("yyyy-MM-dd");

    private final discountDao dao = new discountDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        // add form
        if ("new".equals(action)) {
            req.setAttribute("mode", "add");
            req.getRequestDispatcher("/WEB-INF/views/admin/offer-form.jsp").forward(req, resp);
            return;
        }

        // edit form
        String idParam = req.getParameter("id");
        if (idParam != null && !idParam.isBlank()) {
            try {
                int id = Integer.parseInt(idParam.trim());
                Discount offer = dao.getOfferById(id);
                if (offer == null) {
                    resp.sendRedirect(req.getContextPath() + "/admin/offers");
                    return;
                }
                req.setAttribute("offer", offer);
                req.setAttribute("mode", "edit");
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/admin/offers");
                return;
            }
            req.getRequestDispatcher("/WEB-INF/views/admin/offer-form.jsp").forward(req, resp);
            return;
        }

        showList(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("delete".equals(action)) {
            handleDelete(req, resp);
            return;
        }
        if ("status".equals(action)) {
            handleStatusToggle(req, resp);
            return;
        }

        handleSave(req, resp);
    }

    private void handleSave(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        boolean isEdit = (idStr != null && !idStr.isBlank());

        Discount o = new Discount();
        o.setTitle(param(req, "title", ""));
        o.setEventName(param(req, "eventName", ""));
        o.setDiscountCode(param(req, "discountCode", "").toUpperCase());
        o.setDiscountType(param(req, "discountType", "Percentage"));
        o.setDescription(param(req, "description", ""));
        o.setStatus(param(req, "status", "Active"));

        try { o.setDiscountPercent(Double.parseDouble(req.getParameter("discountPercent"))); }
        catch (Exception ignored) {}
        try { o.setDiscountAmount(Double.parseDouble(req.getParameter("discountAmount"))); }
        catch (Exception ignored) {}

        try { o.setStartDate(SDF.parse(req.getParameter("startDate"))); }
        catch (ParseException ignored) {}
        try { o.setEndDate(SDF.parse(req.getParameter("endDate"))); }
        catch (ParseException ignored) {}

        if (isEdit) {
            try { o.setId(Integer.parseInt(idStr.trim())); } catch (NumberFormatException ignored) {}
            dao.updateOffer(o);
            resp.sendRedirect(req.getContextPath() + "/admin/offers?toast=updated");
        } else {
            dao.createOffer(o);
            resp.sendRedirect(req.getContextPath() + "/admin/offers?toast=created");
        }
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            try { dao.deleteOffer(Integer.parseInt(idStr.trim())); }
            catch (NumberFormatException ignored) {}
        }
        resp.sendRedirect(req.getContextPath() + "/admin/offers?toast=deleted");
    }

    private void handleStatusToggle(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr     = req.getParameter("id");
        String newStatus = req.getParameter("status");
        if (idStr != null && newStatus != null) {
            try { dao.updateStatus(Integer.parseInt(idStr.trim()), newStatus.trim()); }
            catch (NumberFormatException ignored) {}
        }
        resp.sendRedirect(req.getContextPath() + "/admin/offers?toast=updated");
    }

    private void showList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String search   = param(req, "search",   "");
        String searchBy = param(req, "searchBy", "title");
        String status   = param(req, "status",   "all");

        int page = 1;
        try { page = Math.max(1, Integer.parseInt(req.getParameter("page"))); }
        catch (Exception ignored) {}

        List<Discount> all      = dao.getAllOffers();
        List<Discount> filtered = applyFilters(all, search, searchBy, status);

        int totalCount = filtered.size();
        int totalPages = Math.max(1, (int) Math.ceil((double) totalCount / PAGE_SIZE));
        page = Math.min(page, totalPages);
        int startIndex = (page - 1) * PAGE_SIZE;
        int endIndex   = Math.min(startIndex + PAGE_SIZE, totalCount);

        req.setAttribute("offers",      filtered.subList(startIndex, endIndex));
        req.setAttribute("totalCount",  totalCount);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages",  totalPages);
        req.setAttribute("startIndex",  startIndex);
        req.setAttribute("search",      search);
        req.setAttribute("searchBy",    searchBy);
        req.setAttribute("status",      status);
        req.getRequestDispatcher("/WEB-INF/views/admin/offers.jsp").forward(req, resp);
    }

    private List<Discount> applyFilters(List<Discount> all, String search,
                                        String searchBy, String status) {
        List<Discount> result = new ArrayList<>();
        String q = search.trim().toLowerCase();
        for (Discount o : all) {
            if (!"all".equalsIgnoreCase(status) && !status.equalsIgnoreCase(o.getStatus())) continue;
            if (!q.isEmpty()) {
                boolean match = false;
                switch (searchBy) {
                    case "event": match = contains(o.getEventName(), q);    break;
                    case "code":  match = contains(o.getDiscountCode(), q); break;
                    default:      match = contains(o.getTitle(), q);        break;
                }
                if (!match) continue;
            }
            result.add(o);
        }
        return result;
    }

    private static boolean contains(String f, String q) {
        return f != null && f.toLowerCase().contains(q);
    }

    private static String param(HttpServletRequest req, String name, String def) {
        String v = req.getParameter(name);
        return (v != null && !v.isBlank()) ? v.trim() : def;
    }
}
