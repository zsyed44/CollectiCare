package com.example.backendApp.model;

public class RegisterRequest {
    private String id;
    private byte[] photo;
    private String name;
    private String dob;
    private String campLocation;
    private String phone;

    // Getters and setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public byte[] getPhoto() { return photo; }
    public void setPhoto(byte[] photo) { this.photo = photo; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDob() { return dob; }
    public void setDob(String dob) { this.dob = dob; }
    public String getCampLocation() { return campLocation; }
    public void setCampLocation(String campLocation) { this.campLocation = campLocation; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
}