package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.entity.user.Discount;
import java.util.List;

public interface discountDao {
    boolean      createOffer(Discount offer);
    boolean      updateOffer(Discount offer);
    boolean      deleteOffer(int id);
    boolean      updateStatus(int id, String status);
    List<Discount> getAllOffers();
    Discount     getOfferById(int id);
}
