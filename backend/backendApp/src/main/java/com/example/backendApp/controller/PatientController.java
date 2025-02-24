package com.example.backendApp.controller;

import com.example.backendApp.model.Patient;
import com.example.backendApp.repository.PatientRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.Period;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/patient")
public class PatientController {
    private final PatientRepository patientRepository;

    public PatientController(PatientRepository patientRepository) {
        this.patientRepository = patientRepository;
    }

    /**
     * Fetch all patients from the database.
     */
    @GetMapping("/all")
    public ResponseEntity<?> getAllPatients() {
        try {
            List<Patient> patients = patientRepository.getAllPatients();
            if (patients.isEmpty()) {
                return ResponseEntity.ok(Map.of("message", "No patients found."));
            }
            return ResponseEntity.ok(patients);
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                    .body(Map.of("error", "An error occurred while fetching patients", "details", e.getMessage()));
        }
    }

    /**
     * Fetch a specific patient by their PatientID.
     */
    @GetMapping("/{patientID}")
    public ResponseEntity<?> getPatientById(@PathVariable String patientID) {
        try {
            Optional<Patient> patient = patientRepository.getPatientById(patientID);
            return patient.map(ResponseEntity::ok)
                    .orElseGet(() -> ResponseEntity.status(404)
                            .body((Patient) Map.of("error", "Patient not found")));
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                    .body(Map.of("error", "An error occurred while fetching the patient", "details", e.getMessage()));
        }
    }

    /**
     * Fetch specific details of a patient: Name, Age, DOB, Eye Status, and Health Camp Address.
     * This method returns a hardcoded response for now.
     */
    @GetMapping("/{patientID}/summary")
    public ResponseEntity<?> getPatientSummary(@PathVariable String patientID) {
        try {
            Optional<Patient> patient = patientRepository.getPatientById(patientID);
            if (patient.isPresent()) {
                Patient p = patient.get();

                // Default filler values
                String eyeStatus = "Normal";  // Default assumption
                String healthCampAddress = "Unknown Health Camp";  // Default placeholder

                // Calculate age from DOB
                int age = calculateAge(p.getDob());

                // Prepare response
                Map<String, Object> summary = Map.of(
                        "Name", p.getName(),
                        "Age", age,
                        "DOB", p.getDob(),
                        "Eye Status", eyeStatus,
                        "Health Camp Address", healthCampAddress
                );
                return ResponseEntity.ok(summary);
            } else {
                return ResponseEntity.status(404)
                        .body(Map.of("error", "Patient not found"));
            }
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                    .body(Map.of("error", "An error occurred while fetching patient summary", "details", e.getMessage()));
        }
    }

    /**
     * Calculates age from the given date of birth.
     */
    private int calculateAge(Date dob) {
        if (dob == null) return 0; // Default value if DOB is missing
        LocalDate birthDate = dob.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
        LocalDate currentDate = LocalDate.now();
        return Period.between(birthDate, currentDate).getYears();
    }

    /**
     * Create a new patient.
     */
    @PostMapping("/add")
    public ResponseEntity<?> createPatient(@RequestBody Patient patient) {
        try {
            boolean success = patientRepository.addPatient(patient);
            if (success) {
                return ResponseEntity.ok(Map.of("message", "Patient added successfully!"));
            } else {
                return ResponseEntity.status(400).body(Map.of("error", "Failed to add patient"));
            }
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                    .body(Map.of("error", "An error occurred while adding the patient", "details", e.getMessage()));
        }
    }

    /**
     * Delete a patient by PatientID.
     */
    @DeleteMapping("/delete")
    public ResponseEntity<?> deletePatient(@RequestParam String patientID) {
        try {
            boolean deleted = patientRepository.deletePatient(patientID);
            if (deleted) {
                return ResponseEntity.ok(Map.of("message", "Patient deleted successfully!"));
            } else {
                return ResponseEntity.status(404)
                        .body(Map.of("error", "Patient not found or could not be deleted"));
            }
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                    .body(Map.of("error", "An error occurred while deleting the patient", "details", e.getMessage()));
        }
    }
}
