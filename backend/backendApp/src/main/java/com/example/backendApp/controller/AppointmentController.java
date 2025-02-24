package com.example.backendApp.controller;

import com.example.backendApp.model.Appointment;
import com.example.backendApp.repository.AppointmentRepository;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/appointments")
public class AppointmentController {

    private final AppointmentRepository appointmentRepository;

    public AppointmentController(AppointmentRepository appointmentRepository) {
        this.appointmentRepository = appointmentRepository;
    }

    // GET all appointments
    @GetMapping
    public List<Appointment> getAllAppointments() {
        return appointmentRepository.getAllAppointments();
    }

    // POST a new appointment
    @PostMapping
    public String addAppointment(@RequestBody Appointment appointment) {
        appointmentRepository.saveAppointment(appointment);
        return "Appointment added successfully!";
    }

    // DELETE an appointment
    @DeleteMapping("/{appointmentID}")
    public String deleteAppointment(@PathVariable String appointmentID) {
        appointmentRepository.deleteAppointment(appointmentID);
        return "Appointment deleted successfully!";
    }
}
