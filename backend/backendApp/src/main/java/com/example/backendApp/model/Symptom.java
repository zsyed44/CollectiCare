package com.example.backendApp.model;

public class Symptom {
    private String symptomID;
    private String symptomType;
    private String severity;
    private String duration;

    public Symptom(String symptomID, String symptomType, String severity, String duration) {
        this.symptomID = symptomID;
        this.symptomType = symptomType;
        this.severity = severity;
        this.duration = duration;
    }

    public String getSymptomID() { return symptomID; }
    public String getSymptomType() { return symptomType; }
    public String getSeverity() { return severity; }
    public String getDuration() { return duration; }

    public void setSymptomID(String symptomID) {this.symptomID = symptomID; }
    public void setSymptomType(String symptomType) {this.symptomType = symptomType; }
    public void setSeverity(String severity) {this.severity = severity; }
    public void setDuration(String duration) {this.duration = duration; }
}
