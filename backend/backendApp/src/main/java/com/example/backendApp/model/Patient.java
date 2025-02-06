package com.example.backendApp.model;

public class Patient {

    private String name;
    private int age;
    private int campID;
    private boolean gender;
    private String phone;
    private String address; // This one is iffy

    public Patient(String name, int age, int campID) {
        this.name = name;
        this.age = age;
        this.campID = campID;
    }

    public String getName() {return name;}
    public void setName(String name) {this.name = name;}

    public int getAge() {return age;}
    public void setAge(int age) {this.age = age;}

    public int getCampID() {return campID;}
    public void setCampID(int campID) {this.campID = campID;}

}
