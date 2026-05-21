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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CheckoutServlet", value = "/user/checkout")
public class CheckoutServlet extends HttpServlet {

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
        HttpSession session = request.getSession(false);
        @SuppressWarnings("unchecked")
        Map<Integer, Integer> cart = session != null
                ? (Map<Integer, Integer>) session.getAttribute("cart") : null;

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/user/cart");
            return;
        }

        List<Map<String, Object>> cartItems = new ArrayList<>();
        double total = 0;
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

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cartTotal", total);
        request.getRequestDispatcher("/WEB-INF/views/user/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        @SuppressWarnings("unchecked")
        Map<Integer, Integer> cart = session != null
                ? (Map<Integer, Integer>) session.getAttribute("cart") : null;

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/user/cart");
            return;
        }

        String fullName         = request.getParameter("fullName");
        String phoneNumber      = request.getParameter("phoneNumber");
        String deliveryLocation = request.getParameter("deliveryLocation");
        String paymentMethod    = request.getParameter("paymentMethod");

        // Get logged-in user id from session
        Object loggedInUser = session.getAttribute("loggedInUser");
        int customerId = 0;
        if (loggedInUser instanceof com.kathmanduFurniture.entity.user.User) {
            customerId = ((com.kathmanduFurniture.entity.user.User) loggedInUser).getId();
        }

        boolean success = true;
        for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
            Product p = productDao.getProductById(entry.getKey());
            if (p == null) continue;

            Order order = new Order();
            order.setFullName(fullName);
            order.setPhoneNumber(phoneNumber);
            order.setDeliveryLocation(deliveryLocation);
            order.setPaymentMethod(paymentMethod);
            order.setOrderType("Normal");
            order.setQuantity(entry.getValue());
            order.setProductId(entry.getKey());
            order.setCustomerId(customerId);
            order.setTotalAmount(p.getPrice() * entry.getValue());

            if (!orderDao.placeOrder(order)) success = false;
        }

        if (success) {
            cart.clear();
            session.setAttribute("cart", cart);
            response.sendRedirect(request.getContextPath() + "/user/home?ordered=true");
        } else {
            response.sendRedirect(request.getContextPath() + "/user/checkout?error=true");
        }
    }
}
