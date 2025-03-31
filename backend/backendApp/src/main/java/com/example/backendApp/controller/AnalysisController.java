package com.example.backendApp.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.example.backendApp.repository.AnalysisRepository;
import java.util.Map;

//controller for handling data analysis endpoints used by the dashboard.
@RestController
@RequestMapping("/api/analysis")
public class AnalysisController {

    private final AnalysisRepository analysisRepository;

    public AnalysisController(AnalysisRepository analysisRepository) {
        this.analysisRepository = analysisRepository;
    }

    //get summary statistics for all patients.Includes total patient count, average age, gender distribution, etc.
    @GetMapping("/summary")
    public ResponseEntity<?> getSummaryStatistics() {
        try {
            Map<String, Object> summary = analysisRepository.getSummaryStatistics();
            return ResponseEntity.ok(summary);
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                .body(Map.of("error", "Failed to fetch summary statistics", 
                              "details", e.getMessage()));
        }
    }

    //get age distribution of patients in predefined groups
    @GetMapping("/age-distribution")
    public ResponseEntity<?> getAgeDistribution() {
        try {
            Map<String, Object> distribution = analysisRepository.getAgeDistribution();
            return ResponseEntity.ok(distribution);
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                .body(Map.of("error", "Failed to fetch age distribution", 
                              "details", e.getMessage()));
        }
    }

    //get condition prevalence by demographic factors like gender, age group, etc.
    @GetMapping("/condition-prevalence")
    public ResponseEntity<?> getConditionPrevalence(
            @RequestParam(required = false) String demographic) {
        try {
            Map<String, Object> prevalence = analysisRepository.getConditionPrevalence(demographic);
            return ResponseEntity.ok(prevalence);
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                .body(Map.of("error", "Failed to fetch condition prevalence", 
                              "details", e.getMessage()));
        }
    }

    //get geographical distribution of eye conditions across camps.
    @GetMapping("/geographical-distribution")
    public ResponseEntity<?> getGeographicalDistribution() {
        try {
            Map<String, Object> distribution = analysisRepository.getGeographicalDistribution();
            return ResponseEntity.ok(distribution);
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                .body(Map.of("error", "Failed to fetch geographical distribution", 
                              "details", e.getMessage()));
        }
    }

    //get correlation analysis between systemic conditions and eye conditions.
    @GetMapping("/correlation-analysis")
    public ResponseEntity<?> getCorrelationAnalysis() {
        try {
            Map<String, Object> correlations = analysisRepository.getCorrelationAnalysis();
            return ResponseEntity.ok(correlations);
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                .body(Map.of("error", "Failed to fetch correlation analysis", 
                              "details", e.getMessage()));
        }
    }

    //get time series data for conditions over defined periods
    @GetMapping("/time-series")
    public ResponseEntity<?> getTimeSeriesAnalysis(
            @RequestParam(required = false) String condition,
            @RequestParam(required = false) String timeframe) {
        try {
            Map<String, Object> timeSeries = analysisRepository.getTimeSeriesAnalysis(condition, timeframe);
            return ResponseEntity.ok(timeSeries);
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                .body(Map.of("error", "Failed to fetch time series data", 
                              "details", e.getMessage()));
        }
    }

    //get patient clusters based on symptoms or other criteria.
    @GetMapping("/clusters")
    public ResponseEntity<?> getClusterAnalysis(
            @RequestParam(required = false) String clusterBy) {
        try {
            Map<String, Object> clusters = analysisRepository.getClusterAnalysis(clusterBy);
            return ResponseEntity.ok(clusters);
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                .body(Map.of("error", "Failed to fetch cluster analysis", 
                              "details", e.getMessage()));
        }
    }

    //get comparative analysis of treatment effectiveness
    @GetMapping("/comparative-analysis")
    public ResponseEntity<?> getComparativeAnalysis(
            @RequestParam(required = false) String factor) {
        try {
            Map<String, Object> analysis = analysisRepository.getComparativeAnalysis(factor);
            return ResponseEntity.ok(analysis);
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                .body(Map.of("error", "Failed to fetch comparative analysis", 
                              "details", e.getMessage()));
        }
    }

    //get risk factors for specific eye conditions.
    @GetMapping("/risk-factors")
    public ResponseEntity<?> getRiskFactors(
            @RequestParam(required = false) String condition) {
        try {
            Map<String, Object> riskFactors = analysisRepository.getRiskFactors(condition);
            return ResponseEntity.ok(riskFactors);
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                .body(Map.of("error", "Failed to fetch risk factors", 
                              "details", e.getMessage()));
        }
    }

    //get filtered data based on multiple parameters
    @PostMapping("/filter")
    public ResponseEntity<?> getFilteredData(@RequestBody Map<String, Object> filters) {
        try {
            Map<String, Object> filteredData = analysisRepository.getFilteredData(filters);
            return ResponseEntity.ok(filteredData);
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                .body(Map.of("error", "Failed to fetch filtered data", 
                              "details", e.getMessage()));
        }
    }
}
