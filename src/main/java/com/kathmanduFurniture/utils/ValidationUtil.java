package com.kathmanduFurniture.utils;

import java.util.regex.Pattern;

/**
 * Utility class providing static input-validation helpers used across
 * servlets and DAOs to enforce data integrity before database operations.
 */
public class ValidationUtil {

    /**
     * Returns true if the value is null or contains only whitespace.
     *
     * @param value the string to check
     * @return true when null or blank
     */
    public static boolean isNullOrEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    /**
     * Returns true if the value contains only alphabetic characters (a-z, A-Z).
     * Used to validate first and last name fields.
     *
     * @param value the string to check
     * @return true when the string is non-null and letters-only
     */
    public static boolean isLettersOnly(String value) {
        return value != null && value.matches("^[a-zA-Z]+$");
    }

    /**
     * Validates an email address using a standard RFC-style regex.
     * Accepts formats like user@domain.com or user.name@sub.domain.co.
     *
     * @param email the email string to validate
     * @return true if the email matches the expected format
     */
    public static boolean isValidEmail(String email) {
        String emailRegex = "^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$";
        return email != null && Pattern.matches(emailRegex, email);
    }

    /**
     * Validates a Nepali mobile phone number.
     * Only numbers starting with 98 or 97 followed by exactly 8 digits are accepted.
     *
     * @param input the phone number string to validate
     * @return true if it matches the Nepali 10-digit format
     */
    public static boolean isValidPhone(String input) {
        return input != null &&
                input.matches("^(98|97)\\d{8}$");
    }

    /**
     * Validates password strength. A valid password must:
     * <ul>
     *   <li>Be at least 8 characters long</li>
     *   <li>Contain at least one uppercase letter (A-Z)</li>
     *   <li>Contain at least one digit (0-9)</li>
     *   <li>Contain at least one special character from: @ $ ! % * ? & #</li>
     *   <li>Use only the allowed characters above (no spaces or other symbols)</li>
     * </ul>
     *
     * @param password the plain-text password to check
     * @return true if the password meets all strength requirements
     */
    public static boolean isValidPassword(String password) {
        // Lookaheads enforce required character classes; the final character class is a whitelist
        String passwordRegex = "^(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&#])[A-Za-z\\d@$!%*?&#]{8,}$";
        return password != null && password.matches(passwordRegex);
    }

    /**
     * Returns true if both password strings are non-null and identical.
     * Used to confirm that the password and confirm-password fields match.
     *
     * @param password       the original password
     * @param retypePassword the confirmation password
     * @return true if they match
     */
    public static boolean doPasswordsMatch(String password, String retypePassword) {
        return password != null && password.equals(retypePassword);
    }
}
