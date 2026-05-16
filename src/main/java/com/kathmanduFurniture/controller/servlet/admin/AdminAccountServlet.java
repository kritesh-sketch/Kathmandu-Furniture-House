package com.kathmanduFurniture.controller.servlet.admin;

import com.kathmanduFurniture.dao.admin.AdminAccountDao;
import com.kathmanduFurniture.dao.admin.AdminAccountDaoImpl;
import com.kathmanduFurniture.entity.user.User;
import com.kathmanduFurniture.utils.ImageUtil;
import com.kathmanduFurniture.utils.PasswordUtil;
import com.kathmanduFurniture.utils.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Part;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@MultipartConfig(maxFileSize = 5 * 1024 * 1024)
@WebServlet("/admin/account")
public class AdminAccountServlet extends HttpServlet {

    private AdminAccountDao accountDao;

    @Override
    public void init() throws ServletException {
        accountDao = new AdminAccountDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User sessionUser = (User) SessionUtil.getAttribute(request, "user");

        User admin = sessionUser != null ? accountDao.findById(sessionUser.getId()) : null;
        if (admin == null) admin = sessionUser;

        request.setAttribute("admin", admin);
        request.getRequestDispatcher("/WEB-INF/views/admin/account.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User sessionUser = (User) SessionUtil.getAttribute(request, "user");

        String action = request.getParameter("action");
        int id = sessionUser.getId();

        if ("profile".equals(action)) {
            String firstName    = request.getParameter("firstName").trim();
            String lastName     = request.getParameter("lastName").trim();
            String email        = request.getParameter("email").trim();
            String mobileNumber = request.getParameter("mobileNumber").trim();
            String dob          = request.getParameter("dob") != null ? request.getParameter("dob").trim() : "";
            String gender       = request.getParameter("gender") != null ? request.getParameter("gender").trim() : "";

            boolean ok = accountDao.updateProfile(id, firstName, lastName, email, mobileNumber, dob, gender);
            if (ok) {
                sessionUser.setFirstName(firstName);
                sessionUser.setLastName(lastName);
                sessionUser.setEmail(email);
                sessionUser.setMobileNumber(mobileNumber);
                sessionUser.setDob(dob);
                sessionUser.setGender(gender);
                SessionUtil.setAttribute(request, "user", sessionUser);
                response.sendRedirect(request.getContextPath() + "/admin/account?toast=profile");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/account?toast=error");
            }

        } else if ("password".equals(action)) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword     = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            User admin = accountDao.findById(id);
            if (admin == null || !PasswordUtil.checkPassword(currentPassword, admin.getPassword())) {
                response.sendRedirect(request.getContextPath() + "/admin/account?toast=wrongpw");
                return;
            }
            if (!newPassword.equals(confirmPassword)) {
                response.sendRedirect(request.getContextPath() + "/admin/account?toast=mismatch");
                return;
            }
            boolean ok = accountDao.updatePassword(id, PasswordUtil.getHashPassword(newPassword));
            response.sendRedirect(request.getContextPath() + "/admin/account?toast=" + (ok ? "password" : "error"));

        } else if ("image".equals(action)) {
            Part filePart = request.getPart("profileImage");
            if (filePart != null && filePart.getSize() > 0) {
                String savedPath = ImageUtil.uploadImage(filePart, getServletContext(), "profile");
                if (savedPath != null && sessionUser != null) {
                    boolean ok = accountDao.updateImage(sessionUser.getId(), savedPath);
                    if (ok) {
                        sessionUser.setImage(savedPath);
                        SessionUtil.setAttribute(request, "user", sessionUser);
                        response.sendRedirect(request.getContextPath() + "/admin/account?toast=image");
                        return;
                    }
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/account?toast=error");

        } else {
            response.sendRedirect(request.getContextPath() + "/admin/account");
        }
    }
}
