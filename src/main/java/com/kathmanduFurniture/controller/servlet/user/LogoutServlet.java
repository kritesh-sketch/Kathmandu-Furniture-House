package com.kathmanduFurniture.controller.servlet.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Handles logout for regular users at {@code /user/logout}.
 * Clears the user session (loggedInUser, cart, wishlist) and redirects to login.
 */
@WebServlet(name = "UserLogoutServlet", value = "/user/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            // Remove all user-specific session attributes before invalidating
            session.removeAttribute("loggedInUser");
            session.removeAttribute("cart");
            session.removeAttribute("wishlist");
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/login");
    }
}
