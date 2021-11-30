package com.cosec.backend.models;

import com.cosec.backend.payload.request.CaffRequest;
import org.bson.BsonBinarySubType;
import org.bson.types.Binary;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.io.IOException;

@Document(collection = "caffs")
public class Caff {

    @Id
    private String id;
    private String userId;
    private String name;
    private Binary data;

    public Caff(String userId, String name, Binary data) {
        this.userId = userId;
        this.name = name;
        this.data = data;
    }

    public Caff(String userId, CaffRequest paramCaff) {
        this.userId = userId;
        this.name = paramCaff.getName();
        try {
            this.data = new Binary(BsonBinarySubType.BINARY, paramCaff.getData().getBytes());
        } catch (IOException e) {
            e.printStackTrace();
        }
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

    public Binary getData() {
        return data;
    }

    public void setData(Binary data) {
        this.data = data;
    }
}
