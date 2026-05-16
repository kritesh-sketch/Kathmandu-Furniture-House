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
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet(name = "WishlistServlet", value = "/user/wishlist")
public class WishlistServlet extends HttpServlet {

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
        Set<Integer> wishlist = session != null
                ? (Set<Integer>) session.getAttribute("wishlist")
                : null;

        List<Product> wishlistProducts = new ArrayList<>();
        if (wishlist != null) {
            for (int id : wishlist) {
                Product p = productDao.getProductById(id);
                if (p != null) wishlistProducts.add(p);
            }
        }

        request.setAttribute("wishlistProducts", wishlistProducts);
        request.getRequestDispatcher("/WEB-INF/views/user/wishlist.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action  = request.getParameter("action");
        String idParam = request.getParameter("productId");
        HttpSession session = request.getSession(true);

        @SuppressWarnings("unchecked")
        Set<Integer> wishlist = (Set<Integer>) session.getAttribute("wishlist");
        if (wishlist == null) wishlist = new HashSet<>();

        if (idParam != null) {
            int productId = Integer.parseInt(idParam);
            if ("remove".equals(action)) wishlist.remove(productId);
            else wishlist.add(productId);
        }

        session.setAttribute("wishlist", wishlist);
        response.sendRedirect(request.getContextPath() + "/user/wishlist");
    }
}
