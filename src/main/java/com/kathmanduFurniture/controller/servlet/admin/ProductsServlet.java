package com.kathmanduFurniture.controller.servlet.admin;

import com.kathmanduFurniture.dao.admin.productDao;
import com.kathmanduFurniture.dao.admin.productDaoImpl;
import com.kathmanduFurniture.entity.user.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ProductsServlet", value = "/admin/products")
public class ProductsServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private final productDao dao = new productDaoImpl();

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
            Product product = dao.fetchProductById(id);
            if (product == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/products");
                return;
            }
            req.setAttribute("product", product);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/products");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/product-detail.jsp").forward(req, resp);
    }

    private void showList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String search   = param(req, "search",   "");
        String category = param(req, "category", "all");

        int page = 1;
        try { page = Math.max(1, Integer.parseInt(req.getParameter("page"))); }
        catch (Exception ignored) {}

        List<Product> all      = dao.fetchAllProducts();
        List<Product> filtered = applyFilters(all, search, category);

        // Derive distinct categories from all products (preserving insertion order)
        List<String> categories = new ArrayList<>();
        for (Product p : all) {
            String cat = p.getCategory();
            if (cat != null && !cat.isBlank() && !categories.contains(cat)) {
                categories.add(cat);
            }
        }

        int totalCount = filtered.size();
        int totalPages = Math.max(1, (int) Math.ceil((double) totalCount / PAGE_SIZE));
        page = Math.min(page, totalPages);
        int startIndex = (page - 1) * PAGE_SIZE;
        int endIndex   = Math.min(startIndex + PAGE_SIZE, totalCount);
        List<Product> pageList = filtered.subList(startIndex, endIndex);

        req.setAttribute("products",    pageList);
        req.setAttribute("totalCount",  totalCount);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages",  totalPages);
        req.setAttribute("startIndex",  startIndex);
        req.setAttribute("search",      search);
        req.setAttribute("category",    category);
        req.setAttribute("categories",  categories);
        req.getRequestDispatcher("/WEB-INF/views/admin/products.jsp").forward(req, resp);
    }

    private List<Product> applyFilters(List<Product> all, String search, String category) {
        List<Product> result = new ArrayList<>();
        String q = search.trim().toLowerCase();
        for (Product p : all) {
            if (!"all".equalsIgnoreCase(category)
                    && !category.equalsIgnoreCase(p.getCategory())) {
                continue;
            }
            if (!q.isEmpty()) {
                boolean match =
                    contains(p.getProductName(),    q) ||
                    contains(p.getCategory(),       q) ||
                    contains(p.getSpecifications(), q) ||
                    contains(p.getAvailability(),   q);
                if (!match) continue;
            }
            result.add(p);
        }
        return result;
    }

    private void exportCsv(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String search   = param(req, "search",   "");
        String category = param(req, "category", "all");

        List<Product> all      = dao.fetchAllProducts();
        List<Product> filtered = applyFilters(all, search, category);

        resp.setContentType("text/csv;charset=UTF-8");
        resp.setHeader("Content-Disposition", "attachment; filename=\"products.csv\"");
        PrintWriter pw = resp.getWriter();
        pw.println("ID,Product Name,Category,Price,Availability,Status,Specifications");
        for (Product p : filtered) {
            pw.printf("%d,\"%s\",\"%s\",%.2f,\"%s\",\"%s\",\"%s\"%n",
                    p.getId(),
                    esc(p.getProductName()),
                    esc(p.getCategory()),
                    p.getPrice(),
                    esc(p.getAvailability()),
                    esc(p.getStatus()),
                    esc(p.getSpecifications()));
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
