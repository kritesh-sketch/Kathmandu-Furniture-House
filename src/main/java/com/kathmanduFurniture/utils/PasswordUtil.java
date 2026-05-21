package com.kathmanduFurniture.utils;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility class for hashing and verifying passwords using BCrypt.
 * BCrypt automatically handles salt generation and includes the salt
 * in the resulting hash, so no separate salt storage is needed.
 */
public class PasswordUtil {

    // BCrypt cost factor — higher values are slower and more secure (10 is a common default)
    private static final int COST = 10;

    /**
     * Hashes a plain-text password using BCrypt with a random salt.
     *
     * @param inputPassword the plain-text password to hash
     * @return the BCrypt hash string (includes salt and cost factor)
     */
    public static String getHashPassword(String inputPassword) {
        String salt = BCrypt.gensalt(COST); // generate a new random salt
        return BCrypt.hashpw(inputPassword, salt); // hash password with the salt
    }

    /**
     * Verifies a plain-text password against a stored BCrypt hash.
     *
     * @param passwordTyped  the plain-text password entered by the user
     * @param hashedPassword the stored BCrypt hash from the database
     * @return true if the passwords match, false otherwise
     */
    public static boolean checkPassword(String passwordTyped, String hashedPassword) {
        return BCrypt.checkpw(passwordTyped, hashedPassword);
    }
}
