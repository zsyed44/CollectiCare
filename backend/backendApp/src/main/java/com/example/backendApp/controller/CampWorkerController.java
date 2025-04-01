package com.example.backendApp.controller;

import com.example.backendApp.model.CampWorker;
import com.example.backendApp.repository.CampWorkerRepository;
import org.springframework.web.bind.annotation.*;

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
    
}
