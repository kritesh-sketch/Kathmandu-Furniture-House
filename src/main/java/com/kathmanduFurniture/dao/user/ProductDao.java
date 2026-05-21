package com.kathmanduFurniture.dao.user;

import com.kathmanduFurniture.entity.user.Product;
import java.util.List;

/**
 * DAO interface for user-facing product queries.
 * Supports browsing by category, full-text search, price/availability filters,
 * and retrieval of a single product by ID.
 */
public interface ProductDao {
    /** Returns all products whose status is 'Active'. */
    List<Product> getAllActiveProducts();
    /** Returns active products belonging to the specified category. */
    List<Product> getProductsByCategory(String category);
    /** Returns a single product by its primary key, or {@code null} if not found. */
    Product getProductById(int id);
    /**
     * Returns active products matching the given filters.
     * Any parameter may be {@code null} or empty to skip that filter.
     * {@code sort} accepts "price-asc", "price-desc", or "rating".
     */
    List<Product> getFilteredProducts(String category, Double minPrice, Double maxPrice,
                                      String availability, String sort, String search);
    /** Returns all distinct category names ordered alphabetically. */
    List<String> getAllCategories();
    /** Returns the maximum price among all active products (for the price-range slider). */
    double getMaxPrice();
}
