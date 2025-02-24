package com.example.backendApp.model;

import java.util.Date;

public class Patient {
    private String patientID;
    private String name;
    private Date dob;
    private String gisLocation;
    private String govtID;
    private String contactInfo;
    private boolean consentForFacialRecognition;

    public Patient(String patientID, String name, Date dob, String gisLocation, String govtID, String contactInfo, boolean consentForFacialRecognition) {
        this.patientID = patientID;
        this.name = name;
        this.dob = dob;
        this.gisLocation = gisLocation;
        this.govtID = govtID;
        this.contactInfo = contactInfo;
        this.consentForFacialRecognition = consentForFacialRecognition;
    }

    public String getPatientID() { return patientID; }
    public String getName() { return name; }
    public Date getDob() { return dob; }
    public String getGisLocation() { return gisLocation; }
    public String getGovtID() { return govtID; }
    public String getContactInfo() { return contactInfo; }
    public boolean isConsentForFacialRecognition() { return consentForFacialRecognition; }

    public void setPatientID(String patientID) { this.patientID = patientID; }
    public void setName(String name) { this.name = name; }
    public void setDob(Date dob) { this.dob = dob; }
    public void setGisLocation(String gisLocation) { this.gisLocation = gisLocation; }
    public void setGovtID(String govtID) { this.govtID = govtID; }
    public void setContactInfo(String contactInfo) { this.contactInfo = contactInfo; }
    public void setConsentForFacialRecognition(boolean consentForFacialRecognition) { this.consentForFacialRecognition = consentForFacialRecognition; }
}
