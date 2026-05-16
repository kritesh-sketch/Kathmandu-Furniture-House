package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.entity.user.Return;
import java.util.List;

public interface returnProductDao {
    boolean insertReturn(Return returnP);
    List<Return> getAllReturns();
    Return getReturnById(int id);
    boolean updateReturnStatus(int id, String status);
}
