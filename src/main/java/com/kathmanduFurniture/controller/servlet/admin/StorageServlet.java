package com.kathmanduFurniture.controller.servlet.admin;

import com.kathmanduFurniture.dao.admin.StorageDao;
import com.kathmanduFurniture.dao.admin.StorageDaoImpl;
import com.kathmanduFurniture.entity.user.StorageAssignment;
import com.kathmanduFurniture.entity.user.StorageLocation;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

/**
 * Servlet for the admin warehouse storage management page at {@code /admin/storage}.
 *
 * <p>GET dispatches on the {@code action} parameter:
 * <ul>
 *   <li>{@code newLocation}  — renders the add-location form</li>
 *   <li>{@code editLocation} — renders the edit-location form pre-filled with an existing record</li>
 *   <li>{@code assign}       — renders the product-to-location assignment form</li>
 *   <li>(default)            — renders the paginated locations/assignments list with optional search</li>
 * </ul>
 *
 * <p>POST dispatches on the {@code action} parameter:
 * createLocation, updateLocation, deleteLocation, createAssignment, deleteAssignment.
 */
@WebServlet(name = "StorageServlet", value = "/admin/storage")
public class StorageServlet extends HttpServlet {

    private StorageDao dao;

    @Override
    public void init() throws ServletException {
        dao = new StorageDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = param(req, "action", "list");

        switch (action) {
            case "newLocation":
                req.getRequestDispatcher("/WEB-INF/views/admin/storage-form.jsp")
                   .forward(req, resp);
                return;

            case "editLocation": {
                int id = intParam(req, "id", 0);
                StorageLocation loc = dao.getLocationById(id);
                if (loc == null) { resp.sendRedirect(req.getContextPath() + "/admin/storage"); return; }
                req.setAttribute("location", loc);
                req.getRequestDispatcher("/WEB-INF/views/admin/storage-form.jsp")
                   .forward(req, resp);
                return;
            }

            case "assign": {
                int locationId = intParam(req, "locationId", 0);
                req.setAttribute("products",  dao.getAllProducts());
                req.setAttribute("locations", dao.getAllLocations());
                req.setAttribute("selectedLocationId", locationId);
                req.getRequestDispatcher("/WEB-INF/views/admin/storage-assign-form.jsp")
                   .forward(req, resp);
                return;
            }

            default: // list
                String tab    = param(req, "tab", "locations");
                String search = param(req, "search", "");

                List<StorageLocation> locations = dao.getAllLocations();
                List<StorageAssignment> assignments = dao.getAllAssignments();

                if (!search.isEmpty()) {
                    String q = search.toLowerCase();
                    locations  = locations.stream()
                        .filter(l -> l.getZone().toLowerCase().contains(q)
                                  || l.getRackNumber().toLowerCase().contains(q)
                                  || (l.getDescription() != null && l.getDescription().toLowerCase().contains(q)))
                        .collect(java.util.stream.Collectors.toList());
                    assignments = assignments.stream()
                        .filter(a -> a.getProductName().toLowerCase().contains(q)
                                  || a.getZone().toLowerCase().contains(q)
                                  || a.getRackNumber().toLowerCase().contains(q))
                        .collect(java.util.stream.Collectors.toList());
                }

                req.setAttribute("locations",       locations);
                req.setAttribute("assignments",     assignments);
                req.setAttribute("tab",             tab);
                req.setAttribute("search",          search);
                req.setAttribute("totalLocations",  dao.getAllLocations().size());
                req.setAttribute("countAvailable",  dao.countByStatus("Available"));
                req.setAttribute("countFull",       dao.countByStatus("Full"));
                req.setAttribute("countInactive",   dao.countByStatus("Inactive"));
                req.setAttribute("totalItems",      dao.totalAssignedItems());

                req.getRequestDispatcher("/WEB-INF/views/admin/storage.jsp")
                   .forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = param(req, "action", "");

        switch (action) {
            case "createLocation": {
                StorageLocation loc = buildLocation(req);
                boolean ok = dao.createLocation(loc);
                resp.sendRedirect(req.getContextPath() + "/admin/storage?toast=" + (ok ? "locCreated" : "error"));
                return;
            }
            case "updateLocation": {
                StorageLocation loc = buildLocation(req);
                loc.setId(intParam(req, "id", 0));
                boolean ok = dao.updateLocation(loc);
                resp.sendRedirect(req.getContextPath() + "/admin/storage?toast=" + (ok ? "locUpdated" : "error"));
                return;
            }
            case "deleteLocation": {
                boolean ok = dao.deleteLocation(intParam(req, "id", 0));
                resp.sendRedirect(req.getContextPath() + "/admin/storage?toast=" + (ok ? "locDeleted" : "error"));
                return;
            }
            case "createAssignment": {
                StorageAssignment a = new StorageAssignment();
                a.setProductId(intParam(req, "productId", 0));
                a.setStorageLocationId(intParam(req, "locationId", 0));
                a.setQuantity(Math.max(1, intParam(req, "quantity", 1)));
                String d = param(req, "assignedDate", "");
                try { a.setAssignedDate(Date.valueOf(d)); } catch (Exception e) {
                    a.setAssignedDate(new Date(System.currentTimeMillis()));
                }
                a.setNotes(param(req, "notes", ""));
                boolean ok = dao.createAssignment(a);
                resp.sendRedirect(req.getContextPath() + "/admin/storage?tab=assignments&toast=" + (ok ? "assigned" : "error"));
                return;
            }
            case "deleteAssignment": {
                boolean ok = dao.deleteAssignment(intParam(req, "id", 0));
                resp.sendRedirect(req.getContextPath() + "/admin/storage?tab=assignments&toast=" + (ok ? "assignDeleted" : "error"));
                return;
            }
        }
        resp.sendRedirect(req.getContextPath() + "/admin/storage");
    }

    /** Builds a StorageLocation from POST parameters. Does not set the id field. */
    private StorageLocation buildLocation(HttpServletRequest req) {
        StorageLocation loc = new StorageLocation();
        loc.setZone(param(req, "zone", ""));
        loc.setRackNumber(param(req, "rackNumber", ""));
        loc.setDescription(param(req, "description", ""));
        loc.setCapacity(intParam(req, "capacity", 0));
        loc.setStatus(param(req, "status", "Available"));
        return loc;
    }

    private String param(HttpServletRequest req, String name, String def) {
        String v = req.getParameter(name);
        return (v != null && !v.trim().isEmpty()) ? v.trim() : def;
    }

    private int intParam(HttpServletRequest req, String name, int def) {
        try { return Integer.parseInt(req.getParameter(name)); } catch (Exception e) { return def; }
    }
}
