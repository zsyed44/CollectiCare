package com.example.backendApp.controller;

import com.example.backendApp.model.OphthalmologyHistory;
import com.example.backendApp.repository.OphthalmologyHistoryRepository;

import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/ophthalmology")
public class OphthalmologyHistoryController {

    private final OphthalmologyHistoryRepository ophthalmologyHistoryRepository;

    public OphthalmologyHistoryController(OphthalmologyHistoryRepository ophthalmologyHistoryRepository) {
        this.ophthalmologyHistoryRepository = ophthalmologyHistoryRepository;
    }

    @PostMapping("/add")
    public ResponseEntity<?> addOphthalmologyHistory(@RequestBody OphthalmologyHistory history) {
        try {
            boolean success = ophthalmologyHistoryRepository.saveOphthalmologyHistory(history);
            if (success) {
                return ResponseEntity.ok(Map.of("message", "Ophthalmology History added successfully!"));
            } else {
                return ResponseEntity.status(400).body(Map.of("error", "Failed to add Ophthalmology history"));
            }
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                    .body(Map.of("error", "An error occurred while adding the history", "details", e.getMessage()));
        }
    }
}
