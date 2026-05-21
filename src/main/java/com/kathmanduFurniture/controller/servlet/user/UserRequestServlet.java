package com.kathmanduFurniture.controller.servlet.user;

import com.kathmanduFurniture.dao.admin.OrderDao;
import com.kathmanduFurniture.dao.admin.OrderDaoImpl;
import com.kathmanduFurniture.dao.user.ProductDao;
import com.kathmanduFurniture.dao.user.ProductDaoImpl;
import com.kathmanduFurniture.entity.user.Order;
import com.kathmanduFurniture.entity.user.Product;
import com.kathmanduFurniture.entity.user.User;
import com.kathmanduFurniture.utils.ImageUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;

/**
 * Servlet for custom furniture order requests at {@code /user/request}.
 * GET renders the request form, optionally pre-filling product details
 * when a {@code productId} query parameter is provided (launched from a product page).
 * POST collects all customisation fields (dimensions, material, design, etc.),
 * handles an optional reference-image upload, and places a "Customize" order.
 */
@WebServlet(name = "UserRequestServlet", value = "/user/request")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024)
public class UserRequestServlet extends HttpServlet {

    private OrderDao   orderDao;
    private ProductDao productDao;

    @Override
    public void init() throws ServletException {
        orderDao   = new OrderDaoImpl();
        productDao = new ProductDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("loggedInUser") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String productIdParam = request.getParameter("productId");
        if (productIdParam != null && !productIdParam.isEmpty()) {
            try {
                Product p = productDao.getProductById(Integer.parseInt(productIdParam));
                if (p != null) request.setAttribute("linkedProduct", p);
            } catch (NumberFormatException ignored) {}
        }

        request.setAttribute("user", user);
        request.getRequestDispatcher("/WEB-INF/views/user/request.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("loggedInUser") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Order order = new Order();
        order.setOrderType("Customize");
        order.setCustomerId(user.getId());
        order.setFullName(p(request, "fullName",  user.getFirstName() + " " + user.getLastName()));
        order.setPhoneNumber(p(request, "phoneNumber", ""));
        order.setDeliveryLocation(p(request, "deliveryLocation", ""));
        order.setFurnitureType(p(request, "furnitureType", ""));
        order.setDesign(p(request, "design", ""));
        order.setMaterial(p(request, "material", ""));
        order.setPurpose(p(request, "purpose", ""));
        order.setBudgetRange(p(request, "budgetRange", ""));
        order.setDeadline(p(request, "deadline", ""));
        order.setInstallationRequired(p(request, "installationRequired", "No"));
        order.setNotes(p(request, "notes", ""));

        String productIdParam = request.getParameter("productId");
        if (productIdParam != null && !productIdParam.isEmpty()) {
            try { order.setProductId(Integer.parseInt(productIdParam)); } catch (NumberFormatException ignored) {}
        }

        try { order.setQuantity(Integer.parseInt(request.getParameter("quantity"))); }
        catch (Exception ignored) { order.setQuantity(1); }

        try { order.setHeight(Double.parseDouble(request.getParameter("height"))); } catch (Exception ignored) {}
        try { order.setWidth(Double.parseDouble(request.getParameter("width")));   } catch (Exception ignored) {}

        try {
            Part imagePart = request.getPart("referenceImage");
            if (imagePart != null && imagePart.getSize() > 0) {
                String savedPath = ImageUtil.uploadImage(imagePart, getServletContext(), "requests");
                if (savedPath != null) order.setReferenceImage(savedPath);
            }
        } catch (Exception ignored) {}

        boolean ok = orderDao.placeOrder(order);
        response.sendRedirect(request.getContextPath() + "/user/request?submitted=" + (ok ? "true" : "error"));
    }

    /** Returns the trimmed parameter value, or {@code def} when absent/blank. */
    private String p(HttpServletRequest req, String name, String def) {
        String v = req.getParameter(name);
        return (v != null && !v.trim().isEmpty()) ? v.trim() : def;
    }
}
