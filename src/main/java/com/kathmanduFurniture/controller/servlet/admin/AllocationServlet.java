package com.kathmanduFurniture.controller.servlet.admin;

import com.kathmanduFurniture.dao.admin.AllocationDao;
import com.kathmanduFurniture.dao.admin.AllocationDaoImpl;
import com.kathmanduFurniture.entity.user.Allocation;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet that manages furniture allocation records at {@code /admin/allocations}.
 *
 * <p>GET requests dispatch on the {@code action} parameter:
 * <ul>
 *   <li>{@code action=new} — renders the allocation creation form</li>
 *   <li>(default)         — renders the paginated, filterable allocation list</li>
 * </ul>
 *
 * <p>POST requests dispatch on the {@code action} parameter:
 * <ul>
 *   <li>{@code create} — persists a new allocation record</li>
 *   <li>{@code return} — marks an existing allocation as returned</li>
 *   <li>{@code delete} — permanently removes an allocation record</li>
 * </ul>
 */
@WebServlet(name = "AllocationServlet", value = "/admin/allocations")
public class AllocationServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private AllocationDao dao;

    @Override
    public void init() throws ServletException {
        dao = new AllocationDaoImpl();
    }

    /**
     * Handles GET requests. Shows the allocation form for {@code action=new};
     * otherwise renders the paginated list with optional search and status filter.
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = param(req, "action", "list");

        // ── New allocation form ──
        if ("new".equals(action)) {
            req.setAttribute("products",    dao.getAllProducts());
            req.setAttribute("activeUsers", dao.getAllActiveUsers());
            req.getRequestDispatcher("/WEB-INF/views/admin/allocation-form.jsp")
               .forward(req, resp);
            return;
        }

        // ── List: read filter / pagination params ──
        String search = param(req, "search", "");
        String status = param(req, "status", "all");

        int page = 1;
        try { page = Integer.parseInt(req.getParameter("page")); } catch (Exception ignored) {}
        if (page < 1) page = 1;

        // Promote any "Issued" record whose expected-return date has passed to "Overdue"
        // before filtering — keeps statuses accurate without needing a scheduled job.
        List<Allocation> all = dao.getAllAllocations();
        Date today = new Date(System.currentTimeMillis());
        for (Allocation a : all) {
            if ("Issued".equals(a.getStatus()) && a.getExpectedReturnDate() != null
                    && a.getExpectedReturnDate().before(today)) {
                a.setStatus("Overdue");
            }
        }

        // ── Apply search + status filter, then paginate ──
        List<Allocation> filtered  = filter(all, search, status);
        int total      = filtered.size();
        int totalPages = Math.max(1, (int) Math.ceil((double) total / PAGE_SIZE));
        if (page > totalPages) page = totalPages;
        int start = (page - 1) * PAGE_SIZE;
        int end   = Math.min(start + PAGE_SIZE, total);
        List<Allocation> pageItems = start < total ? filtered.subList(start, end) : new ArrayList<>();

        // ── Status summary counts used by the filter chips in the view ──
        long countIssued   = all.stream().filter(a -> "Issued".equals(a.getStatus())).count();
        long countReturned = all.stream().filter(a -> "Returned".equals(a.getStatus())).count();
        long countOverdue  = all.stream().filter(a -> "Overdue".equals(a.getStatus())).count();

        req.setAttribute("allocations",   pageItems);
        req.setAttribute("totalCount",    total);
        req.setAttribute("currentPage",   page);
        req.setAttribute("totalPages",    totalPages);
        req.setAttribute("startIndex",    start);
        req.setAttribute("search",        search);
        req.setAttribute("status",        status);
        req.setAttribute("totalAll",      all.size());
        req.setAttribute("countIssued",   countIssued);
        req.setAttribute("countReturned", countReturned);
        req.setAttribute("countOverdue",  countOverdue);

        req.getRequestDispatcher("/WEB-INF/views/admin/allocations.jsp")
           .forward(req, resp);
    }

    /**
     * Handles POST requests. Dispatches on the {@code action} parameter to
     * create, return, or delete an allocation, then redirects to the list
     * with a {@code toast} query parameter indicating the outcome.
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = param(req, "action", "");

        switch (action) {

            case "create": {
                // ── Build Allocation from submitted form fields ──
                Allocation a = new Allocation();
                try {
                    a.setProductId(Integer.parseInt(req.getParameter("productId")));
                } catch (NumberFormatException e) {
                    resp.sendRedirect(req.getContextPath() + "/admin/allocations?toast=error");
                    return;
                }

                String allocType = param(req, "allocType", "user");
                if ("user".equals(allocType)) {
                    try {
                        a.setAllocatedToUserId(Integer.parseInt(req.getParameter("userId")));
                    } catch (NumberFormatException ignored) {}
                } else {
                    a.setDepartment(param(req, "department", ""));
                }

                try { a.setQuantity(Integer.parseInt(req.getParameter("quantity"))); }
                catch (NumberFormatException e) { a.setQuantity(1); }

                String issueDateStr = req.getParameter("issueDate");
                String expRetStr    = req.getParameter("expectedReturnDate");
                try { a.setIssueDate(Date.valueOf(issueDateStr)); } catch (Exception ignored) {}
                try {
                    if (expRetStr != null && !expRetStr.isEmpty())
                        a.setExpectedReturnDate(Date.valueOf(expRetStr));
                } catch (Exception ignored) {}
                a.setNotes(req.getParameter("notes"));

                boolean ok = dao.createAllocation(a);
                resp.sendRedirect(req.getContextPath() + "/admin/allocations?toast=" + (ok ? "created" : "error"));
                return;
            }

            case "return": {
                // ── Mark the allocation as returned with today's date ──
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    boolean ok = dao.markReturned(id, new Date(System.currentTimeMillis()));
                    resp.sendRedirect(req.getContextPath() + "/admin/allocations?toast=" + (ok ? "returned" : "error"));
                } catch (NumberFormatException e) {
                    resp.sendRedirect(req.getContextPath() + "/admin/allocations?toast=error");
                }
                return;
            }

            case "delete": {
                // ── Permanently remove the allocation record ──
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    boolean ok = dao.deleteAllocation(id);
                    resp.sendRedirect(req.getContextPath() + "/admin/allocations?toast=" + (ok ? "deleted" : "error"));
                } catch (NumberFormatException e) {
                    resp.sendRedirect(req.getContextPath() + "/admin/allocations?toast=error");
                }
                return;
            }
        }

        resp.sendRedirect(req.getContextPath() + "/admin/allocations");
    }

    /**
     * Filters a list of allocations by status and a keyword matched against
     * product name, allocated-to user name, and department.
     *
     * @param list   the full allocation list to filter
     * @param search keyword to match (empty string disables keyword filtering)
     * @param status status value to keep, or {@code "all"} to keep every status
     * @return a new list containing only the matching allocations
     */
    private List<Allocation> filter(List<Allocation> list, String search, String status) {
        String q = search.toLowerCase().trim();
        List<Allocation> result = new ArrayList<>();
        for (Allocation a : list) {
            if (!"all".equals(status) && !status.equals(a.getStatus())) continue;
            if (!q.isEmpty()) {
                String combined = (a.getProductName()        != null ? a.getProductName().toLowerCase()        : "") + " "
                                + (a.getAllocatedToUserName() != null ? a.getAllocatedToUserName().toLowerCase() : "") + " "
                                + (a.getDepartment()         != null ? a.getDepartment().toLowerCase()         : "");
                if (!combined.contains(q)) continue;
            }
            result.add(a);
        }
        return result;
    }

    /**
     * Returns the trimmed value of the named request parameter,
     * or {@code defaultValue} when the parameter is absent or blank.
     *
     * @param req          the HTTP request
     * @param name         parameter name
     * @param defaultValue fallback when the parameter is absent or blank
     * @return trimmed parameter value, or the default
     */
    private String param(HttpServletRequest req, String name, String defaultValue) {
        String v = req.getParameter(name);
        return (v != null && !v.trim().isEmpty()) ? v.trim() : defaultValue;
    }
}
