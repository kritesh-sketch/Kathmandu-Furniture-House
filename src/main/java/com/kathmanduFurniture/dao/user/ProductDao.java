package com.kathmanduFurniture.dao.user;

import com.kathmanduFurniture.entity.user.Product;
import java.util.List;

public interface ProductDao {
    List<Product> getAllActiveProducts();
    List<Product> getProductsByCategory(String category);
    Product getProductById(int id);
    List<Product> getFilteredProducts(String category, Double minPrice, Double maxPrice,
                                      String availability, String sort, String search);
    List<String> getAllCategories();
    double getMaxPrice();
}
