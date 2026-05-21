package com.kathmanduFurniture.dao.user;

import com.kathmanduFurniture.entity.user.Product;
import java.util.List;

/**
 * DAO interface for managing a user's product wishlist.
 * Supports add, remove, toggle, and retrieval of wishlisted products.
 */
public interface FavoriteDao {
    boolean addToWishlist(int userId, int productId);
    boolean removeFromWishlist(int userId, int productId);
    boolean toggleWishlist(int userId, int productId);
    List<Product> getWishlistProducts(int userId);
    boolean isInWishlist(int userId, int productId);
}
