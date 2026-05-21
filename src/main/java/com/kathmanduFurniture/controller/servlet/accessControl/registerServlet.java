package com.kathmanduFurniture.controller.servlet.accessControl;

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
import java.time.Year;
import java.util.List;
import java.util.stream.IntStream;

/**
 * Handles new user self-registration at {@code /join-us}.
 * GET renders the form with date-of-birth dropdown data.
 * POST validates inputs, hashes the password, and persists the new account.
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        List<String> months = List.of(
                "January","February","March","April","May","June",
                "July","August","September","October","November","December"
        );

        List<Integer> days = IntStream.rangeClosed(1, 31).boxed().toList();

        int currentYear = Year.now().getValue();
        List<Integer> years = IntStream.rangeClosed(1920, currentYear)
                .boxed()
                .sorted((a, b) -> b - a)
                .toList();

        request.setAttribute("months", months);
        request.setAttribute("days", days);
        request.setAttribute("years", years);

        request.getRequestDispatcher("/WEB-INF/views/accessControl/register.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String gender = request.getParameter("gender");
        String contact = request.getParameter("contact");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("cpassword");
        String birthMonth = request.getParameter("birthMonth");
        String birthDay = request.getParameter("birthDay");
        String birthYear = request.getParameter("birthYear");
        String dob = birthYear + "-" + birthMonth + "-" + birthDay;

        String email = null;
        String mobile = null;

        StringBuilder errors = new StringBuilder();

        // Check if the first name field is empty and add an error message
        if (ValidationUtil.isNullOrEmpty(firstName)) {
            errors.append("First name cannot be empty. ");
        }

        if (firstName != null && firstName.length() < 3) {
            errors.append("First name must be at least 3 characters. ");
        }

        if (ValidationUtil.isNullOrEmpty(lastName)) {
            errors.append("Last name cannot be empty. ");
        }

        if (lastName != null && lastName.length() < 3) {
            errors.append("Last name must be at least 3 characters. ");
        }

        if (ValidationUtil.isNullOrEmpty(dob)) {
            errors.append("Date of birth cannot be empty. ");
        }

        // Contact validation
        if (ValidationUtil.isNullOrEmpty(contact)) {
            errors.append("Email or Phone number cannot be empty. ");
        } else if (ValidationUtil.isValidEmail(contact)) {
            email = contact;
        } else if (ValidationUtil.isValidPhone(contact)) {
            mobile = contact;
        } else {
            errors.append("Enter a valid email or phone number. ");
        }

        // Password checks
        if (ValidationUtil.isNullOrEmpty(password)) {
            errors.append("Password cannot be empty. ");
        }

        if (!ValidationUtil.isValidPassword(password)) {
            errors.append("Password must be strong. ");
        }

        if(!ValidationUtil.isNullOrEmpty(confirmPassword)) {
            errors.append("Confirm Password cannot be empty. ");
        }

        if (!ValidationUtil.doPasswordsMatch(password, confirmPassword)) {
            errors.append("Passwords do not match. ");
        }

        if (!errors.isEmpty()) {
            request.setAttribute("error", errors.toString().trim());
            request.getRequestDispatcher("/WEB-INF/views/authentication/register.jsp")
                    .forward(request, response);
            return;
        }



        String hashedPassword = PasswordUtil.getHashPassword(password);


        User user = new User(firstName, lastName,dob,gender, email, mobile,hashedPassword);
        boolean success = userDao.insertUser(user);

        if (!success) {
            request.setAttribute("error", "Username or email already exists.");
            request.getRequestDispatcher("/WEB-INF/views/authentication/register.jsp")
                    .forward(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/login");
    }
}
