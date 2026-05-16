package com.kathmanduFurniture.controller.filter;

import com.kathmanduFurniture.utils.SessionUtil;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebFilter("/*")
public class authenticationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path = uri.substring(contextPath.length());

        // 1. Allow static resources (CSS, JS, images)
        if (path.startsWith("/static/")) {
            chain.doFilter(request, response);
            return;
        }

        // 2. Allow admin access (you can later add admin auth check here)
        if (path.startsWith("/admin/")) {
            chain.doFilter(request, response);
            return;
        }

        // 3. Allow everything else through (login not required)
        chain.doFilter(request, response);

//        boolean isLoggedIn = SessionUtil.getAttribute(req, "user") != null;
//
//        // 3. Auth pages (login/register)
//        boolean isAuthPage =
//                "/login".equals(path) ||
//                        "/register".equals(path);
//
//        // 4. If NOT logged in → block everything except login/register
//        if (!isLoggedIn && !isAuthPage) {
//            res.sendRedirect(contextPath + "/login");
//            return;
//        }
//
//        // 5. If logged in → prevent going back to login/register
//        if (isLoggedIn && isAuthPage) {
//            res.sendRedirect(contextPath + "/topic");
//            return;
//        }
//
//        // 6. ALL /user/* pages are PROTECTED (no bypass!)
//        if (path.startsWith("/user/")) {
//            chain.doFilter(request, response);
//            return;
//        }
//
//        // 7. Allow everything else (protected by default because login already checked)
//        chain.doFilter(request, response);
    }
}