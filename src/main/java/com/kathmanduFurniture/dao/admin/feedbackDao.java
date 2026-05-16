package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.entity.user.Feedback;
import java.util.List;

public interface feedbackDao {
    boolean      saveFeedback(Feedback feedback);
    List<Feedback> getAllFeedbacks();
    Feedback     getFeedbackById(int id);
    boolean      updateStatus(int id, String status);
}
