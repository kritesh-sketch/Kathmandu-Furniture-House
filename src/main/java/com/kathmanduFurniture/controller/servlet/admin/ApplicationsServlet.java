package com.kathmanduFurniture.controller.servlet.admin;

import com.kathmanduFurniture.dao.admin.JobDao;
import com.kathmanduFurniture.dao.admin.JobDaoImpl;
import com.kathmanduFurniture.entity.user.JobApplication;
import com.kathmanduFurniture.entity.user.JobVacancy;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/applications")
public class ApplicationsServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private JobDao jobDao;

    @Override
    public void init() throws ServletException {
        jobDao = new JobDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String search     = param(req, "search", "");
        String statusFilter = param(req, "status", "all");
        int vacancyId = 0;
        try { vacancyId = Integer.parseInt(req.getParameter("vacancyId")); } catch (Exception ignored) {}

        int page = 1;
        try { page = Math.max(1, Integer.parseInt(req.getParameter("page"))); } catch (Exception ignored) {}

        List<JobApplication> all = jobDao.getAllApplications(vacancyId, statusFilter, search);
        List<JobVacancy> vacancies = jobDao.getAllVacancies();

        int totalCount = all.size();
        int totalPages = Math.max(1, (int) Math.ceil((double) totalCount / PAGE_SIZE));
        page = Math.min(page, totalPages);
        int startIndex = (page - 1) * PAGE_SIZE;
        List<JobApplication> pageList = all.subList(startIndex, Math.min(startIndex + PAGE_SIZE, totalCount));

        req.setAttribute("applications", pageList);
        req.setAttribute("vacancies",    vacancies);
        req.setAttribute("totalCount",   totalCount);
        req.setAttribute("currentPage",  page);
        req.setAttribute("totalPages",   totalPages);
        req.setAttribute("startIndex",   startIndex);
        req.setAttribute("search",       search);
        req.setAttribute("statusFilter", statusFilter);
        req.setAttribute("vacancyId",    vacancyId);
        req.getRequestDispatcher("/WEB-INF/views/admin/applications.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        int id = 0;
        try { id = Integer.parseInt(req.getParameter("id")); } catch (Exception ignored) {}

        if ("status".equals(action) && id > 0) {
            String newStatus = req.getParameter("newStatus");
            jobDao.updateApplicationStatus(id, newStatus);
        }
        resp.sendRedirect(req.getContextPath() + "/admin/applications?toast=updated");
    }

    private static String param(HttpServletRequest req, String name, String def) {
        String v = req.getParameter(name);
        return (v != null && !v.isBlank()) ? v.trim() : def;
    }
}
