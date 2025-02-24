package com.example.backendApp.model;

public class OphthalmologyHistory {
    private String patientID;
    private boolean lossOfVision;
    private String lossOfVisionEye;
    private String lossOfVisionOnset;
    private boolean lossOfVisionPain;
    private String lossOfVisionDuration;
    private String rednessOnset;
    private String painEye;
    private boolean pain;
    private boolean rednessPain;
    private String wateringEye;
    private String painDuration;

    public OphthalmologyHistory(String patientID, boolean lossOfVision, String lossOfVisionEye, String lossOfVisionOnset,
                                boolean lossOfVisionPain, String lossOfVisionDuration, String rednessOnset, String painEye,
                                boolean pain, boolean rednessPain, String wateringEye, String painDuration) {
        this.patientID = patientID;
        this.lossOfVision = lossOfVision;
        this.lossOfVisionEye = lossOfVisionEye;
        this.lossOfVisionOnset = lossOfVisionOnset;
        this.lossOfVisionPain = lossOfVisionPain;
        this.lossOfVisionDuration = lossOfVisionDuration;
        this.rednessOnset = rednessOnset;
        this.painEye = painEye;
        this.pain = pain;
        this.rednessPain = rednessPain;
        this.wateringEye = wateringEye;
        this.painDuration = painDuration;
    }

    public String getPatientID() { return patientID; }
    public boolean isLossOfVision() { return lossOfVision; }
    public String getLossOfVisionEye() { return lossOfVisionEye; }
    public String getLossOfVisionOnset() { return lossOfVisionOnset; }
    public boolean isLossOfVisionPain() { return lossOfVisionPain; }
    public String getLossOfVisionDuration() { return lossOfVisionDuration; }
    public String getRednessOnset() { return rednessOnset; }
    public String getPainEye() { return painEye; }
    public boolean isPain() { return pain; }
    public boolean isRednessPain() { return rednessPain; }
    public String getWateringEye() { return wateringEye; }
    public String getPainDuration() { return painDuration; }

    public void setPatientID(String patientID) {this.patientID = patientID;}
    public void setLossOfVision(boolean loss) {this.lossOfVision = loss;}
    public void setLossOfVisionEye(String loss) {this.lossOfVisionEye = loss;}
    public void setLossOfVisionOnset(String loss) {this.lossOfVisionOnset = loss;}
    public void setLossOfVisionPain(boolean loss) {this.lossOfVisionPain = loss;}
    public void setLossOfVisionDuration(String loss) {this.lossOfVisionDuration = loss;}
    public void setRednessOnset(String redness) {this.rednessOnset = redness;}
    public void setPainEye(String painEye) {this.painEye = painEye;}
    public void setPain(boolean pain) {this.pain = pain;}
    public void setRednessPain(boolean rednessPain) {this.rednessPain = rednessPain;}
    public void setWateringEye(String wateringEye) {this.wateringEye = wateringEye;}
    public void setPainDuration(String painDuration) {this.painDuration = painDuration;}
}
