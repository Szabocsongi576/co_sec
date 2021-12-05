package com.cosec.backend.models;

public class ParseResult {
    private String message;
    private byte[] imageData;

    public ParseResult(String message, byte[] imageData) {
        this.message = message;
        this.imageData = imageData;
    }

    public ParseResult(String message) {
        this.message = message;
        this. imageData = null;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public byte[] getImageData() {
        return imageData;
    }

    public void setImageData(byte[] imageData) {
        this.imageData = imageData;
    }
}
