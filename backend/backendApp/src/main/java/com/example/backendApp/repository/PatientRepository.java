package com.example.backendApp.repository;

import org.springframework.boot.autoconfigure.security.SecurityProperties.User;

//THIS WILL BE USED TO CONNECT TO THE DATABASE

public class PatientRepository {
    
    public String findById(String id) {
        //This will be used to get the patient by id
        //get the patient from the database
        return "Patient with id: " + id;
    }

    public String create(User user) {
        //This will be used to create a patient
        //create the patient in the database
        return "Patient created with data: " + user;
    }

    public String delete(String id) {
        //This will be used to delete a patient
        //delete the patient from the database
        return "Patient deleted with id: " + id;
    }
}
