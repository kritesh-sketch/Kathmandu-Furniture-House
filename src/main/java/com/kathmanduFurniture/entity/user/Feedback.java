package com.kathmanduFurniture.entity.user;

import java.sql.Timestamp;

public class Feedback {
    private int       id;
    private String    userName;
    private String    email;
    private String    subject;
    private String    message;
    private String    status;
    private Timestamp createdAt;

    public Feedback() {}

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
