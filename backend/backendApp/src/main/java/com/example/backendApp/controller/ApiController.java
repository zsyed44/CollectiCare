package com.example.backendApp.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


//FOR TESTING PURPOSES ONLY 
//NOT PART OF PROJECT

@RestController
@RequestMapping("/api") // Base URL for the API

public class ApiController {

    @GetMapping("/hello")
    public String hello() {
        return "Hello, World";
    }

    @PostMapping("/create")
    public String createTemp(@RequestBody String data) {
        return "We got the Data: " + data;
    }
}
