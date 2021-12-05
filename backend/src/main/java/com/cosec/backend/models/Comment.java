package com.cosec.backend.models;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "comments")
public class Comment {

    @Id
    private String id;
    private String userId;
    private String username;
    private String caffId;
    private String text;

    public Comment(String id, String userId, String username, String caffId, String text) {
        this.id = id;
        this.userId = userId;
        this.username = username;
        this.caffId = caffId;
        this.text = text;
    }

    public Comment(String userId, String username, String caffId, String text) {
        this.userId = userId;
        this.username = username;
        this.caffId = caffId;
        this.text = text;
    }

    public Comment() {
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getCaffId() {
        return caffId;
    }

    public void setCaffId(String caffId) {
        this.caffId = caffId;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }
}
