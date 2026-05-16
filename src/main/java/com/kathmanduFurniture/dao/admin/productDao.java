package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.entity.user.Product;
import java.util.List;

public interface productDao {

    List<Product> fetchAllProducts();

    Product fetchProductById(int id);

    boolean addProduct(Product product);

    boolean updateProduct(Product product);

    boolean deleteProduct(int id);
}