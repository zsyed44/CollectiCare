package com.example.backendApp.controller;

import com.example.backendApp.model.CampWorker;
import com.example.backendApp.repository.CampWorkerRepository;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

import java.util.List;

@RestController
@RequestMapping("api/campWorkers")
public class CampWorkerController {

    private final CampWorkerRepository campWorkerRepository;

    public CampWorkerController(CampWorkerRepository campWorkerRepository) {
        this.campWorkerRepository = campWorkerRepository;
    }

    //  GET all camp workers
    @GetMapping
    public List<CampWorker> getAllCampWorkers() {
        return campWorkerRepository.getAllCampWorkers();
    }

    //  POST a new camp worker
    @PostMapping
    public String addCampWorker(@RequestBody CampWorker worker) {
        campWorkerRepository.saveCampWorker(worker);
        return "{\"message\": \"Camp worker added successfully!\"}";
    }

    //  LINK CampWorker to Camp (Graph Edge)
    @PostMapping("/{workerID}/assign/{campID}")
    public String linkWorkerToCamp(@PathVariable String workerID, @PathVariable String campID) {
        campWorkerRepository.linkWorkerToCamp(workerID, campID);
        return "Camp worker assigned to camp!";
    }

    // GET method to check if password credentials match for a health worker
    @GetMapping("/{workerID}/checkPassword/{password}")
    public String checkPassword(@PathVariable String workerID, @PathVariable String password) {
        CampWorker worker = campWorkerRepository.getCampWorkerByWorkerID(workerID);
        if (worker != null && worker.getPassword().equals(password)) {
            // Assuming the worker has a 'location' or 'campLocation' field
            String location = worker.getLocation(); // or worker.getCampLocation() depending on your model
            return "{\"message\": \"Password match!\", \"location\": \"" + location + "\"}";
        } else {
            return "{\"message\": \"Invalid worker ID or password!\"}";
        }
    }

    // PUT method to update the location of a camp worker
    @PutMapping("/{workerID}/updateLocation")
    public String updateWorkerLocation(@PathVariable String workerID, @RequestBody Map<String, String> request) {
        String location = request.get("location"); // The new location passed in the request body

        // Fetch the camp worker by workerID
        CampWorker worker = campWorkerRepository.getCampWorkerByWorkerID(workerID);

        if (worker != null) {
            // Use the repository method to update the location directly
            campWorkerRepository.updateWorkerLocation(workerID, location);

            return "{\"message\": \"Worker location updated successfully!\", \"location\": \"" + worker.getLocation() + "\"}";
        } else {
            return "{\"message\": \"Worker not found!\"}";
        }
    }


}
