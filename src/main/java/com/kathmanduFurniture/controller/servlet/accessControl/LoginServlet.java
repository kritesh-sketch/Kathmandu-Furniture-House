package com.kathmanduFurniture.controller.servlet.accessControl;

import com.kathmanduFurniture.dao.user.UserDao;
import com.kathmanduFurniture.dao.user.UserDaoImpl;
import com.kathmanduFurniture.entity.user.User;
import com.kathmanduFurniture.utils.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final String ADMIN_EMAIL = "admin@kathmandufurniture.com";

    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        userDao = new UserDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Already logged in as admin
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }
        // Already logged in as regular user
        if (session != null && session.getAttribute("loggedInUser") != null) {
            response.sendRedirect(request.getContextPath() + "/user/home");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String contact  = request.getParameter("contact");
        String password = request.getParameter("password");

        if (contact == null || contact.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Please fill in all fields.");
            request.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(request, response);
            return;
        }

        // Try email first, then phone number
        User user = contact.contains("@")
                ? userDao.findByEmail(contact.trim())
                : userDao.findByPhoneNumber(contact.trim());

        if (user == null || !PasswordUtil.checkPassword(password, user.getPassword())) {
            request.setAttribute("error", "Invalid email/phone or password.");
            request.setAttribute("contactValue", contact);
            request.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(request, response);
            return;
        }

        if ("Pending".equals(user.getStatus())) {
            request.setAttribute("error", "Your account is pending admin approval. Please check back later.");
            request.setAttribute("contactValue", contact);
            request.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(request, response);
            return;
        }

        if ("Inactive".equals(user.getStatus())) {
            request.setAttribute("error", "Your account has been deactivated. Please contact support.");
            request.setAttribute("contactValue", contact);
            request.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(request, response);
            return;
        }

        // Invalidate any existing session so a previous user's cart/data is not inherited
        HttpSession old = request.getSession(false);
        if (old != null) old.invalidate();

        HttpSession session = request.getSession(true);

        if (ADMIN_EMAIL.equalsIgnoreCase(user.getEmail())) {
            session.setAttribute("user", user);
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            session.setAttribute("loggedInUser", user);
            response.sendRedirect(request.getContextPath() + "/user/home");
        }
    }
}
