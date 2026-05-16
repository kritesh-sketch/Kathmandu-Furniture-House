package com.kathmanduFurniture.controller.servlet.accessControl;

import com.kathmanduFurniture.dao.user.UserDao;
import com.kathmanduFurniture.dao.user.UserDaoImpl;
import com.kathmanduFurniture.entity.user.User;
import com.kathmanduFurniture.utils.CookieUtil;
import com.kathmanduFurniture.utils.PasswordUtil;
import com.kathmanduFurniture.utils.SessionUtil;

import com.kathmanduFurniture.utils.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/accessControl/login.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String contact = request.getParameter("contact");
        String password = request.getParameter("password");
        String contactValue;

        User user = null;

        // Validate email or phone from userDao
        if (ValidationUtil.isValidEmail(contact)) {
            user = userDao.findByEmail(contact);
        } else if (ValidationUtil.isValidPhone(contact)) {
            user = userDao.findByPhoneNumber(contact);
        } else {
            request.setAttribute("error", "Enter valid email or phone.");
            request.getRequestDispatcher("/WEB-INF/views/accessControl/login.jsp")
                    .forward(request, response);
            return;
        }

        if (user == null) {
            request.setAttribute("error", "Email or phone number cannot be empty");
            request.getRequestDispatcher("/WEB-INF/views/accessControl/login.jsp")
                    .forward(request, response);
            return;
        }

        if (password == null) {
            request.setAttribute("error", "Password cannot be empty");
        }

        if (!PasswordUtil.checkPassword(password, user.getPassword())) {
            request.setAttribute("error", "Invalid Contact or password.");
            request.getRequestDispatcher("/WEB-INF/views/accessControl/login.jsp")
                    .forward(request, response);
            return;
        }

        if (user.getEmail() != null && !user.getEmail().isEmpty()) {
            contactValue = user.getEmail();
        } else {
            contactValue = user.getMobileNumber();
        }

        SessionUtil.setAttribute(request, "user", user);
        CookieUtil.addCookie(response, "Contact", contactValue, 24 * 60 * 60);

        response.sendRedirect(request.getContextPath() + "/landingPage");
    }
}
