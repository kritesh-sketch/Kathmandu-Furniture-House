package com.kathmanduFurniture.controller.servlet.user;

import com.kathmanduFurniture.dao.user.ProductDao;
import com.kathmanduFurniture.dao.user.ProductDaoImpl;
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

@WebServlet(name = "ProductDetailsServlet", value = "/user/product-details")
public class ProductDetailsServlet extends HttpServlet {

    private ProductDao productDao;

    @Override
    public void init() throws ServletException {
        productDao = new ProductDaoImpl();
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
        String action    = request.getParameter("action");
        String idParam   = request.getParameter("productId");
        if (idParam == null) { response.sendRedirect(request.getContextPath() + "/user/products"); return; }

        int productId = Integer.parseInt(idParam);
        HttpSession session = request.getSession(true);

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
        }
    }
}
