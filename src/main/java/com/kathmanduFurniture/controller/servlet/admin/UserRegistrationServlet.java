package com.kathmanduFurniture.controller.servlet.admin;

import com.kathmanduFurniture.dao.admin.VerifyUserDao;
import com.kathmanduFurniture.dao.admin.VerifyUserDaoImpl;
import com.kathmanduFurniture.entity.user.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Servlet for the admin user-management page at {@code /admin/user-registration}.
 * Lists all registered (non-admin) users with search/filter/pagination.
 * POST actions: approve, reject, deactivate, activate a user account.
 */
@WebServlet(name = "UserRegistrationServlet", value = "/admin/user-registration")
public class UserRegistrationServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private static final List<String> VALID_FIELDS = Arrays.asList("name", "id", "email", "phone");

    private VerifyUserDao verifyUserDao;

    @Override
    public void init() throws ServletException {
        verifyUserDao = new VerifyUserDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String search   = param(request, "search",   "");
        String searchBy = param(request, "searchBy", "name");
        String gender   = param(request, "gender",   "all");
        String status   = param(request, "status",   "all");
        if (!VALID_FIELDS.contains(searchBy)) searchBy = "name";

        int page = 1;
        try { page = Integer.parseInt(request.getParameter("page")); } catch (Exception ignored) {}
        if (page < 1) page = 1;

        List<User> allUsers = verifyUserDao.getAllUsers();
        List<User> filtered = applyFilters(allUsers, search, searchBy, gender, status);

        if ("csv".equals(request.getParameter("export"))) {
            exportCsv(response, filtered);
            return;
        }

        int totalCount = filtered.size();
        int totalPages = Math.max(1, (int) Math.ceil((double) totalCount / PAGE_SIZE));
        if (page > totalPages) page = totalPages;

        int start = (page - 1) * PAGE_SIZE;
        int end   = Math.min(start + PAGE_SIZE, totalCount);
        List<User> pageUsers = start < totalCount ? filtered.subList(start, end) : new ArrayList<>();

        // Counts for stat cards
        long countPending  = allUsers.stream().filter(u -> "Pending".equals(u.getStatus())).count();
        long countActive   = allUsers.stream().filter(u -> "Active".equals(u.getStatus())).count();
        long countInactive = allUsers.stream().filter(u -> "Inactive".equals(u.getStatus())).count();

        request.setAttribute("users",         pageUsers);
        request.setAttribute("totalCount",    totalCount);
        request.setAttribute("currentPage",   page);
        request.setAttribute("totalPages",    totalPages);
        request.setAttribute("startIndex",    start);
        request.setAttribute("search",        search);
        request.setAttribute("searchBy",      searchBy);
        request.setAttribute("gender",        gender);
        request.setAttribute("status",        status);
        request.setAttribute("countPending",  countPending);
        request.setAttribute("countActive",   countActive);
        request.setAttribute("countInactive", countInactive);
        request.setAttribute("totalUsers",    allUsers.size());

        request.getRequestDispatcher("/WEB-INF/views/admin/user-registration.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action    = request.getParameter("action");
        String userIdStr = request.getParameter("userId");

        if (userIdStr != null && !userIdStr.isEmpty()) {
            try {
                int userId = Integer.parseInt(userIdStr);
                switch (action != null ? action : "") {
                    case "approve":
                        verifyUserDao.approveUser(userId);
                        response.sendRedirect(request.getContextPath() +
                                "/admin/user-registration?toast=approved");
                        return;
                    case "reject":
                        verifyUserDao.rejectUser(userId);
                        response.sendRedirect(request.getContextPath() +
                                "/admin/user-registration?toast=rejected");
                        return;
                    case "deactivate":
                        verifyUserDao.deactivateUser(userId);
                        response.sendRedirect(request.getContextPath() +
                                "/admin/user-registration?toast=deactivated");
                        return;
                    case "activate":
                        verifyUserDao.activateUser(userId);
                        response.sendRedirect(request.getContextPath() +
                                "/admin/user-registration?toast=activated");
                        return;
                }
            } catch (NumberFormatException ignored) {}
        }

        response.sendRedirect(request.getContextPath() + "/admin/user-registration");
    }

    private List<User> applyFilters(List<User> users, String search, String searchBy,
                                    String gender, String status) {
        String q = search.toLowerCase().trim();
        List<User> result = new ArrayList<>();
        for (User u : users) {
            if (!"all".equals(status) && !status.equals(u.getStatus())) continue;
            if (!"all".equals(gender) && !gender.equals(u.getGender())) continue;
            if (!q.isEmpty()) {
                String val;
                switch (searchBy) {
                    case "email": val = u.getEmail()        != null ? u.getEmail().toLowerCase()        : ""; break;
                    case "phone": val = u.getMobileNumber() != null ? u.getMobileNumber().toLowerCase() : ""; break;
                    case "id":    val = "usr-" + u.getId(); break;
                    default:      val = u.getFullName()     != null ? u.getFullName().toLowerCase()     : "";
                }
                if (!val.contains(q)) continue;
            }
            result.add(u);
        }
        return result;
    }

    private void exportCsv(HttpServletResponse response, List<User> users) throws IOException {
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"users.csv\"");
        PrintWriter pw = response.getWriter();
        pw.println("ID,Name,Email,Phone,DOB,Gender,Status,Registered");
        for (User u : users) {
            pw.printf("USR-%d,\"%s\",\"%s\",\"%s\",%s,%s,%s,%s%n",
                u.getId(),
                u.getFullName(),
                u.getEmail()        != null ? u.getEmail()        : "",
                u.getMobileNumber() != null ? u.getMobileNumber() : "",
                u.getDob()          != null ? u.getDob()          : "",
                u.getGender()       != null ? u.getGender()       : "",
                u.getStatus()       != null ? u.getStatus()       : "",
                u.getCreatedAt()    != null ? u.getCreatedAt().toString() : ""
            );
        }
    }

    private String param(HttpServletRequest req, String name, String def) {
        String v = req.getParameter(name);
        return (v != null && !v.trim().isEmpty()) ? v.trim() : def;
    }
}
