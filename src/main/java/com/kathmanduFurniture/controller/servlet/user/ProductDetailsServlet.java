package com.kathmanduFurniture.controller.servlet.user;

import com.kathmanduFurniture.dao.admin.OrderDao;
import com.kathmanduFurniture.dao.admin.OrderDaoImpl;
import com.kathmanduFurniture.dao.user.ProductDao;
import com.kathmanduFurniture.dao.user.ProductDaoImpl;
import com.kathmanduFurniture.entity.user.Order;
import com.kathmanduFurniture.entity.user.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * Servlet for the product detail page at {@code /user/product-details}.
 * GET loads product data and wishlist state for display.
 * POST handles addToCart, toggleWishlist, and customOrder actions.
 * Unauthenticated POST requests are redirected to the login page.
 */
@WebServlet(name = "ProductDetailsServlet", value = "/user/product-details")
public class ProductDetailsServlet extends HttpServlet {

    private ProductDao productDao;
    private OrderDao   orderDao;

    @Override
    public void init() throws ServletException {
        productDao = new ProductDaoImpl();
        orderDao   = new OrderDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/user/products");
            return;
        }
        try {
            int id = Integer.parseInt(idParam);
            Product product = productDao.getProductById(id);
            if (product == null) {
                response.sendRedirect(request.getContextPath() + "/user/products");
                return;
            }
            HttpSession session = request.getSession(false);
            Set<Integer> wishlist = session != null ? (Set<Integer>) session.getAttribute("wishlist") : null;
            boolean inWishlist = wishlist != null && wishlist.contains(id);
            request.setAttribute("product", product);
            request.setAttribute("inWishlist", inWishlist);
            request.getRequestDispatcher("/WEB-INF/views/user/product-details.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/user/products");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Guest users cannot perform cart / wishlist / order actions
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login?msg=login");
            return;
        }

        String action    = request.getParameter("action");
        String idParam   = request.getParameter("productId");
        if (idParam == null) { response.sendRedirect(request.getContextPath() + "/user/products"); return; }

        int productId = Integer.parseInt(idParam);

        if ("addToCart".equals(action)) {
            int qty = 1;
            try { qty = Integer.parseInt(request.getParameter("quantity")); } catch (Exception ignored) {}
            if (qty < 1) qty = 1;

            @SuppressWarnings("unchecked")
            Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
            if (cart == null) cart = new HashMap<>();
            cart.merge(productId, qty, Integer::sum);
            session.setAttribute("cart", cart);
            response.sendRedirect(request.getContextPath() + "/user/cart");

        } else if ("toggleWishlist".equals(action)) {
            @SuppressWarnings("unchecked")
            Set<Integer> wishlist = (Set<Integer>) session.getAttribute("wishlist");
            if (wishlist == null) wishlist = new HashSet<>();
            if (wishlist.contains(productId)) wishlist.remove(productId);
            else wishlist.add(productId);
            session.setAttribute("wishlist", wishlist);
            response.sendRedirect(request.getContextPath() + "/user/product-details?id=" + productId);

        } else if ("customOrder".equals(action)) {
            Order order = new Order();
            order.setFullName(request.getParameter("fullName"));
            order.setPhoneNumber(request.getParameter("phoneNumber"));
            order.setDeliveryLocation(request.getParameter("deliveryLocation"));
            order.setFurnitureType(request.getParameter("furnitureType"));
            order.setMaterial(request.getParameter("material"));
            order.setDesign(request.getParameter("design"));
            order.setBudgetRange(request.getParameter("budgetRange"));
            order.setDeadline(request.getParameter("deadline"));
            order.setInstallationRequired(request.getParameter("installationRequired"));
            order.setPaymentMethod(request.getParameter("paymentMethod"));
            order.setPurpose(request.getParameter("purpose"));
            order.setNotes(request.getParameter("notes"));
            order.setOrderType("Customize");
            order.setId(productId); // reused as product_id in placeOrder

            try {
                String h = request.getParameter("height");
                if (h != null && !h.isBlank()) order.setHeight(Double.parseDouble(h));
                String w = request.getParameter("width");
                if (w != null && !w.isBlank()) order.setWidth(Double.parseDouble(w));
                String s = request.getParameter("size");
                if (s != null && !s.isBlank()) order.setSize(Integer.parseInt(s));
                String q = request.getParameter("quantity");
                if (q != null && !q.isBlank()) order.setQuantity(Integer.parseInt(q));
            } catch (NumberFormatException ignored) {}

            boolean success = orderDao.placeOrder(order);
            String redirect = request.getContextPath() + "/user/product-details?id=" + productId;
            response.sendRedirect(redirect + (success ? "&ordered=true" : "&ordered=false"));
        }
    }
}
