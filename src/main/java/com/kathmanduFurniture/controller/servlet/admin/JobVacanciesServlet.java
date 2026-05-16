package com.kathmanduFurniture.controller.servlet.admin;

import com.kathmanduFurniture.dao.admin.JobDao;
import com.kathmanduFurniture.dao.admin.JobDaoImpl;
import com.kathmanduFurniture.entity.user.JobVacancy;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/job-vacancies")
public class JobVacanciesServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private JobDao jobDao;

    @Override
    public void init() throws ServletException {
        jobDao = new JobDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int page = 1;
        try { page = Math.max(1, Integer.parseInt(req.getParameter("page"))); } catch (Exception ignored) {}

        List<JobVacancy> all = jobDao.getAllVacancies();
        int totalCount = all.size();
        int totalPages = Math.max(1, (int) Math.ceil((double) totalCount / PAGE_SIZE));
        page = Math.min(page, totalPages);
        int startIndex = (page - 1) * PAGE_SIZE;
        List<JobVacancy> pageList = all.subList(startIndex, Math.min(startIndex + PAGE_SIZE, totalCount));

        req.setAttribute("vacancies",   pageList);
        req.setAttribute("totalCount",  totalCount);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages",  totalPages);
        req.setAttribute("startIndex",  startIndex);
        req.getRequestDispatcher("/WEB-INF/views/admin/job-vacancies.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        int id = 0;
        try { id = Integer.parseInt(req.getParameter("id")); } catch (Exception ignored) {}

        if ("delete".equals(action) && id > 0) {
            jobDao.deleteVacancy(id);
            resp.sendRedirect(req.getContextPath() + "/admin/job-vacancies?toast=deleted");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/job-vacancies");
        }
    }
}
