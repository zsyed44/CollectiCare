package com.example.backendApp.controller;

import com.example.backendApp.model.SystemicHistory;
import com.example.backendApp.repository.SystemicHistoryRepository;

import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/systemic")
public class SystemicHistoryController {

    private final SystemicHistoryRepository systemicHistoryRepository;

    public SystemicHistoryController(SystemicHistoryRepository systemicHistoryRepository) {
        this.systemicHistoryRepository = systemicHistoryRepository;
    }

    @PostMapping("/add")
    public ResponseEntity<?> addSystemicHistory(@RequestBody SystemicHistory history) {
        try {
            boolean success = systemicHistoryRepository.saveSystemicHistory(history);
            if (success) {
                return ResponseEntity.ok(Map.of("message", "History added successfully!"));
            } else {
                return ResponseEntity.status(400).body(Map.of("error", "Failed to add history"));
            }
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                    .body(Map.of("error", "An error occurred while adding the history", "details", e.getMessage()));
        }
    }
}
