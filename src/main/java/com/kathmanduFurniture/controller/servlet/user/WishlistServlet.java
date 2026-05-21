package com.kathmanduFurniture.controller.servlet.user;

import com.kathmanduFurniture.dao.user.FavoriteDao;
import com.kathmanduFurniture.dao.user.FavoriteDaoImpl;
import com.kathmanduFurniture.entity.user.Product;
import com.kathmanduFurniture.entity.user.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet for the user wishlist page at {@code /user/wishlist}.
 * GET loads all wishlisted products for the logged-in user.
 * POST handles toggle and remove actions, then redirects back to the referer.
 */
@WebServlet(name = "WishlistServlet", value = "/user/wishlist")
public class WishlistServlet extends HttpServlet {

    private FavoriteDao favoriteDao;

    @Override
    public void init() throws ServletException {
        favoriteDao = new FavoriteDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("loggedInUser") : null;

        List<Product> wishlistProducts = new ArrayList<>();
        if (user != null) {
            wishlistProducts = favoriteDao.getWishlistProducts(user.getId());
        }

        request.setAttribute("wishlistProducts", wishlistProducts);
        request.getRequestDispatcher("/WEB-INF/views/user/wishlist.jsp").forward(request, response);
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

        String action  = request.getParameter("action");
        String idParam = request.getParameter("productId");

        if (idParam != null && !idParam.isEmpty()) {
            try {
                int productId = Integer.parseInt(idParam);
                if ("remove".equals(action)) {
                    favoriteDao.removeFromWishlist(user.getId(), productId);
                } else {
                    favoriteDao.toggleWishlist(user.getId(), productId);
                }
            } catch (NumberFormatException ignored) {}
        }

        String referer = request.getHeader("Referer");
        if (referer != null && !referer.contains("/wishlist")) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/user/wishlist");
        }
    }
}
