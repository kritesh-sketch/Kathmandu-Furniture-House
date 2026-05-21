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

/**
 * Servlet for the Tables & Desks category page at {@code /user/tables}.
 * Delegates to {@link ProductDao#getFilteredProducts} with the category pre-set.
 */
@WebServlet(name = "TablesServlet", value = "/user/tables")
public class TablesServlet extends HttpServlet {

    private ProductDao productDao;

    @Override
    public void init() throws ServletException {
        productDao = new ProductDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String availability = trim(request.getParameter("availability"));
        String sort         = trim(request.getParameter("sort"));
        String search       = trim(request.getParameter("search"));
        String minPriceStr  = trim(request.getParameter("minPrice"));
        String maxPriceStr  = trim(request.getParameter("maxPrice"));

        Double minPrice = null, maxPrice = null;
        try { if (!minPriceStr.isEmpty()) minPrice = Double.parseDouble(minPriceStr); } catch (NumberFormatException ignored) {}
        try { if (!maxPriceStr.isEmpty()) maxPrice = Double.parseDouble(maxPriceStr); } catch (NumberFormatException ignored) {}

        List<Product> products = productDao.getFilteredProducts(
                "Tables & Desks", minPrice, maxPrice, availability, sort, search);

        request.setAttribute("products",     products);
        request.setAttribute("totalCount",   products.size());
        request.setAttribute("maxPriceDb",   (int) productDao.getMaxPrice());
        request.setAttribute("categoryName", "Tables & Desks");
        request.setAttribute("availability", availability);
        request.setAttribute("sort",         sort);
        request.setAttribute("search",       search);
        request.setAttribute("minPrice",     minPriceStr);
        request.setAttribute("maxPrice",     maxPriceStr);

        request.getRequestDispatcher("/WEB-INF/views/user/tables-desks.jsp").forward(request, response);
    }

    private String trim(String s) { return s != null ? s.trim() : ""; }
}
