package com.kathmanduFurniture.controller.servlet.user;

import com.kathmanduFurniture.dao.user.ProductDao;
import com.kathmanduFurniture.dao.user.ProductDaoImpl;
import com.kathmanduFurniture.entity.user.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductServlet", value = "/user/products")
public class ProductServlet extends HttpServlet {

    private ProductDao productDao;

    @Override
    public void init() throws ServletException {
        productDao = new ProductDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String category = request.getParameter("category");
        List<Product> products;

        if (category != null && !category.trim().isEmpty()) {
            products = productDao.getProductsByCategory(category.trim());
            request.setAttribute("selectedCategory", category.trim());
        } else {
            products = productDao.getAllActiveProducts();
            request.setAttribute("selectedCategory", "");
        }

        request.setAttribute("products", products);
        request.getRequestDispatcher("/WEB-INF/views/user/products.jsp").forward(request, response);
    }
}
