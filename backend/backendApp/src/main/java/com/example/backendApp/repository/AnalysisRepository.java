package com.example.backendApp.repository;

import java.util.Map;

//repository interface for data analysis operations.
public interface AnalysisRepository {
    
    //get summary statistics for dashboard.
    Map<String, Object> getSummaryStatistics();
    
    //get age distribution of patients.
    Map<String, Object> getAgeDistribution();
    
    //get condition prevalence by demographic factors. Optional parameter specifying which demographic to analyze (gender, age, location)
    Map<String, Object> getConditionPrevalence(String demographic);
    
    //get geographical distribution of eye conditions.
    Map<String, Object> getGeographicalDistribution();
    
    //get correlation between systemic conditions and eye conditions.
    Map<String, Object> getCorrelationAnalysis();
    
    /**
        get time series data for conditions.
        optional parameter to filter by condition type
        optional parameter to specify time granularity (monthly, quarterly, yearly)
     */
    Map<String, Object> getTimeSeriesAnalysis(String condition, String timeframe);
    
    //get patient clusters based on specified criteria. Optional parameter to specify clustering criteria (symptoms, location, etc.)
    Map<String, Object> getClusterAnalysis(String clusterBy);
    
    //get comparative analysis of treatment effectiveness. Optional parameter to specify comparison factor (demographics, intervention timing, etc.)
    Map<String, Object> getComparativeAnalysis(String factor);
    
    //get risk factors for specific eye conditions. Optional parameter to specify the condition
    Map<String, Object> getRiskFactors(String condition);
    
    //get filtered data based on multiple parameters. Map of filter criteria (age, gender, location, condition, etc.)
    Map<String, Object> getFilteredData(Map<String, Object> filters);
}