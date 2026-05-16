package com.kathmanduFurniture.dao.user;

import com.kathmanduFurniture.entity.user.Product;
import java.util.List;

public interface HomeDao {
    List<Product> getSpotlightProducts();
}
