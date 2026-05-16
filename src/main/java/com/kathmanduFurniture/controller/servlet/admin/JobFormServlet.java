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

@WebServlet("/admin/job-form")
public class JobFormServlet extends HttpServlet {

    private JobDao jobDao;

    @Override
    public void init() throws ServletException {
        jobDao = new JobDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");
        if (idParam != null && !idParam.isBlank()) {
            try {
                JobVacancy v = jobDao.getVacancyById(Integer.parseInt(idParam.trim()));
                if (v != null) {
                    req.setAttribute("vacancy", v);
                    req.setAttribute("mode", "edit");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/admin/job-vacancies");
                    return;
                }
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/admin/job-vacancies");
                return;
            }
        } else {
            req.setAttribute("vacancy", new JobVacancy());
            req.setAttribute("mode", "add");
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/job-form.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        JobVacancy v = new JobVacancy();
        v.setTitle(req.getParameter("title").trim());
        v.setDepartment(trim(req.getParameter("department")));
        v.setLocation(trim(req.getParameter("location")));
        v.setType(trim(req.getParameter("type")));
        v.setDescription(trim(req.getParameter("description")));
        v.setRequirements(trim(req.getParameter("requirements")));
        v.setStatus(trim(req.getParameter("status")));
        try { v.setSalaryMin(Integer.parseInt(req.getParameter("salaryMin"))); } catch (Exception ignored) {}
        try { v.setSalaryMax(Integer.parseInt(req.getParameter("salaryMax"))); } catch (Exception ignored) {}

        String idParam = req.getParameter("id");
        boolean isEdit = idParam != null && !idParam.isBlank();

        if (isEdit) {
            v.setId(Integer.parseInt(idParam.trim()));
            boolean ok = jobDao.updateVacancy(v);
            resp.sendRedirect(req.getContextPath() + "/admin/job-vacancies?toast=" + (ok ? "updated" : "error"));
        } else {
            boolean ok = jobDao.insertVacancy(v);
            resp.sendRedirect(req.getContextPath() + "/admin/job-vacancies?toast=" + (ok ? "added" : "error"));
        }
    }

    private static String trim(String s) {
        return s != null ? s.trim() : "";
    }
}
