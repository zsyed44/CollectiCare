package com.example.backendApp.model;

public class EyeSurgicalHistory {
    private String patientID;
    private boolean cataractOrInjury;
    private boolean retinalLaser;

    public EyeSurgicalHistory(String patientID, boolean cataractOrInjury, boolean retinalLaser) {
        this.patientID = patientID;
        this.cataractOrInjury = cataractOrInjury;
        this.retinalLaser = retinalLaser;
    }

    public String getPatientID() { return patientID; }
    public boolean isCataractOrInjury() { return cataractOrInjury; }
    public boolean isRetinalLaser() { return retinalLaser; }

    public void setPatientID(String patientID) { this.patientID = patientID; }
    public void setCataractOrInjury(boolean cataractOrInjury) { this.cataractOrInjury = cataractOrInjury; }
    public void setRetinalLaser(boolean retinalLaser) { this.retinalLaser = retinalLaser; }
}
