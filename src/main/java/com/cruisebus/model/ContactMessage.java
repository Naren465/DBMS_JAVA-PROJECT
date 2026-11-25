package com.cruisebus.model;

import java.sql.Timestamp;

public class ContactMessage {
    private int messageId;
    private String name;
    private String email;
    private String phone;
    private String subject;
    private String message;
    private Timestamp submittedAt;

    public ContactMessage() {}

    public ContactMessage(int messageId, String name, String email, String phone, String subject, String message, Timestamp submittedAt) {
        this.messageId = messageId;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.subject = subject;
        this.message = message;
        this.submittedAt = submittedAt;
    }

    public int getMessageId() { return messageId; }
    public void setMessageId(int messageId) { this.messageId = messageId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public Timestamp getSubmittedAt() { return submittedAt; }
    public void setSubmittedAt(Timestamp submittedAt) { this.submittedAt = submittedAt; }
}
