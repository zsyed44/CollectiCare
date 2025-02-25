package com.example.backendApp.model;

public class LoginRequest{
    private String iD;
    private byte[] photo;

    public String getID(){return this.iD;}
    public void setID(String iD){this.iD = iD;}
    public byte[] getPhoto(){return this.photo;}
    public void setPhoto(byte[] photo){this.photo = photo;}

}