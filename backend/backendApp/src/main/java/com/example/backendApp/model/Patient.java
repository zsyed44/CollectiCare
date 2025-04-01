package com.example.backendApp.model;

import java.util.Date;
import java.util.List;

public class Patient {
private String patientID;
private String name;
private Date dob;
private String gisLocation;
private String phone;
private String govtID;
private String contactInfo;
private boolean consentForFacialRecognition;
private String address;
private String eyeStatus;
private String gender;
private List<Double> imageEmbedding;

public Patient(String patientID, String name, Date dob, String gisLocation, String govtID, String contactInfo, boolean consentForFacialRecognition, String phone, String address, String eyeStatus, String gender, List<Double> imageEmbedding) {
    this.patientID = patientID; //
    this.name = name; //
    this.dob = dob; //
    this.gisLocation = gisLocation; //
    this.govtID = govtID;
    // phone numbers
    this.phone = phone;
    this.contactInfo = contactInfo;
    this.consentForFacialRecognition = consentForFacialRecognition;
    this.address = address;
    this.eyeStatus = eyeStatus;
    this.gender = gender;
    this.imageEmbedding = imageEmbedding;
}

// id, name, dob(YEAR MONTH DATE), campLocation, Phone
public String getPatientID() { return patientID; }
public String getName() { return name; }
public Date getDob() { return dob; }
public String getGisLocation() { return gisLocation; }
public String getGovtID() { return govtID; }
public String getContactInfo() { return contactInfo; }
public boolean isConsentForFacialRecognition() { return consentForFacialRecognition; }
public String getPhone() { return phone; }
public String getAddress() { return address; }
public String getEyeStatus() { return eyeStatus; }
public String getGender() { return gender; }
public List<Double> getImageEmbedding() { return imageEmbedding; }


public void setPatientID(String patientID) { this.patientID = patientID; }
public void setName(String name) { this.name = name; }
public void setDob(Date dob) { this.dob = dob; }
public void setGisLocation(String gisLocation) { this.gisLocation = gisLocation; }
public void setGovtID(String govtID) { this.govtID = govtID; }
public void setContactInfo(String contactInfo) { this.contactInfo = contactInfo; }
public void setConsentForFacialRecognition(boolean consentForFacialRecognition) { this.consentForFacialRecognition = consentForFacialRecognition; }
public void setPhone(String phone) { this.phone = phone; }
public void setAddress(String address) { this.address = address; }
public void setEyeStatus(String eyeStatus) { this.eyeStatus = eyeStatus; }
public void setGender(String gender) { this.gender = gender; }
public void setImageEmbedding(List<Double> imageEmbedding) { this.imageEmbedding = imageEmbedding; }
}
