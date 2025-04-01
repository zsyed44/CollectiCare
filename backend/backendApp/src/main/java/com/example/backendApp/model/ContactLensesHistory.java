package com.example.backendApp.model;

public class ContactLensesHistory {
    private String patientID;
    private String frequency;
    private boolean usesContactLenses;
    private Integer yearsOfUse;

    public ContactLensesHistory(String patientID, String frequency, boolean usesContactLenses, Integer yearsOfUse) {
        this.patientID = patientID;
        this.frequency = frequency;
        this.usesContactLenses = usesContactLenses;
        this.yearsOfUse = yearsOfUse;
    }

    public String getPatientID() {
        return patientID;
    }

    public String isFrequency() {
        return frequency;
    }

    public boolean isUsesContactLenses() {
        return usesContactLenses;
    }

    public Integer isyearsOfUse() {
        return yearsOfUse;
    }

    public void setPatientID(String patientID) {
        this.patientID = patientID;
    }

    public void setAllergyDrops(String frequency) {
        this.frequency = frequency;
    }

    public void setAllergyTablets(boolean usesContactLenses) {
        this.usesContactLenses = usesContactLenses;
    }

    public void setSeasonalAllergies(Integer yearsOfUse) {
        this.yearsOfUse = yearsOfUse;
    }

}
