package com.kathmanduFurniture.controller.servlet.admin;

import com.kathmanduFurniture.dao.admin.feedbackDao;
import com.kathmanduFurniture.dao.admin.feedbackDaoImpl;
import com.kathmanduFurniture.entity.user.Feedback;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "FeedbackServlet", value = "/admin/feedback")
public class FeedbackServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private final feedbackDao dao = new feedbackDaoImpl();

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

        String feedbackIdStr = req.getParameter("feedbackId");
        String newStatus     = req.getParameter("status");

        if (feedbackIdStr != null && newStatus != null) {
            try {
                int fid = Integer.parseInt(feedbackIdStr.trim());
                dao.updateStatus(fid, newStatus.trim());
            } catch (NumberFormatException ignored) {}
        }

        String redirectId = req.getParameter("redirectId");
        if (redirectId != null && !redirectId.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/admin/feedback?id=" + redirectId + "&toast=updated");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/feedback?toast=updated");
        }
    }

    private void showDetail(HttpServletRequest req, HttpServletResponse resp, String idParam)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(idParam.trim());
            Feedback fb = dao.getFeedbackById(id);
            if (fb == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/feedback");
                return;
            }
            // auto-mark as Reviewed when opened
            if ("New".equalsIgnoreCase(fb.getStatus())) {
                dao.updateStatus(id, "Reviewed");
                fb.setStatus("Reviewed");
            }
            req.setAttribute("fb", fb);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/feedback");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/feedback-detail.jsp").forward(req, resp);
    }

    private void showList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String search   = param(req, "search",   "");
        String searchBy = param(req, "searchBy", "name");
        String status   = param(req, "status",   "all");

        int page = 1;
        try { page = Math.max(1, Integer.parseInt(req.getParameter("page"))); }
        catch (Exception ignored) {}

        List<Feedback> all      = dao.getAllFeedbacks();
        List<Feedback> filtered = applyFilters(all, search, searchBy, status);

        int totalCount = filtered.size();
        int totalPages = Math.max(1, (int) Math.ceil((double) totalCount / PAGE_SIZE));
        page = Math.min(page, totalPages);
        int startIndex = (page - 1) * PAGE_SIZE;
        int endIndex   = Math.min(startIndex + PAGE_SIZE, totalCount);
        List<Feedback> pageList = filtered.subList(startIndex, endIndex);

        req.setAttribute("feedbacks",   pageList);
        req.setAttribute("totalCount",  totalCount);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages",  totalPages);
        req.setAttribute("startIndex",  startIndex);
        req.setAttribute("search",      search);
        req.setAttribute("searchBy",    searchBy);
        req.setAttribute("status",      status);
        req.getRequestDispatcher("/WEB-INF/views/admin/feedback.jsp").forward(req, resp);
    }

    private List<Feedback> applyFilters(List<Feedback> all, String search,
                                        String searchBy, String status) {
        List<Feedback> result = new ArrayList<>();
        String q = search.trim().toLowerCase();
        for (Feedback f : all) {
            if (!"all".equalsIgnoreCase(status) && !status.equalsIgnoreCase(f.getStatus())) continue;
            if (!q.isEmpty()) {
                boolean match = false;
                switch (searchBy) {
                    case "id":      match = String.valueOf(f.getId()).contains(q); break;
                    case "email":   match = contains(f.getEmail(), q);            break;
                    case "subject": match = contains(f.getSubject(), q);          break;
                    default:        match = contains(f.getUserName(), q);         break;
                }
                if (!match) continue;
            }
            result.add(f);
        }
        return result;
    }

    private void exportCsv(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String search   = param(req, "search",   "");
        String searchBy = param(req, "searchBy", "name");
        String status   = param(req, "status",   "all");

        List<Feedback> filtered = applyFilters(dao.getAllFeedbacks(), search, searchBy, status);

        resp.setContentType("text/csv;charset=UTF-8");
        resp.setHeader("Content-Disposition", "attachment; filename=\"feedback.csv\"");
        PrintWriter pw = resp.getWriter();
        pw.println("ID,Name,Email,Subject,Message,Status,Date");
        for (Feedback f : filtered) {
            pw.printf("%d,\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"%n",
                    f.getId(),
                    esc(f.getUserName()), esc(f.getEmail()),
                    esc(f.getSubject()),  esc(f.getMessage()),
                    esc(f.getStatus()),
                    f.getCreatedAt() != null ? f.getCreatedAt().toString() : "");
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
