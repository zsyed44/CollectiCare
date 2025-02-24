package com.example.backendApp.model;

import java.util.Date;

public class Appointment {
    private String appointmentID;
    private Date dateTime;
    private String status;
    private String patientID;

    public Appointment(String appointmentID, Date dateTime, String status, String patientID) {
        this.appointmentID = appointmentID;
        this.dateTime = dateTime;
        this.status = status;
        this.patientID = patientID;
    }

    public String getAppointmentID() { return appointmentID; }
    public Date getDateTime() { return dateTime; }
    public String getStatus() { return status; }
    public String getPatientID() { return patientID; }

    public void setAppointmentID(String appointmentID) { this.appointmentID = appointmentID; }
    public void setDateTime(Date dateTime) { this.dateTime = dateTime; }
    public void setStatus(String status) { this.status = status; }
    public void setPatientID(String patientID) { this.patientID = patientID; }
}
