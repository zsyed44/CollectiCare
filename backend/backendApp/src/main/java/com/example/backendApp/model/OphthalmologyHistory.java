package com.example.backendApp.model;

public class OphthalmologyHistory {
    private String patientID;
    private boolean lossOfVision;
    private String lossOfVisionEye;
    private String lossOfVisionOnset;
    private boolean lossOfVisionPain;
    private String lossOfVisionDuration;
    private boolean redness;
    private String rednessEye;
    private String rednessOnset;
    private boolean rednessPain;
    private String rednessDuration;
    private String wateringEye;
    private String wateringOnset;
    private boolean wateringPain;
    private String wateringDuration;
    private String wateringDischargeType;
    private boolean itching;
    private String itchingEye;
    private String itchingDuration;
    private boolean pain;
    private String painEye;
    private String painOnset;
    private String painDuration;

    public OphthalmologyHistory(String patientID, boolean lossOfVision, String lossOfVisionEye,
            String lossOfVisionOnset,
            boolean lossOfVisionPain, String lossOfVisionDuration, boolean redness, String rednessEye,
            String rednessOnset, boolean rednessPain, String rednessDuration, String wateringEye,
            String wateringOnset, boolean wateringPain, String wateringDuration, String wateringDischargeType,
            boolean itching, String itchingEye, boolean pain, String painEye, String painOnset,
            String painDuration, String itchingDuration) {
        this.patientID = patientID;
        this.lossOfVision = lossOfVision;
        this.lossOfVisionEye = lossOfVisionEye;
        this.lossOfVisionOnset = lossOfVisionOnset;
        this.lossOfVisionPain = lossOfVisionPain;
        this.lossOfVisionDuration = lossOfVisionDuration;
        this.redness = redness;
        this.rednessEye = rednessEye;
        this.rednessOnset = rednessOnset;
        this.rednessPain = rednessPain;
        this.rednessDuration = rednessDuration;
        this.wateringEye = wateringEye;
        this.wateringOnset = wateringOnset;
        this.wateringPain = wateringPain;
        this.wateringDuration = wateringDuration;
        this.wateringDischargeType = wateringDischargeType;
        this.itching = itching;
        this.itchingDuration = itchingDuration;
        this.itchingEye = itchingEye;
        this.pain = pain;
        this.painEye = painEye;
        this.painOnset = painOnset;
        this.painDuration = painDuration;
    }

    public String getPatientID() {
        return patientID;
    }

    public boolean isLossOfVision() {
        return lossOfVision;
    }

    public String getLossOfVisionEye() {
        return lossOfVisionEye;
    }

    public String getLossOfVisionOnset() {
        return lossOfVisionOnset;
    }

    public boolean isLossOfVisionPain() {
        return lossOfVisionPain;
    }

    public String getLossOfVisionDuration() {
        return lossOfVisionDuration;
    }

    public boolean isRedness() {
        return redness;
    }

    public String getRednessEye() {
        return rednessEye;
    }

    public String getRednessOnset() {
        return rednessOnset;
    }

    public boolean isRednessPain() {
        return rednessPain;
    }

    public String getRednessDuration() {
        return rednessDuration;
    }

    public String getWateringEye() {
        return wateringEye;
    }

    public String getWateringOnset() {
        return wateringOnset;
    }

    public boolean isWateringPain() {
        return wateringPain;
    }

    public String getWateringDuration() {
        return wateringDuration;
    }

    public String getWateringDischargeType() {
        return wateringDischargeType;
    }

    public boolean isItching() {
        return itching;
    }

    public String IsItchingDuration () { return itchingDuration; }

    public String getItchingEye() {
        return itchingEye;
    }

    public boolean isPain() {
        return pain;
    }

    public String getPainEye() {
        return painEye;
    }

    public String getPainOnset() {
        return painOnset;
    }

    public String getPainDuration() {
        return painDuration;
    }

    public void setPatientID(String patientID) {
        this.patientID = patientID;
    }

    public void setLossOfVision(boolean loss) {
        this.lossOfVision = loss;
    }

    public void setLossOfVisionEye(String loss) {
        this.lossOfVisionEye = loss;
    }

    public void setLossOfVisionOnset(String loss) {
        this.lossOfVisionOnset = loss;
    }

    public void setLossOfVisionPain(boolean loss) {
        this.lossOfVisionPain = loss;
    }

    public void setLossOfVisionDuration(String loss) {
        this.lossOfVisionDuration = loss;
    }

    public void setRedness(boolean redness) {
        this.redness = redness;
    }

    public void setRednessEye(String rednessEye) {
        this.rednessEye = rednessEye;
    }

    public void setRednessOnset(String redness) {
        this.rednessOnset = redness;
    }

    public void setRednessPain(boolean rednessPain) {
        this.rednessPain = rednessPain;
    }

    public void setRednessDuration(String rednessDuration) {
        this.rednessDuration = rednessDuration;
    }

    public void setWateringEye(String wateringEye) {
        this.wateringEye = wateringEye;
    }

    public void setWateringOnset(String wateringOnset) {
        this.wateringOnset = wateringOnset;
    }

    public void setWateringPain(boolean wateringPain) {
        this.wateringPain = wateringPain;
    }

    public void setWateringDuration(String wateringDuration) {
        this.wateringDuration = wateringDuration;
    }

    public void setWateringDischargeType(String wateringDischargeType) {
        this.wateringDischargeType = wateringDischargeType;
    }

    public void setItching(boolean itching) {
        this.itching = itching;
    }

    public void setItchingDuration(String itchingDuration) { this.itchingDuration = itchingDuration; }

    public void setItchingEye(String itchingEye) {
        this.itchingEye = itchingEye;
    }

    public void setPain(boolean pain) {
        this.pain = pain;
    }

    public void setPainEye(String painEye) {
        this.painEye = painEye;
    }

    public void setPainOnset(String painOnset) {
        this.painOnset = painOnset;
    }

    public void setPainDuration(String painDuration) {
        this.painDuration = painDuration;
    }
}
