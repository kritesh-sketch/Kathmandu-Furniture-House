package com.kathmanduFurniture.entity.user;

import java.sql.Timestamp;

public class JobVacancy {

    private int id;
    private String title;
    private String department;
    private String location;
    private String type;
    private String description;
    private String requirements;
    private int salaryMin;
    private int salaryMax;
    private String status;
    private int applicationCount;
    private Timestamp createdAt;

    public JobVacancy() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getRequirements() { return requirements; }
    public void setRequirements(String requirements) { this.requirements = requirements; }

    public int getSalaryMin() { return salaryMin; }
    public void setSalaryMin(int salaryMin) { this.salaryMin = salaryMin; }

    public int getSalaryMax() { return salaryMax; }
    public void setSalaryMax(int salaryMax) { this.salaryMax = salaryMax; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getApplicationCount() { return applicationCount; }
    public void setApplicationCount(int applicationCount) { this.applicationCount = applicationCount; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
