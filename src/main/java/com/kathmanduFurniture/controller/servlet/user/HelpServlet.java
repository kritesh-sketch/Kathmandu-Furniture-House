package com.kathmanduFurniture.controller.servlet.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Servlet for the help/contact page at {@code /user/help}.
 * No data loading required — the JSP is a static contact form.
 */
@WebServlet(name = "HelpServlet", value = "/user/help")
public class HelpServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/user/help.jsp").forward(request, response);
    }
}
