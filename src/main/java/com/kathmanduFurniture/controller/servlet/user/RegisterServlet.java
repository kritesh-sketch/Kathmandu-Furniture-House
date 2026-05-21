package com.kathmanduFurniture.controller.servlet.user;

import com.kathmanduFurniture.dao.user.UserDao;
import com.kathmanduFurniture.dao.user.UserDaoImpl;
import com.kathmanduFurniture.entity.user.User;
import com.kathmanduFurniture.utils.PasswordUtil;
import com.kathmanduFurniture.utils.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "RegisterServlet", value = "/user/join-us")
public class RegisterServlet extends HttpServlet {

    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        userDao = new UserDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/user/join-us.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String firstName  = request.getParameter("firstName");
        String lastName   = request.getParameter("lastName");
        String email      = request.getParameter("email");
        String phone      = request.getParameter("phone");
        String dob        = request.getParameter("dob");
        String gender     = request.getParameter("gender");
        String password   = request.getParameter("password");
        String confirmPwd = request.getParameter("confirmPassword");

        if (firstName == null || firstName.trim().isEmpty() ||
            lastName  == null || lastName.trim().isEmpty()  ||
            email     == null || email.trim().isEmpty()      ||
            phone     == null || phone.trim().isEmpty()      ||
            password  == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Please fill in all required fields.");
            repopulate(request, firstName, lastName, email, phone, dob, gender);
            request.getRequestDispatcher("/WEB-INF/views/user/join-us.jsp").forward(request, response);
            return;
        }

        if (!ValidationUtil.isValidPassword(password)) {
            request.setAttribute("error", "Password must be at least 8 characters and include an uppercase letter, a number, and a special character (@$!%*?&).");
            repopulate(request, firstName, lastName, email, phone, dob, gender);
            request.getRequestDispatcher("/WEB-INF/views/user/join-us.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPwd)) {
            request.setAttribute("error", "Passwords do not match.");
            repopulate(request, firstName, lastName, email, phone, dob, gender);
            request.getRequestDispatcher("/WEB-INF/views/user/join-us.jsp").forward(request, response);
            return;
        }

        String hashedPassword = PasswordUtil.getHashPassword(password);
        User user = new User(firstName.trim(), lastName.trim(), dob, gender,
                             email.trim(), phone.trim(), hashedPassword);

        boolean success = userDao.insertUser(user);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/user/login?registered=true");
        } else {
            request.setAttribute("error", "Email or phone number is already registered.");
            repopulate(request, firstName, lastName, email, phone, dob, gender);
            request.getRequestDispatcher("/WEB-INF/views/user/join-us.jsp").forward(request, response);
        }
    }

    private void repopulate(HttpServletRequest req,
                            String fn, String ln, String email,
                            String phone, String dob, String gender) {
        req.setAttribute("v_firstName", fn);
        req.setAttribute("v_lastName",  ln);
        req.setAttribute("v_email",     email);
        req.setAttribute("v_phone",     phone);
        req.setAttribute("v_dob",       dob);
        req.setAttribute("v_gender",    gender);
    }
}
