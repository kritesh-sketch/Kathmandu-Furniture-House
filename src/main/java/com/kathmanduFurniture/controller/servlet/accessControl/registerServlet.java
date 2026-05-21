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
 * Legacy registration servlet at {@code /register} (accessControl package).
 * This is an older form-based registration flow kept for backwards compatibility.
 * The active registration servlet is {@link com.kathmanduFurniture.controller.servlet.user.RegisterServlet}
 * at {@code /user/join-us}.
 *
 * <p>GET renders the form with month/day/year dropdown data for date of birth.
 * POST validates inputs, hashes the password, and persists the new account.
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        // Build dropdown data for the date-of-birth widget
        List<String> months = List.of(
                "January","February","March","April","May","June",
                "July","August","September","October","November","December"
        );

        List<Integer> days = IntStream.rangeClosed(1, 31).boxed().toList();

        // Years run from 1920 to current year, newest first
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

        // Step 1: Read all form parameters
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String gender = request.getParameter("gender");
        String contact = request.getParameter("contact");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("cpassword");
        String birthMonth = request.getParameter("birthMonth");
        String birthDay = request.getParameter("birthDay");
        String birthYear = request.getParameter("birthYear");
        // Assemble date-of-birth string from three separate dropdowns
        String dob = birthYear + "-" + birthMonth + "-" + birthDay;

        String email = null;
        String mobile = null;

        StringBuilder errors = new StringBuilder();

        // Step 2: Validate each field and accumulate error messages
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

        // Step 3: Return early with all accumulated errors if any validation failed
        if (!errors.isEmpty()) {
            request.setAttribute("error", errors.toString().trim());
            request.getRequestDispatcher("/WEB-INF/views/authentication/register.jsp")
                    .forward(request, response);
            return;
        }

        // Step 4: Hash password and build user entity
        String hashedPassword = PasswordUtil.getHashPassword(password);

        User user = new User(firstName, lastName, dob, gender, email, mobile, hashedPassword);

        // Step 5: Persist — DAO returns false if email/phone already exists
        boolean success = userDao.insertUser(user);

        if (!success) {
            request.setAttribute("error", "Username or email already exists.");
            request.getRequestDispatcher("/WEB-INF/views/authentication/register.jsp")
                    .forward(request, response);
            return;
        }

        // Step 6: Registration succeeded — redirect to login
        response.sendRedirect(request.getContextPath() + "/login");
    }
}
