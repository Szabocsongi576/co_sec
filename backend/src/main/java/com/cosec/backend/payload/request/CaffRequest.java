package com.cosec.backend.payload.request;

import org.springframework.web.multipart.MultipartFile;

public class CaffRequest {

    private String name;
    private MultipartFile data;

    public CaffRequest(String userId, String name, MultipartFile data) {
        this.name = name;
        this.data = data;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public MultipartFile getData() {
        return data;
    }

    public void setData(MultipartFile data) {
        this.data = data;
    }
}