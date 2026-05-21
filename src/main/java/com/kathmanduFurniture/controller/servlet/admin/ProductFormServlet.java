package com.kathmanduFurniture.controller.servlet.admin;

import com.kathmanduFurniture.dao.admin.ProductDao;
import com.kathmanduFurniture.dao.admin.ProductDaoImpl;
import com.kathmanduFurniture.entity.user.Product;
import com.kathmanduFurniture.utils.ImageUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;

/**
 * Servlet for the admin add/edit product form at {@code /admin/product-form}.
 * GET with no {@code id} renders the add form; GET with {@code ?id=N} renders
 * the edit form pre-filled with the existing product and split dimension parts.
 * POST determines add vs. edit from the {@code id} parameter, handles optional
 * image upload, assembles a pipe-separated dimensions string, and delegates to
 * {@link com.kathmanduFurniture.dao.admin.ProductDao}.
 */
@WebServlet(name = "ProductFormServlet", value = "/admin/product-form")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024)
public class ProductFormServlet extends HttpServlet {

    private final ProductDao dao = new ProductDaoImpl();

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
                // Pre-split dimensions (L|B|H) so JSP can populate the 3 separate inputs
                String[] parts = new String[]{"", "", ""};
                if (product.getDimensions() != null && product.getDimensions().contains("|")) {
                    String[] raw = product.getDimensions().split("\\|", -1);
                    for (int i = 0; i < Math.min(raw.length, 3); i++) parts[i] = raw[i].trim();
                }
                req.setAttribute("dimParts", parts);
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/admin/products");
                return;
            }
        } else {
            req.setAttribute("mode", "add");
            req.setAttribute("dimParts", new String[]{"", "", ""});
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

        // Handle image upload
        String imagePath = null;
        try {
            Part imagePart = req.getPart("image");
            imagePath = ImageUtil.uploadImage(imagePart, getServletContext(), "products");
        } catch (Exception ignored) {}

        if (imagePath == null) {
            imagePath = param(req, "existingImage", "");
        }

        // Build pipe-separated dimensions string from the 3 separate inputs
        String lengthCm  = param(req, "lengthCm",  "");
        String breadthCm = param(req, "breadthCm", "");
        String heightCm  = param(req, "heightCm",  "");
        String dimensions = lengthCm + "|" + breadthCm + "|" + heightCm;

        Product product = new Product();
        product.setProductName(param(req, "productName", ""));
        product.setImage(imagePath);
        product.setPrice(price);
        product.setAvailability(param(req, "availability", "In Stock"));
        product.setStatus(param(req, "status", "Active"));
        product.setCategory(param(req, "category", ""));
        product.setColors(param(req, "colors", ""));
        product.setDimensions(dimensions);

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

    /** Returns the trimmed parameter value or {@code def} when absent/blank. */
    private static String param(HttpServletRequest req, String name, String def) {
        String v = req.getParameter(name);
        return (v != null && !v.isBlank()) ? v.trim() : def;
    }

}
