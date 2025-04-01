package com.example.backendApp.controller;

import com.example.backendApp.model.AllergyHistory;
import com.example.backendApp.repository.AllergyHistoryRepository;

import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/allergy")
public class AllergyHistoryController {

    private final AllergyHistoryRepository allergyHistoryRepository;

    public AllergyHistoryController(AllergyHistoryRepository allergyHistoryRepository) {
        this.allergyHistoryRepository = allergyHistoryRepository;
    }

    @PostMapping("/add")
    public ResponseEntity<?> addSystemicHistory(@RequestBody AllergyHistory history) {
        try {
            boolean success = allergyHistoryRepository.saveAllergyHistory(history);
            if (success) {
                return ResponseEntity.ok(Map.of("message", "Allergy History added successfully!"));
            } else {
                return ResponseEntity.status(400).body(Map.of("error", "Failed to add allergy history"));
            }
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                    .body(Map.of("error", "An error occurred while adding the history", "details", e.getMessage()));
        }
    }
}
