package com.kathmanduFurniture.dao.user;

import com.kathmanduFurniture.entity.user.Product;
import java.util.List;

public interface ProductDao {
    List<Product> getAllActiveProducts();
    List<Product> getProductsByCategory(String category);
}
