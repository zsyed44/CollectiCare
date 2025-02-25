package com.example.backendApp.model;

public class SystemicHistory {
    private String patientID;
    private boolean HTN;
    private boolean DM;
    private boolean heartDisease;

    public SystemicHistory(String patientID, boolean HTN, boolean DM, boolean heartDisease) {
        this.patientID = patientID;
        this.HTN = HTN;
        this.DM = DM;
        this.heartDisease = heartDisease;
    }

    public String getPatientID() { return patientID; }
    public boolean isHTN() { return HTN; }
    public boolean isDM() { return DM; }
    public boolean isHeartDisease() { return heartDisease; }

    public void setPatientID(String patientID) {this.patientID = patientID;}
    public void setHTN(boolean HTN) {this.HTN = HTN;}
    public void setDM(boolean DM) {this.DM = DM;}
    public void setHeartDisease(boolean heartDisease) {this.heartDisease=heartDisease; }

}
