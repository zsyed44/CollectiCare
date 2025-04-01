package com.example.backendApp.model;

public class CampWorker {
    private String workerID;
    private String name;
    private String role;
    private String password;

    public CampWorker(String workerID, String name, String role, String password) {
        this.workerID = workerID;
        this.name = name;
        this.role = role;
        this.password = password;
    }

    public String getWorkerID() { return workerID; }
    public String getName() { return name; }
    public String getRole() { return role; }
    public String getPassword() { return password; }

    public void setWorkerID(String workerID) {this.workerID = workerID; }
    public void setName(String name) { this.name = name; }
    public void setRole(String role) { this.role = role; }
    public void setPassword(String password) { this.password = password; }
}
