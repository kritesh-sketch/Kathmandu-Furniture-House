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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CartServlet", value = "/user/cart")
public class CartServlet extends HttpServlet {

    private ProductDao productDao;

    @Override
    public void init() throws ServletException {
        productDao = new ProductDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        @SuppressWarnings("unchecked")
        Map<Integer, Integer> cart = session != null
                ? (Map<Integer, Integer>) session.getAttribute("cart")
                : null;

        List<Map<String, Object>> cartItems = new ArrayList<>();
        double total = 0;

        if (cart != null && !cart.isEmpty()) {
            for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                Product p = productDao.getProductById(entry.getKey());
                if (p != null) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("product",  p);
                    item.put("quantity", entry.getValue());
                    item.put("subtotal", p.getPrice() * entry.getValue());
                    cartItems.add(item);
                    total += p.getPrice() * entry.getValue();
                }
            }
        }

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cartTotal", total);
        request.getRequestDispatcher("/WEB-INF/views/user/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action    = request.getParameter("action");
        String idParam   = request.getParameter("productId");
        HttpSession session = request.getSession(true);

        @SuppressWarnings("unchecked")
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
        if (cart == null) cart = new LinkedHashMap<>();

        if (idParam != null) {
            int productId = Integer.parseInt(idParam);

            if ("add".equals(action)) {
                int qty = 1;
                try { qty = Integer.parseInt(request.getParameter("quantity")); } catch (Exception ignored) {}
                cart.merge(productId, qty, Integer::sum);

            } else if ("update".equals(action)) {
                int qty = 1;
                try { qty = Integer.parseInt(request.getParameter("quantity")); } catch (Exception ignored) {}
                if (qty <= 0) cart.remove(productId);
                else cart.put(productId, qty);

            } else if ("remove".equals(action)) {
                cart.remove(productId);
            }
        } else if ("clear".equals(action)) {
            cart.clear();
        }

        session.setAttribute("cart", cart);
        response.sendRedirect(request.getContextPath() + "/user/cart");
    }
}
