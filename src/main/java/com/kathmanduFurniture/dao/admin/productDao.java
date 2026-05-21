package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.entity.user.Product;
import java.util.List;

/**
 * DAO interface for admin-side product management.
 * Provides full CRUD operations on the products table including
 * category resolution and color associations.
 */
public interface ProductDao {

    /**
     * Returns all products, including their category name and color list.
     *
     * @return list of all products
     */
    List<Product> fetchAllProducts();

    /**
     * Retrieves a single product by its primary key.
     *
     * @param id the product ID
     * @return the Product, or null if not found
     */
    Product fetchProductById(int id);

    /**
     * Inserts a new product along with its color associations.
     * Runs inside a transaction; rolls back if any step fails.
     *
     * @param product the product to persist
     * @return true if the insert succeeded
     */
    boolean addProduct(Product product);

    /**
     * Updates an existing product and replaces its color associations.
     * Runs inside a transaction; rolls back if any step fails.
     *
     * @param product the product with updated values and a valid ID
     * @return true if the update succeeded
     */
    boolean updateProduct(Product product);

    /**
     * Deletes a product and its associated colors (via ON DELETE CASCADE).
     *
     * @param id the product ID to delete
     * @return true if the delete succeeded
     */
    boolean deleteProduct(int id);
}
