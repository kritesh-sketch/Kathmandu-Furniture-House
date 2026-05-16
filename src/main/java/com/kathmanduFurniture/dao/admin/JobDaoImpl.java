package com.kathmanduFurniture.dao.admin;

import com.kathmanduFurniture.entity.user.JobApplication;
import com.kathmanduFurniture.entity.user.JobVacancy;
import com.kathmanduFurniture.utils.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/*
 * Required SQL (run once):
 *
 * CREATE TABLE IF NOT EXISTS job_vacancies (
 *     id          INT AUTO_INCREMENT PRIMARY KEY,
 *     title       VARCHAR(200) NOT NULL,
 *     department  VARCHAR(100),
 *     location    VARCHAR(150),
 *     type        VARCHAR(50),
 *     description TEXT,
 *     requirements TEXT,
 *     salary_min  INT DEFAULT 0,
 *     salary_max  INT DEFAULT 0,
 *     status      VARCHAR(20) DEFAULT 'Active',
 *     created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 *     updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
 * );
 *
 * CREATE TABLE IF NOT EXISTS job_applications (
 *     id             INT AUTO_INCREMENT PRIMARY KEY,
 *     vacancy_id     INT,
 *     applicant_name VARCHAR(150) NOT NULL,
 *     email          VARCHAR(150),
 *     phone          VARCHAR(20),
 *     cover_letter   TEXT,
 *     resume_path    VARCHAR(500),
 *     status         VARCHAR(20) DEFAULT 'Pending',
 *     applied_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 *     FOREIGN KEY (vacancy_id) REFERENCES job_vacancies(id) ON DELETE SET NULL
 * );
 */
public class JobDaoImpl implements JobDao {

    /* ══════════════════════════════════════════
       VACANCIES
       ══════════════════════════════════════════ */

    @Override
    public List<JobVacancy> getAllVacancies() {
        List<JobVacancy> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT v.*, " +
                         "(SELECT COUNT(*) FROM job_applications a WHERE a.vacancy_id = v.id) AS app_count " +
                         "FROM job_vacancies v ORDER BY v.created_at DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapVacancy(rs));
        } catch (SQLException e) {
            System.out.println("JobDao.getAllVacancies error: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return list;
    }

    @Override
    public JobVacancy getVacancyById(int id) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT v.*, " +
                         "(SELECT COUNT(*) FROM job_applications a WHERE a.vacancy_id = v.id) AS app_count " +
                         "FROM job_vacancies v WHERE v.id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapVacancy(rs);
        } catch (SQLException e) {
            System.out.println("JobDao.getVacancyById error: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return null;
    }

    @Override
    public boolean insertVacancy(JobVacancy v) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "INSERT INTO job_vacancies (title,department,location,type,description,requirements,salary_min,salary_max,status) " +
                         "VALUES (?,?,?,?,?,?,?,?,?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, v.getTitle());
            ps.setString(2, v.getDepartment());
            ps.setString(3, v.getLocation());
            ps.setString(4, v.getType());
            ps.setString(5, v.getDescription());
            ps.setString(6, v.getRequirements());
            ps.setInt(7, v.getSalaryMin());
            ps.setInt(8, v.getSalaryMax());
            ps.setString(9, v.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("JobDao.insertVacancy error: " + e.getMessage());
            return false;
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
    }

    @Override
    public boolean updateVacancy(JobVacancy v) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "UPDATE job_vacancies SET title=?,department=?,location=?,type=?,description=?,requirements=?,salary_min=?,salary_max=?,status=?,updated_at=NOW() WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, v.getTitle());
            ps.setString(2, v.getDepartment());
            ps.setString(3, v.getLocation());
            ps.setString(4, v.getType());
            ps.setString(5, v.getDescription());
            ps.setString(6, v.getRequirements());
            ps.setInt(7, v.getSalaryMin());
            ps.setInt(8, v.getSalaryMax());
            ps.setString(9, v.getStatus());
            ps.setInt(10, v.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("JobDao.updateVacancy error: " + e.getMessage());
            return false;
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
    }

    @Override
    public boolean deleteVacancy(int id) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement("DELETE FROM job_vacancies WHERE id=?");
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("JobDao.deleteVacancy error: " + e.getMessage());
            return false;
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
    }

    /* ══════════════════════════════════════════
       APPLICATIONS
       ══════════════════════════════════════════ */

    @Override
    public List<JobApplication> getAllApplications(int vacancyId, String status, String search) {
        List<JobApplication> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            StringBuilder sql = new StringBuilder(
                "SELECT a.*, v.title AS vacancy_title FROM job_applications a " +
                "LEFT JOIN job_vacancies v ON a.vacancy_id = v.id WHERE 1=1");
            List<Object> params = new ArrayList<>();

            if (vacancyId > 0) {
                sql.append(" AND a.vacancy_id = ?");
                params.add(vacancyId);
            }
            if (status != null && !status.equals("all") && !status.isEmpty()) {
                sql.append(" AND a.status = ?");
                params.add(status);
            }
            if (search != null && !search.trim().isEmpty()) {
                sql.append(" AND (a.applicant_name LIKE ? OR a.email LIKE ?)");
                params.add("%" + search.trim() + "%");
                params.add("%" + search.trim() + "%");
            }
            sql.append(" ORDER BY a.applied_at DESC");

            PreparedStatement ps = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapApplication(rs));
        } catch (SQLException e) {
            System.out.println("JobDao.getAllApplications error: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return list;
    }

    @Override
    public boolean updateApplicationStatus(int id, String status) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement("UPDATE job_applications SET status=? WHERE id=?");
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("JobDao.updateApplicationStatus error: " + e.getMessage());
            return false;
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
    }

    /* ── Mappers ── */

    private JobVacancy mapVacancy(ResultSet rs) throws SQLException {
        JobVacancy v = new JobVacancy();
        v.setId(rs.getInt("id"));
        v.setTitle(rs.getString("title"));
        v.setDepartment(rs.getString("department"));
        v.setLocation(rs.getString("location"));
        v.setType(rs.getString("type"));
        v.setDescription(rs.getString("description"));
        v.setRequirements(rs.getString("requirements"));
        v.setSalaryMin(rs.getInt("salary_min"));
        v.setSalaryMax(rs.getInt("salary_max"));
        v.setStatus(rs.getString("status"));
        v.setApplicationCount(rs.getInt("app_count"));
        v.setCreatedAt(rs.getTimestamp("created_at"));
        return v;
    }

    private JobApplication mapApplication(ResultSet rs) throws SQLException {
        JobApplication a = new JobApplication();
        a.setId(rs.getInt("id"));
        a.setVacancyId(rs.getInt("vacancy_id"));
        a.setVacancyTitle(rs.getString("vacancy_title"));
        a.setApplicantName(rs.getString("applicant_name"));
        a.setEmail(rs.getString("email"));
        a.setPhone(rs.getString("phone"));
        a.setCoverLetter(rs.getString("cover_letter"));
        a.setResumePath(rs.getString("resume_path"));
        a.setStatus(rs.getString("status"));
        a.setAppliedAt(rs.getTimestamp("applied_at"));
        return a;
    }
}
