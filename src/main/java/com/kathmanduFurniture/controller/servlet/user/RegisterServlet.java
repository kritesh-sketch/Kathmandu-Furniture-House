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

/**
 * RegisterServlet handles new user registration for the Kathmandu Furniture House application.
 *
 * GET  /user/join-us  — displays the registration form (join-us.jsp)
 * POST /user/join-us  — validates form input, checks for duplicates, and creates a new user account
 *
 * Newly registered accounts are set to "Pending" status and must be approved by an admin
 * before the user can log in.
 */
@WebServlet(name = "RegisterServlet", value = "/user/join-us")
public class RegisterServlet extends HttpServlet {

    // Data access object for all user-related database operations
    private UserDao userDao;

    /**
     * Initializes the servlet by creating an instance of UserDaoImpl.
     * Called once by the servlet container when the servlet is first loaded.
     */
    @Override
    public void init() throws ServletException {
        userDao = new UserDaoImpl();
    }

    /**
     * Handles GET requests to /user/join-us.
     * Simply forwards to the registration form JSP.
     *
     * @param request  the HTTP request
     * @param response the HTTP response
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to the registration form view
        request.getRequestDispatcher("/WEB-INF/views/user/join-us.jsp").forward(request, response);
    }

    /**
     * Handles POST requests to /user/join-us (form submission).
     *
     * Validation order:
     *   1. Required fields check
     *   2. Name format (letters only)
     *   3. Password strength
     *   4. Password confirmation match
     *   5. Email uniqueness
     *   6. Phone number uniqueness
     *   7. Insert user into the database
     *
     * On success: redirects to the login page with a ?registered=true flag.
     * On failure: re-renders the form with an error message and pre-filled input values.
     *
     * @param request  the HTTP request containing form parameters
     * @param response the HTTP response
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── Step 1: Read all form parameters ──────────────────────────────────
        String firstName  = request.getParameter("firstName");
        String lastName   = request.getParameter("lastName");
        String email      = request.getParameter("email");
        String phone      = request.getParameter("phone");
        String dob        = request.getParameter("dob");        // Optional field (date of birth)
        String gender     = request.getParameter("gender");     // Optional field
        String password   = request.getParameter("password");
        String confirmPwd = request.getParameter("confirmPassword");

        // ── Step 2: Required fields validation ────────────────────────────────
        // dob and gender are optional, so they are excluded from this check
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

        // ── Step 3: Name format validation ────────────────────────────────────
        // Names must contain only alphabetic characters (no digits, symbols, or spaces)
        if (!ValidationUtil.isLettersOnly(firstName.trim()) || !ValidationUtil.isLettersOnly(lastName.trim())) {
            request.setAttribute("error", "First name and last name must contain letters only.");
            repopulate(request, firstName, lastName, email, phone, dob, gender);
            request.getRequestDispatcher("/WEB-INF/views/user/join-us.jsp").forward(request, response);
            return;
        }

        // ── Step 4: Password strength validation ──────────────────────────────
        // Must be at least 8 characters and include uppercase, digit, and special character
        if (!ValidationUtil.isValidPassword(password)) {
            request.setAttribute("error", "Password must be at least 8 characters and include an uppercase letter, a number, and a special character (@$!%*?&#).");
            repopulate(request, firstName, lastName, email, phone, dob, gender);
            request.getRequestDispatcher("/WEB-INF/views/user/join-us.jsp").forward(request, response);
            return;
        }

        // ── Step 5: Password confirmation check ───────────────────────────────
        // Ensure the password and confirm-password fields match exactly
        if (!password.equals(confirmPwd)) {
            request.setAttribute("error", "Passwords do not match.");
            repopulate(request, firstName, lastName, email, phone, dob, gender);
            request.getRequestDispatcher("/WEB-INF/views/user/join-us.jsp").forward(request, response);
            return;
        }

        // ── Step 6: Duplicate email check ─────────────────────────────────────
        // Query the database to ensure no existing user has the same email address
        if (userDao.findByEmail(email.trim()) != null) {
            request.setAttribute("error", "This email address is already registered.");
            repopulate(request, firstName, lastName, email, phone, dob, gender);
            request.getRequestDispatcher("/WEB-INF/views/user/join-us.jsp").forward(request, response);
            return;
        }

        // ── Step 7: Duplicate phone number check ──────────────────────────────
        // Query the database to ensure no existing user has the same phone number
        if (userDao.findByPhoneNumber(phone.trim()) != null) {
            request.setAttribute("error", "This phone number is already registered.");
            repopulate(request, firstName, lastName, email, phone, dob, gender);
            request.getRequestDispatcher("/WEB-INF/views/user/join-us.jsp").forward(request, response);
            return;
        }

        // ── Step 8: Hash password and build User object ───────────────────────
        // Never store plain-text passwords — hash before saving to the database
        String hashedPassword = PasswordUtil.getHashPassword(password);

        // Construct the User entity with trimmed values; status defaults to "Pending" in the DAO
        User user = new User(firstName.trim(), lastName.trim(), dob, gender,
                             email.trim(), phone.trim(), hashedPassword);

        // ── Step 9: Persist the new user ──────────────────────────────────────
        boolean success = userDao.insertUser(user);

        if (success) {
            // Registration successful — redirect to login page with a flag to show a success message
            response.sendRedirect(request.getContextPath() + "/user/login?registered=true");
        } else {
            // insertUser returned false due to an unexpected database error (not a duplicate)
            request.setAttribute("error", "Registration failed. Please try again or contact support.");
            repopulate(request, firstName, lastName, email, phone, dob, gender);
            request.getRequestDispatcher("/WEB-INF/views/user/join-us.jsp").forward(request, response);
        }
    }

    /**
     * Re-populates request attributes with the user's previously submitted values
     * so the form fields are not cleared when the page is re-rendered after a validation error.
     *
     * @param req    the current HTTP request
     * @param fn     first name entered by the user
     * @param ln     last name entered by the user
     * @param email  email address entered by the user
     * @param phone  phone number entered by the user
     * @param dob    date of birth entered by the user (may be null or empty)
     * @param gender gender selected by the user (may be null or empty)
     */
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
