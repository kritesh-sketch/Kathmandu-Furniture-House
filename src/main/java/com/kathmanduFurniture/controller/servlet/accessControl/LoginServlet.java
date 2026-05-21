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

/**
 * LoginServlet handles authentication for both admin and regular users at {@code /login}.
 *
 * GET  — displays the login form (redirects if already logged in).
 * POST — validates credentials and creates a session:
 *   <ul>
 *     <li>Admin email → stores user under {@code session["user"]} and redirects to /admin/dashboard</li>
 *     <li>Regular user → stores user under {@code session["loggedInUser"]} and redirects to /user/home</li>
 *   </ul>
 * Accounts with "Pending" or "Inactive" status are blocked from logging in.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    // Hard-coded admin email — if the login email matches this, admin session is created
    private static final String ADMIN_EMAIL = "admin@kathmandufurniture.com";

    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        userDao = new UserDaoImpl(); // initialise DAO once when servlet loads
    }

    /**
     * Handles GET requests to /login.
     * Redirects already-authenticated users to their respective dashboards.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // If already logged in as admin, go to admin dashboard
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }
        // If already logged in as a regular user, go to user home
        if (session != null && session.getAttribute("loggedInUser") != null) {
            response.sendRedirect(request.getContextPath() + "/user/home");
            return;
        }

        // No active session — show the login form
        request.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(request, response);
    }

    /**
     * Handles POST requests (form submission).
     * Validates the contact (email or phone) and password, then creates a session
     * or returns an error message.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String contact  = request.getParameter("contact");
        String password = request.getParameter("password");

        // Validate that both fields are provided
        if (contact == null || contact.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Please fill in all fields.");
            request.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(request, response);
            return;
        }

        // Determine whether the user typed an email or a phone number and look up accordingly
        User user = contact.contains("@")
                ? userDao.findByEmail(contact.trim())
                : userDao.findByPhoneNumber(contact.trim());

        // Check if user exists and the password matches the stored BCrypt hash
        if (user == null || !PasswordUtil.checkPassword(password, user.getPassword())) {
            request.setAttribute("error", "Invalid email/phone or password.");
            request.setAttribute("contactValue", contact); // re-fill the contact field
            request.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(request, response);
            return;
        }

        // Block accounts awaiting admin approval
        if ("Pending".equals(user.getStatus())) {
            request.setAttribute("error", "Your account is pending admin approval. Please check back later.");
            request.setAttribute("contactValue", contact);
            request.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(request, response);
            return;
        }

        // Block deactivated accounts
        if ("Inactive".equals(user.getStatus())) {
            request.setAttribute("error", "Your account has been deactivated. Please contact support.");
            request.setAttribute("contactValue", contact);
            request.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(request, response);
            return;
        }

        // Invalidate any existing session so a previous user's cart/data is not inherited
        HttpSession old = request.getSession(false);
        if (old != null) old.invalidate();

        // Create a fresh session for the authenticated user
        HttpSession session = request.getSession(true);

        // Admin users are identified by their email address
        if (ADMIN_EMAIL.equalsIgnoreCase(user.getEmail())) {
            session.setAttribute("user", user);                          // admin session key
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            session.setAttribute("loggedInUser", user);                  // regular user session key
            response.sendRedirect(request.getContextPath() + "/user/home");
        }
    }
}
