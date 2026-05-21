package com.kathmanduFurniture.utils;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Utility class for creating, reading, and deleting HTTP cookies.
 * All cookies created by this class are set with HttpOnly to prevent
 * client-side JavaScript access and are scoped to the root path "/".
 */
public class CookieUtil {

    /**
     * Creates and adds a cookie to the HTTP response.
     *
     * @param response the HTTP response to attach the cookie to
     * @param name     the cookie name
     * @param value    the cookie value
     * @param maxAge   lifetime in seconds (use -1 for session cookie, 0 to delete)
     */
    public static void addCookie(HttpServletResponse response,
                                 String name, String value, int maxAge) {
        Cookie cookie = new Cookie(name, value);
        cookie.setMaxAge(maxAge);     // how long the cookie lives in seconds
        cookie.setPath("/");          // make cookie available across the entire app
        cookie.setHttpOnly(true);     // block access from JavaScript to reduce XSS risk
        response.addCookie(cookie);
    }

    /**
     * Reads the value of a named cookie from the incoming request.
     *
     * @param request the HTTP request containing cookies
     * @param name    the cookie name to look for
     * @return the cookie value, or null if no matching cookie is found
     */
    public static String getCookieValue(HttpServletRequest request,
                                        String name) {
        Cookie[] cookies = request.getCookies(); // returns null if no cookies sent
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (name.equals(cookie.getName())) {
                    return cookie.getValue(); // found matching cookie
                }
            }
        }
        return null; // cookie not found
    }

    /**
     * Deletes a cookie by overwriting it with an empty value and a maxAge of 0.
     * Setting maxAge to 0 instructs the browser to remove the cookie immediately.
     *
     * @param response the HTTP response
     * @param name     the name of the cookie to delete
     */
    public static void deleteCookie(HttpServletResponse response,
                                    String name) {
        Cookie cookie = new Cookie(name, ""); // empty value
        cookie.setMaxAge(0);                  // maxAge=0 signals the browser to delete it
        cookie.setPath("/");
        response.addCookie(cookie);
    }
}
