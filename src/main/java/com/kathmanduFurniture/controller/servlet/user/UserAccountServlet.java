package com.kathmanduFurniture.controller.servlet.user;

import com.kathmanduFurniture.dao.user.UserDao;
import com.kathmanduFurniture.dao.user.UserDaoImpl;
import com.kathmanduFurniture.entity.user.Order;
import com.kathmanduFurniture.entity.user.User;
import com.kathmanduFurniture.utils.ImageUtil;
import com.kathmanduFurniture.utils.PasswordUtil;
import com.kathmanduFurniture.utils.SessionUtil;
import com.kathmanduFurniture.utils.ValidationUtil;

import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;

/**
 * Servlet for the user account/profile page at {@code /user/account}.
 * Supports three POST actions dispatched via the {@code action} parameter:
 * <ul>
 *   <li>{@code profile}  — updates name, email, phone, DOB, gender</li>
 *   <li>{@code password} — validates current password then sets a new BCrypt hash</li>
 *   <li>{@code image}    — uploads a new profile photo via multipart form</li>
 * </ul>
 * All successful changes are also reflected in the session user object
 * so the header/nav shows updated data without re-login.
 */
@WebServlet("/user/account")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024)
public class UserAccountServlet extends HttpServlet {

    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        userDao = new UserDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User sessionUser = (User) SessionUtil.getAttribute(req, "loggedInUser");
        if (sessionUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Always re-fetch from DB so the page shows the latest data, not stale session data
        User user = userDao.findById(sessionUser.getId());
        if (user == null) user = sessionUser;

        req.setAttribute("user", user);

        // Pre-split DOB (stored as "YYYY-MM-DD") for the three-dropdown date-of-birth widget
        if (user.getDob() != null && !user.getDob().isEmpty()) {
            try {
                String[] parts = user.getDob().split("-");
                if (parts.length == 3) {
                    req.setAttribute("dobYear",  Integer.parseInt(parts[0]));
                    req.setAttribute("dobMonth", Integer.parseInt(parts[1]));
                    req.setAttribute("dobDay",   Integer.parseInt(parts[2]));
                }
            } catch (Exception ignored) {}
        }

        List<Order> orders = userDao.getOrdersByCustomerId(sessionUser.getId());
        req.setAttribute("orders", orders);

        // Compute summary stats for the account dashboard cards
        int pending = 0, delivered = 0;
        double totalSpent = 0;
        for (Order o : orders) {
            String s = o.getStatus() != null ? o.getStatus().toLowerCase() : "";
            if (s.equals("pending") || s.equals("processing") || s.equals("confirmed")) pending++;
            if (s.equals("delivered")) delivered++;
            if (!s.equals("cancelled") && o.getTotalAmount() != null) totalSpent += o.getTotalAmount();
        }
        req.setAttribute("totalOrders",   orders.size());
        req.setAttribute("pendingOrders", pending);
        req.setAttribute("deliveredOrders", delivered);
        req.setAttribute("totalSpent",    totalSpent);

        req.getRequestDispatcher("/WEB-INF/views/user/account.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User sessionUser = (User) SessionUtil.getAttribute(req, "loggedInUser");
        if (sessionUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        int id = sessionUser.getId();

        if ("profile".equals(action)) {
            String firstName    = req.getParameter("firstName").trim();
            String lastName     = req.getParameter("lastName").trim();
            String email        = req.getParameter("email") != null ? req.getParameter("email").trim() : "";
            String mobileNumber = req.getParameter("mobileNumber") != null ? req.getParameter("mobileNumber").trim() : "";
            String birthMonth   = req.getParameter("birthMonth");
            String birthDay     = req.getParameter("birthDay");
            String birthYear    = req.getParameter("birthYear");
            String dob = "";
            if (birthYear != null && !birthYear.isBlank() && birthMonth != null && !birthMonth.isBlank() && birthDay != null && !birthDay.isBlank()) {
                try {
                    dob = String.format("%s-%02d-%02d", birthYear.trim(),
                            Integer.parseInt(birthMonth.trim()), Integer.parseInt(birthDay.trim()));
                } catch (NumberFormatException ignored) {}
            }
            String gender = req.getParameter("gender") != null ? req.getParameter("gender").trim() : "";

            // Check email uniqueness (ignore current user)
            if (!email.isEmpty()) {
                User existing = userDao.findByEmail(email);
                if (existing != null && existing.getId() != id) {
                    resp.sendRedirect(req.getContextPath() + "/user/account?toast=email_taken");
                    return;
                }
            }

            // Check phone uniqueness (ignore current user)
            if (!mobileNumber.isEmpty()) {
                User existing = userDao.findByPhoneNumber(mobileNumber);
                if (existing != null && existing.getId() != id) {
                    resp.sendRedirect(req.getContextPath() + "/user/account?toast=phone_taken");
                    return;
                }
            }

            boolean ok = userDao.updateProfile(id, firstName, lastName, email, mobileNumber, dob, gender);
            if (ok) {
                sessionUser.setFirstName(firstName);
                sessionUser.setLastName(lastName);
                sessionUser.setEmail(email);
                sessionUser.setMobileNumber(mobileNumber);
                sessionUser.setDob(dob);
                sessionUser.setGender(gender);
                SessionUtil.setAttribute(req, "loggedInUser", sessionUser);
                resp.sendRedirect(req.getContextPath() + "/user/account?toast=profile");
            } else {
                resp.sendRedirect(req.getContextPath() + "/user/account?toast=error");
            }

        } else if ("password".equals(action)) {
            String currentPassword = req.getParameter("currentPassword");
            String newPassword     = req.getParameter("newPassword");
            String confirmPassword = req.getParameter("confirmPassword");

            User fresh = userDao.findById(id);
            if (fresh == null || !PasswordUtil.checkPassword(currentPassword, fresh.getPassword())) {
                resp.sendRedirect(req.getContextPath() + "/user/account?toast=wrongpw");
                return;
            }
            if (!ValidationUtil.isValidPassword(newPassword)) {
                resp.sendRedirect(req.getContextPath() + "/user/account?toast=weakpw");
                return;
            }
            if (!newPassword.equals(confirmPassword)) {
                resp.sendRedirect(req.getContextPath() + "/user/account?toast=mismatch");
                return;
            }
            boolean ok = userDao.updatePassword(id, PasswordUtil.getHashPassword(newPassword));
            resp.sendRedirect(req.getContextPath() + "/user/account?toast=" + (ok ? "password" : "error"));

        } else if ("image".equals(action)) {
            Part filePart = req.getPart("profileImage");
            if (filePart != null && filePart.getSize() > 0) {
                String savedPath = ImageUtil.uploadImage(filePart, getServletContext(), "profile");
                if (savedPath != null) {
                    boolean ok = userDao.updateImage(id, savedPath);
                    if (ok) {
                        sessionUser.setImage(savedPath);
                        SessionUtil.setAttribute(req, "loggedInUser", sessionUser);
                        resp.sendRedirect(req.getContextPath() + "/user/account?toast=image");
                        return;
                    }
                }
            }
            resp.sendRedirect(req.getContextPath() + "/user/account?toast=error");

        } else {
            resp.sendRedirect(req.getContextPath() + "/user/account");
        }
    }
}
