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
import java.util.Collections;
import java.util.List;

@WebServlet(name = "SearchServlet", value = "/user/search")
public class SearchServlet extends HttpServlet {

    private ProductDao productDao;

    @Override
    public void init() throws ServletException {
        productDao = new ProductDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String q = request.getParameter("q");
        if (q != null) q = q.trim();

        List<Product> results = (q != null && !q.isEmpty())
                ? productDao.getFilteredProducts(null, null, null, null, null, q)
                : Collections.emptyList();

        request.setAttribute("query",   q);
        request.setAttribute("results", results);
        request.getRequestDispatcher("/WEB-INF/views/user/search.jsp").forward(request, response);
    }
}
