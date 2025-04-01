package com.example.backendApp.controller;

import com.example.backendApp.model.ContactLensesHistory;
import com.example.backendApp.repository.ContactLensesRepository;

import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/contactlense")
public class ContactLensesHistoryController {

    private final ContactLensesRepository contactLensesRepository;

    public ContactLensesHistoryController(ContactLensesRepository contactLensesRepository) {
        this.contactLensesRepository = contactLensesRepository;
    }

    @PostMapping("/add")
    public ResponseEntity<?> addContactLensesHistory(@RequestBody ContactLensesHistory history) {
        try {
            boolean success = contactLensesRepository.saveContactLensesHistory(history);
            if (success) {
                return ResponseEntity.ok(Map.of("message", "Contact lense History added successfully!"));
            } else {
                return ResponseEntity.status(400).body(Map.of("error", "Failed to add contact lense history"));
            }
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                    .body(Map.of("error", "An error occurred while adding the contact lense history", "details",
                            e.getMessage()));
        }
    }
}
