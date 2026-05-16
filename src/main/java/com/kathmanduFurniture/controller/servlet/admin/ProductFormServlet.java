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

@WebServlet(name = "ProductFormServlet", value = "/admin/product-form")
public class ProductFormServlet extends HttpServlet {

    private final productDao dao = new productDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");
        if (idParam != null && !idParam.isBlank()) {
            try {
                int id = Integer.parseInt(idParam.trim());
                Product product = dao.fetchProductById(id);
                if (product == null) {
                    resp.sendRedirect(req.getContextPath() + "/admin/products");
                    return;
                }
                req.setAttribute("product", product);
                req.setAttribute("mode", "edit");
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/admin/products");
                return;
            }
        } else {
            req.setAttribute("mode", "add");
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/product-form.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");

        double price = 0;
        try { price = Double.parseDouble(req.getParameter("price")); }
        catch (Exception ignored) {}

        double rating = 0;
        try {
            rating = Double.parseDouble(req.getParameter("rating"));
            rating = Math.max(0.0, Math.min(5.0, rating));
        } catch (Exception ignored) {}

        String specs = req.getParameter("specifications");

        Product product = new Product();
        product.setProductName(param(req, "productName", ""));
        product.setImage(param(req, "image", ""));
        product.setPrice(price);
        product.setAvailability(param(req, "availability", "In Stock"));
        product.setSpecifications(specs != null ? specs : "");
        product.setStatus(param(req, "status", "Active"));
        product.setCategory(param(req, "category", ""));
        product.setColors(param(req, "colors", ""));
        product.setRating(rating);

        boolean isEdit = idParam != null && !idParam.isBlank();
        boolean success;

        if (isEdit) {
            try { product.setId(Integer.parseInt(idParam.trim())); }
            catch (NumberFormatException ignored) {}
            success = dao.updateProduct(product);
        } else {
            success = dao.addProduct(product);
        }

        String toast = success ? (isEdit ? "updated" : "added") : "error";
        resp.sendRedirect(req.getContextPath() + "/admin/products?toast=" + toast);
    }

    private static String param(HttpServletRequest req, String name, String def) {
        String v = req.getParameter(name);
        return (v != null && !v.isBlank()) ? v.trim() : def;
    }
}
