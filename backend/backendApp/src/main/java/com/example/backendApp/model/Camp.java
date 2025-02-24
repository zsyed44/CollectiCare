package com.example.backendApp.model;

public class Camp {
    private String campID;
    private String location;
    private String gisCoordinates;
    private int totalPatients;

    public Camp(String campID, String location, String gisCoordinates, int totalPatients) {
        this.campID = campID;
        this.location = location;
        this.gisCoordinates = gisCoordinates;
        this.totalPatients = totalPatients;
    }

    public String getCampID() { return campID; }
    public String getLocation() { return location; }
    public String getGisCoordinates() { return gisCoordinates; }
    public int getTotalPatients() { return totalPatients; }

    public void setCampID(String campID) { this.campID = campID; }
    public void setLocation(String location) { this.location = location; }
    public void setGisCoordinates(String gisCoordinates) {
        this.gisCoordinates = gisCoordinates;
    }
    public void setTotalPatients(int totalPatients) { this.totalPatients = totalPatients; }
}
