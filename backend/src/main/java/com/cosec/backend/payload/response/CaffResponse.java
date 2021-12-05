package com.cosec.backend.payload.response;

import com.cosec.backend.models.Caff;

public class CaffResponse {
    private String id;
    private String userId;
    private String name;
    private String imageUrl;

    public CaffResponse(Caff caff) {
        this.id = caff.getId();
        this.name = caff.getName();
        this.userId = caff.getUserId();
        this.imageUrl = "/caffs/unauth/image/" + id;
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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
}
