package com.kathmanduFurniture.dao.user;

import com.kathmanduFurniture.entity.user.Product;
import java.util.List;

/**
 * DAO interface for the user home page.
 * Returns the subset of active products displayed in the spotlight/featured section.
 */
public interface HomeDao {
    /** Returns up to 16 active products for the home-page spotlight carousel. */
    List<Product> getSpotlightProducts();
}
