package com.kathmanduFurniture.utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/**
 * Utility class for managing HTTP session operations.
 * Provides a centralised API for setting, getting, removing,
 * and invalidating session attributes throughout the application.
 */
public class SessionUtil {

    /**
     * Sets an attribute in the current session, creating the session if it
     * does not already exist. The session timeout is set to 30 minutes.
     *
     * @param request the HTTP request
     * @param key     the attribute name
     * @param value   the value to store
     */
    public static void setAttribute(HttpServletRequest request,
                                    String key, Object value) {
        HttpSession session = request.getSession(); // create session if absent
        session.setMaxInactiveInterval(30 * 60);   // 30-minute inactivity timeout
        session.setAttribute(key, value);
    }

    /**
     * Retrieves an attribute from the current session without creating a new one.
     *
     * @param request the HTTP request
     * @param key     the attribute name
     * @return the attribute value, or null if the session does not exist or the key is not set
     */
    public static Object getAttribute(HttpServletRequest request,
                                      String key) {
        // false = do not create a new session if one doesn't exist
        HttpSession session = request.getSession(false);
        if (session != null) {
            return session.getAttribute(key);
        }
        return null; // no active session
    }

    /**
     * Invalidates the current session, clearing all stored attributes.
     * Used on logout to ensure no user data persists.
     *
     * @param request the HTTP request
     */
    public static void invalidateSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false); // don't create a new session
        if (session != null) {
            session.invalidate(); // destroy the session and all its attributes
        }
    }

    /**
     * Removes a single attribute from the current session without destroying it.
     *
     * @param request the HTTP request
     * @param key     the attribute name to remove
     */
    public static void removeAttribute(HttpServletRequest request, String key) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute(key);
        }
    }
}
