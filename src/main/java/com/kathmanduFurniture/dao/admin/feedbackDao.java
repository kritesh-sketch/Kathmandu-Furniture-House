package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.entity.user.Feedback;
import java.util.List;

/**
 * DAO interface for managing customer feedback submissions.
 * Provides operations to save, retrieve, and update feedback status.
 */
public interface FeedbackDao {
    boolean      saveFeedback(Feedback feedback);
    List<Feedback> getAllFeedbacks();
    Feedback     getFeedbackById(int id);
    boolean      updateStatus(int id, String status);
}
