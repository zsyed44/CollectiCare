// package com.example.backendApp.controller;

// import com.example.backendApp.model.RegisterRequest;

// import java.util.Map;

// import org.springframework.web.bind.annotation.*;

// @RestController
// @RequestMapping("/api/auth")
// public class RegisterController {

//    @PostMapping("/register")
//    public Map<String, Object> register(@RequestBody RegisterRequest request) {
//        try {
//            // Save to database
//            saveUserData(request);
//            return Map.of(
//                "success", true,
//                "message", "Registration successful"
//            );
//        } catch (Exception e) {
//            return Map.of(
//                "success", false,
//                "message", "Registration failed: " + e.getMessage()
//            );
//        }
//    }

//    private void saveUserData(RegisterRequest request) {
//        // Reminder: Implement database storage logic in the method
//    }
// }