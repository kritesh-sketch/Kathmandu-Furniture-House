package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.entity.user.JobApplication;
import com.kathmanduFurniture.entity.user.JobVacancy;

import java.util.List;

public interface JobDao {

    /* ── Vacancies ── */
    List<JobVacancy> getAllVacancies();
    JobVacancy getVacancyById(int id);
    boolean insertVacancy(JobVacancy v);
    boolean updateVacancy(JobVacancy v);
    boolean deleteVacancy(int id);

    /* ── Applications ── */
    List<JobApplication> getAllApplications(int vacancyId, String status, String search);
    boolean updateApplicationStatus(int id, String status);
}
