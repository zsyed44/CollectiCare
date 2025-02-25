//package com.example.backendApp.controller;
//
//import com.example.backendApp.model.LoginRequest;
//import org.springframework.web.bind.annotation.*;
//
//@RestController
//@RequestMapping('/api/auth');
//public class LoginController {
//    @PostMapping("/login")
//    public LoginResponse authenticate(@RequestBody LoginRequest loginRequest){
//        boolean isAuthenticated = verifyUser(request.getID(), request.getPhoto()); // verify id and photo
//
//        if (isAuthenticated){
//            return new LoginResponse(true, "Login Successful");
//        } else {
//            return new LoginResponse(false, "Authentication Failed");
//        }
//    }
//
//    private boolean verifyUser(String iD, byte[] photo){
//        // Reminder: Implement face recognition in this method
//        return true;
//    }
//
//}