package com.example.backendApp.controller;
import com.example.backendApp.model.Patient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.boot.autoconfigure.security.SecurityProperties.User;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestParam;
import com.example.backendApp.repository.PatientRepository;

import java.util.List;

@RestController
@RequestMapping("/api/patient")
public class PatientController {
    private final PatientRepository patientRepository;

    public PatientController(PatientRepository patientRepository) {
        this.patientRepository = patientRepository;
    }

    @PostMapping("/add")
    public String addPatient(@RequestBody Patient patient) {
        patientRepository.savePatient(patient);
        return "Patient added successfully!";
    }

    @GetMapping("/all")
    public List<Patient> getAllPatients() {
        return patientRepository.getAllPatients();
    }

    // get method for individual patient

    @DeleteMapping("/delete")
    public String deletePatient(@RequestParam String patientID) {
        patientRepository.deletePatient(patientID);
        return "Patient deleted successfully!";
    }
}




