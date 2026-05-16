package com.kathmanduFurniture.controller.servlet.user;

import com.kathmanduFurniture.dao.user.HomeDao;
import com.kathmanduFurniture.dao.user.HomeDaoImpl;
import com.kathmanduFurniture.entity.user.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeServlet", value = "/home")
public class HomeServlet extends HttpServlet {

    private HomeDao homeDao;

    @Override
    public void init() throws ServletException {
        homeDao = new HomeDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Product> spotlightProducts = homeDao.getSpotlightProducts();
        request.setAttribute("spotlightProducts", spotlightProducts);
        
        // Forward to the view
        request.getRequestDispatcher("/WEB-INF/views/user/home.jsp").forward(request, response);
    }
}
