package com.kathmanduFurniture.controller.servlet.accessControl;

//import com.kathmanduFurniture.utils.CookieUtil;
//import com.kathmanduFurniture.utils.SessionUtil;

import com.kathmanduFurniture.utils.CookieUtil;
import com.kathmanduFurniture.utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Handles logout for both users and admins at {@code /logout}.
 * Invalidates the current session, removes the contact cookie,
 * and redirects to the login page.
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        SessionUtil.invalidateSession(request);
        CookieUtil.deleteCookie(response, "contactValue");
        response.sendRedirect(request.getContextPath() + "/login");
    }
}
