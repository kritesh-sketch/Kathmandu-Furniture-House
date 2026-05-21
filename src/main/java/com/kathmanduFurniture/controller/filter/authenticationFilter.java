package com.kathmanduFurniture.controller.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Set;

/**
 * Servlet filter enforcing authentication and authorisation for every request.
 *
 * <p>Rules applied in order: static resources always allowed; logout always
 * allowed; login/register redirect authenticated users; public browsing always
 * allowed; /admin/** requires admin session; protected user routes require
 * user session; all other paths allowed by default.
 */
@WebFilter("/*")
public class AuthenticationFilter implements Filter {

    // User routes that require a logged-in regular user
    private static final Set<String> PROTECTED_USER_PATHS = Set.of(
        "/user/cart",
        "/user/checkout",
        "/user/wishlist",
        "/user/account",
        "/user/request"
    );

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse res  = (HttpServletResponse) response;

        String uri         = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path        = uri.substring(contextPath.length());

        // 1. Always allow static resources
        if (path.startsWith("/static/")) {
            chain.doFilter(request, response);
            return;
        }

        // 2. Always allow logout (it handles its own logic)
        if (path.equals("/logout") || path.equals("/user/logout")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session   = req.getSession(false);
        boolean     isAdminIn = session != null && session.getAttribute("user") != null;
        boolean     isUserIn  = session != null && session.getAttribute("loggedInUser") != null;

        // 3. Login / register pages — block if already logged in
        if (path.equals("/login")      ||
            path.equals("/register")   ||
            path.equals("/user/login") ||
            path.equals("/join-us")) {
            if (isAdminIn) {
                res.sendRedirect(contextPath + "/admin/dashboard");
            } else if (isUserIn) {
                res.sendRedirect(contextPath + "/user/home");
            } else {
                chain.doFilter(request, response);
            }
            return;
        }

        // 5. Public browsing pages — always allow
        if (path.equals("/user/home")           ||
            path.equals("/user/products")        ||
            path.equals("/user/beds")            ||
            path.equals("/user/sofas")           ||
            path.equals("/user/chairs")          ||
            path.equals("/user/tables")          ||
            path.equals("/user/decor")           ||
            path.equals("/user/storage")         ||
            path.equals("/user/product-details") ||
            path.equals("/user/search")          ||
            path.equals("/user/help")) {
            chain.doFilter(request, response);
            return;
        }

        // 6. Admin routes — require admin session
        if (path.startsWith("/admin/")) {
            if (isAdminIn) {
                chain.doFilter(request, response);
            } else {
                res.sendRedirect(contextPath + "/login?msg=admin");
            }
            return;
        }

        // 7. Protected user routes — require user or admin session
        if (PROTECTED_USER_PATHS.contains(path)) {
            if (isUserIn || isAdminIn) {
                chain.doFilter(request, response);
            } else {
                res.sendRedirect(contextPath + "/login?msg=login");
            }
            return;
        }

        // 8. Everything else — allow
        chain.doFilter(request, response);
    }
}
