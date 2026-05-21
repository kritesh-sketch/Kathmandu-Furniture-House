package com.kathmanduFurniture.controller.servlet.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Redirect shim at {@code /user/login} — forwards to the main login servlet at {@code /login}.
 *
 * This exists so that links within the user section of the site can use the
 * consistent {@code /user/login} path. If the request includes a
 * {@code ?registered=true} parameter (coming from successful registration),
 * it is passed through so the login page can show a success message.
 */
@WebServlet(name = "UserLoginRedirect", value = "/user/login")
public class LoginServlet extends HttpServlet {

    /**
     * Handles GET requests by redirecting to the main /login servlet,
     * preserving the ?registered=true query parameter if present.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String registered = request.getParameter("registered");
        String redirect   = request.getContextPath() + "/login";
        // Append the registered flag so the login page can display a registration success banner
        if ("true".equals(registered)) redirect += "?registered=true";
        response.sendRedirect(redirect);
    }

    /**
     * Handles POST requests (unlikely in practice) by redirecting to the main /login servlet.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/login");
    }
}
