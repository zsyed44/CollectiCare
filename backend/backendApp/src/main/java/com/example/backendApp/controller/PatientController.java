package com.example.backendApp.controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.boot.autoconfigure.security.SecurityProperties.User;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestParam;
import com.example.backendApp.repository.PatientRepository;


@RestController
@RequestMapping("/api") // Base URL for the API
public class PatientController {


    private PatientRepository patientRepository;

    //get patient by id
    @GetMapping("/{id}")
    public String getPatient(@RequestParam String id) {
        return patientRepository.findById(id);
    }
    
    //create patient
    @PostMapping
    public String createPatient(@RequestBody User user) {
        //whatever model is created for the usr can be used here
        return patientRepository.create(user);
    }

    //delete patient by id
    @DeleteMapping("/{id}")
    public String deletePatient(@RequestParam String id) {
        return patientRepository.delete(id);
    }
}



