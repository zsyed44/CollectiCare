package com.example.backendApp.model;

public class AllergyHistory {
    private String patientID;
    private boolean allergyDrops;
    private boolean allergyTablets;
    private boolean seasonalAllergies;

    public AllergyHistory(String patientID, boolean allergyDrops, boolean allergyTablets, boolean seasonalAllergies) {
        this.patientID = patientID;
        this.allergyDrops = allergyDrops;
        this.allergyTablets = allergyTablets;
        this.seasonalAllergies = seasonalAllergies;
    }

    public String getPatientID() { return patientID; }
    public boolean isAllergyDrops() { return allergyDrops; }
    public boolean isAllergyTablets() { return allergyTablets; }
    public boolean isSeasonalAllergies() { return seasonalAllergies; }

    public void setPatientID(String patientID) { this.patientID = patientID; }
    public void setAllergyDrops(boolean allergyDrops) {this.allergyDrops = allergyDrops; }
    public void setAllergyTablets(boolean allergyTablets) {this.allergyTablets = allergyTablets; }
    public void setSeasonalAllergies(boolean seasonalAllergies) { this.seasonalAllergies = seasonalAllergies; }


}
