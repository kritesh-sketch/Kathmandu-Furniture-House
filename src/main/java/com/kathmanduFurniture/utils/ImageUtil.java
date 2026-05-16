package com.kathmanduFurniture.utils;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;

public class ImageUtil {

    public static String uploadImage(Part imagePart, ServletContext context, String subFolder) {
        String fileName = imagePart.getSubmittedFileName();
        if (fileName == null || fileName.isEmpty()) return null;

        String ext = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
        if (!ext.equals(".jpg") && !ext.equals(".jpeg") && !ext.equals(".png") && !ext.equals(".webp")) {
            return null;
        }

        String uniqueName = LocalDateTime.now().toString().replace(":", "-").replace(".", "-") + "_" + fileName;
        String uploadFolder = "static" + File.separator + "images" + File.separator + subFolder;
        File uploadDir = new File(context.getRealPath("") + File.separator + uploadFolder);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        String filePath = uploadFolder + File.separator + uniqueName;
        try {
            imagePart.write(context.getRealPath("") + File.separator + filePath);
            return subFolder + "/" + uniqueName;
        } catch (IOException e) {
            System.out.println("ImageUtil.uploadImage error: " + e.getMessage());
            return null;
        }
    }

    public static String uploadImage(Part imagePart, ServletContext context) {
        return uploadImage(imagePart, context, "photos");
    }
}
