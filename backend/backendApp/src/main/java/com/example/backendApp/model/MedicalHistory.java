package com.example.backendApp.model;

public class MedicalHistory {
    private String patientID;
    private String notes;

    public MedicalHistory(String patientID, String notes) {
        this.patientID = patientID;
        this.notes = notes;
    }

    public String getPatientID() { return patientID; }
    public String getNotes() { return notes; }

    public void setPatientID(String patientID) {this.patientID = patientID; }
    public void setNotes(String notes) {this.notes = notes; }
}
