package com.kathmanduFurniture.entity.user;

import java.sql.Timestamp;

/**
 * Entity class representing a customer feedback submission.
 * Maps to the {@code feedback} table.
 * Status values: "Pending" (not yet reviewed) | "Reviewed" | "Resolved"
 */
public class Feedback {

    // Primary key
    private int       id;

    // Submitter details (entered on the help/contact form — not tied to a user account)
    private String    userName;
    private String    email;

    // Feedback content
    private String    subject;
    private String    message;

    // Workflow status managed by admins
    private String    status;

    // Timestamp set automatically by the database on INSERT
    private Timestamp createdAt;

    // Default constructor
    public Feedback() {}

    // ── Getters and Setters ──────────────────────────────────────────────────

    public int       getId()                       { return id; }
    public void      setId(int id)                 { this.id = id; }

    public String    getUserName()                 { return userName; }
    public void      setUserName(String userName)  { this.userName = userName; }

    public String    getEmail()                    { return email; }
    public void      setEmail(String email)        { this.email = email; }

    public String    getSubject()                  { return subject; }
    public void      setSubject(String subject)    { this.subject = subject; }

    public String    getMessage()                  { return message; }
    public void      setMessage(String message)    { this.message = message; }

    public String    getStatus()                   { return status; }
    public void      setStatus(String status)      { this.status = status; }

    public Timestamp getCreatedAt()                { return createdAt; }
    public void      setCreatedAt(Timestamp ts)    { this.createdAt = ts; }
}
