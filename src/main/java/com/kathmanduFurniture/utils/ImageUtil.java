package com.kathmanduFurniture.utils;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;

/**
 * Utility class for uploading image files submitted via multipart form data.
 * Images are saved to the {@code static/images/<subFolder>} directory inside
 * the deployed web application root. Only jpg, jpeg, png, and webp are accepted.
 */
public class ImageUtil {

    /**
     * Uploads an image file to the given sub-folder under {@code static/images/}.
     *
     * @param imagePart  the multipart file part from the HTTP request
     * @param context    the servlet context (used to resolve the real file-system path)
     * @param subFolder  the target sub-folder, e.g. "products", "profile", "requests"
     * @return a relative path like "products/2026-05-01T10-00-00-filename.jpg",
     *         or null if the part is empty or the file extension is not allowed
     */
    public static String uploadImage(Part imagePart, ServletContext context, String subFolder) {
        String fileName = imagePart.getSubmittedFileName();
        if (fileName == null || fileName.isEmpty()) return null; // no file selected

        // Validate file extension — only allow common image types
        String ext = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
        if (!ext.equals(".jpg") && !ext.equals(".jpeg") && !ext.equals(".png") && !ext.equals(".webp")) {
            return null; // unsupported file type
        }

        // Create a unique filename by prefixing with current timestamp to avoid name collisions
        String uniqueName = LocalDateTime.now().toString().replace(":", "-").replace(".", "-") + "_" + fileName;

        // Resolve the absolute upload directory on the server's file system
        String uploadFolder = "static" + File.separator + "images" + File.separator + subFolder;
        File uploadDir = new File(context.getRealPath("") + File.separator + uploadFolder);
        if (!uploadDir.exists()) uploadDir.mkdirs(); // create the directory tree if it doesn't exist

        // Write the uploaded file to disk and return the relative path used in the database
        String filePath = uploadFolder + File.separator + uniqueName;
        try {
            imagePart.write(context.getRealPath("") + File.separator + filePath);
            return subFolder + "/" + uniqueName; // relative path stored in the DB
        } catch (IOException e) {
            System.out.println("ImageUtil.uploadImage error: " + e.getMessage());
            return null;
        }
    }

    /**
     * Overload that uploads to the default "photos" sub-folder.
     *
     * @param imagePart the multipart file part from the HTTP request
     * @param context   the servlet context
     * @return the relative image path, or null on failure
     */
    public static String uploadImage(Part imagePart, ServletContext context) {
        return uploadImage(imagePart, context, "photos");
    }
}
