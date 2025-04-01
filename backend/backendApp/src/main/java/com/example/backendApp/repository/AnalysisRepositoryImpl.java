package com.example.backendApp.repository;

import com.orientechnologies.orient.core.db.ODatabaseDocumentInternal;
import com.orientechnologies.orient.core.db.ODatabaseRecordThreadLocal;
import com.orientechnologies.orient.core.db.ODatabaseSession;
import com.orientechnologies.orient.core.record.ORecord;
import com.orientechnologies.orient.core.record.impl.ODocument;
import com.orientechnologies.orient.core.sql.executor.OResult;
import com.orientechnologies.orient.core.sql.executor.OResultSet;

import com.example.backendApp.config.DBConfig;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.Period;
import java.time.ZoneId;
import java.util.*;
import java.util.stream.Collectors;

//implementation of the AnalysisRepository interface using OrientDB
@Repository
public class AnalysisRepositoryImpl implements AnalysisRepository {

    private final DBConfig dbConfig;

    public AnalysisRepositoryImpl(DBConfig dbConfig) {
        this.dbConfig = dbConfig;
    }

    //utility method to fetch an active database session and bind it to the current thread
    private ODatabaseSession getDatabaseSessionWithThreadBinding() {
        ODatabaseSession dbSession = dbConfig.getDatabaseSession();
        if (dbSession == null || dbSession.isClosed()) {
            throw new IllegalStateException("Database session is not available.");
        }

        //bind session to the current thread
        ODatabaseRecordThreadLocal.instance().set((ODatabaseDocumentInternal) dbSession);
        return dbSession;
    }

    @Override
    public Map<String, Object> getSummaryStatistics() {
        Map<String, Object> summary = new HashMap<>();
        ODatabaseSession dbSession = getDatabaseSessionWithThreadBinding();
        
        try {
            //total number of patients
            OResultSet totalPatientsResult = dbSession.query("SELECT count(*) as total FROM Patient");
            if (totalPatientsResult.hasNext()) {
                OResult result = totalPatientsResult.next();
                summary.put("totalPatients", result.getProperty("total"));
            }
            totalPatientsResult.close();
            
            //average age calculation
            OResultSet ageResult = dbSession.query(
                "SELECT avg(DATEDIFF('day', DOB, sysdate()) / 365.0) as avgAge FROM Patient");
            if (ageResult.hasNext()) {
                OResult result = ageResult.next();
                Object avgAge = result.getProperty("avgAge");
                if (avgAge != null) {
                    // Round to one decimal place
                    double roundedAge = Math.round(((Number) avgAge).doubleValue() * 10.0) / 10.0;
                    summary.put("averageAge", roundedAge);
                } else {
                    summary.put("averageAge", 0);
                }
            }
            ageResult.close();
            
            //gender distribution
            Map<String, Integer> genderDistribution = new HashMap<>();
            OResultSet genderResult = dbSession.query(
                "SELECT Gender, count(*) as count FROM Patient GROUP BY Gender");
            while (genderResult.hasNext()) {
                OResult result = genderResult.next();
                String gender = result.getProperty("Gender");
                Integer count = result.getProperty("count");
                
                if (gender != null) {
                    genderDistribution.put(gender, count);
                } else {
                    genderDistribution.put("Unknown", count);
                }
            }
            genderResult.close();
            summary.put("genderDistribution", genderDistribution);
            
            //most common eye condition
            OResultSet eyeConditionResult = dbSession.query(
                "SELECT EyeStatus, count(*) as count FROM Patient WHERE EyeStatus IS NOT NULL " +
                "GROUP BY EyeStatus ORDER BY count DESC LIMIT 1");
            if (eyeConditionResult.hasNext()) {
                OResult result = eyeConditionResult.next();
                summary.put("commonEyeCondition", result.getProperty("EyeStatus"));
            } else {
                summary.put("commonEyeCondition", "Unknown");
            }
            eyeConditionResult.close();
            
            //systemic conditions statistics (percentage with diabetes, hypertension, etc.)
            OResultSet systemicResult = dbSession.query(
                "SELECT " +
                "sum(case when DM = true then 1 else 0 end) * 100.0 / count(*) as diabetesPercentage, " +
                "sum(case when HTN = true then 1 else 0 end) * 100.0 / count(*) as hypertensionPercentage, " +
                "sum(case when heartDisease = true then 1 else 0 end) * 100.0 / count(*) as heartDiseasePercentage " +
                "FROM SystemicHistory");
            
            if (systemicResult.hasNext()) {
                OResult result = systemicResult.next();
                Map<String, Double> systemicConditions = new HashMap<>();
                
                Object diabetes = result.getProperty("diabetesPercentage");
                if (diabetes != null) {
                    systemicConditions.put("diabetes", Math.round(((Number) diabetes).doubleValue() * 10.0) / 10.0);
                }
                
                Object hypertension = result.getProperty("hypertensionPercentage");
                if (hypertension != null) {
                    systemicConditions.put("hypertension", Math.round(((Number) hypertension).doubleValue() * 10.0) / 10.0);
                }
                
                Object heartDisease = result.getProperty("heartDiseasePercentage");
                if (heartDisease != null) {
                    systemicConditions.put("heartDisease", Math.round(((Number) heartDisease).doubleValue() * 10.0) / 10.0);
                }
                
                summary.put("systemicConditions", systemicConditions);
            }
            systemicResult.close();
            
            //camp statistics
            OResultSet campResult = dbSession.query("SELECT count(*) as totalCamps, sum(TotalPatients) as capacitySum FROM Camp");
            if (campResult.hasNext()) {
                OResult result = campResult.next();
                summary.put("totalCamps", result.getProperty("totalCamps"));
                summary.put("totalCapacity", result.getProperty("capacitySum"));
            }
            campResult.close();
            
            return summary;
        } catch (Exception e) {
            System.err.println("Error getting summary statistics: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to get summary statistics", e);
        }
    }

    @Override
    public Map<String, Object> getAgeDistribution() {
        Map<String, Object> distribution = new HashMap<>();
        ODatabaseSession dbSession = getDatabaseSessionWithThreadBinding();
        
        try {
            List<Map<String, Object>> ageGroups = new ArrayList<>();
            
            //define age group ranges
            String[] ageGroupLabels = {"0-18", "19-40", "41-60", "61+"};
            int[] ageGroupUpperBounds = {18, 40, 60, Integer.MAX_VALUE};
            
            OResultSet patientResult = dbSession.query("SELECT PatientID, DOB FROM Patient WHERE DOB IS NOT NULL");
            
            //initialize counters for each age group
            int[] ageGroupCounts = new int[ageGroupLabels.length];
            int totalPatients = 0;
            
            LocalDate currentDate = LocalDate.now();
            
            while (patientResult.hasNext()) {
                OResult result = patientResult.next();
                Date dob = result.getProperty("DOB");
                
                if (dob != null) {
                    totalPatients++;
                    
                    //convert Date to LocalDate
                    LocalDate birthDate = dob.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
                    
                    //calculate age
                    int age = Period.between(birthDate, currentDate).getYears();
                    
                    //increment appropriate age group counter
                    for (int i = 0; i < ageGroupUpperBounds.length; i++) {
                        if (age <= ageGroupUpperBounds[i]) {
                            ageGroupCounts[i]++;
                            break;
                        }
                    }
                }
            }
            patientResult.close();
            
            //calculate percentages and create result structure
            for (int i = 0; i < ageGroupLabels.length; i++) {
                Map<String, Object> ageGroup = new HashMap<>();
                ageGroup.put("group", ageGroupLabels[i]);
                ageGroup.put("count", ageGroupCounts[i]);
                
                //only calculate percentage if there are patients
                if (totalPatients > 0) {
                    double percentage = (double) ageGroupCounts[i] / totalPatients * 100.0;
                    ageGroup.put("percentage", Math.round(percentage * 10.0) / 10.0);
                } else {
                    ageGroup.put("percentage", 0.0);
                }
                
                ageGroups.add(ageGroup);
            }
            
            distribution.put("ageGroups", ageGroups);
            distribution.put("totalPatients", totalPatients);
            
            return distribution;
        } catch (Exception e) {
            System.err.println("Error getting age distribution: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to get age distribution", e);
        }
    }

    @Override
    public Map<String, Object> getConditionPrevalence(String demographic) {
        Map<String, Object> prevalence = new HashMap<>();
        ODatabaseSession dbSession = getDatabaseSessionWithThreadBinding();
        
        try {
            // if (demographic == null || demographic.equalsIgnoreCase("gender")) {
            //     // Get condition prevalence by gender
            //     OResultSet genderResult = dbSession.query(
            //         "SELECT p.Gender, p.EyeStatus, COUNT(*) as count " +
            //         "FROM Patient p " +
            //         "WHERE p.Gender IS NOT NULL AND p.EyeStatus IS NOT NULL " +
            //         "GROUP BY p.Gender, p.EyeStatus " +
            //         "ORDER BY p.Gender, count DESC");
                
            //     Map<String, Map<String, Integer>> genderConditions = new HashMap<>();
            //     while (genderResult.hasNext()) {
            //         OResult result = genderResult.next();
            //         String gender = result.getProperty("Gender");
            //         String eyeStatus = result.getProperty("EyeStatus");
            //         Integer count = result.getProperty("count");
                    
            //         if (!genderConditions.containsKey(gender)) {
            //             genderConditions.put(gender, new HashMap<>());
            //         }
            //         genderConditions.get(gender).put(eyeStatus, count);
            //     }
            //     genderResult.close();
                
            //     prevalence.put("byGender", genderConditions);
            // }
            
            //for demo purposes, we'll add dummy data for other categories if no real data exists
            if (prevalence.isEmpty()) {
                //add some example data for the visualization
                Map<String, Map<String, Integer>> demoData = new HashMap<>();
                
                Map<String, Integer> maleConditions = new HashMap<>();
                maleConditions.put("Normal", 65);
                maleConditions.put("Myopia", 25);
                maleConditions.put("Hyperopia", 15);
                maleConditions.put("Astigmatism", 20);
                maleConditions.put("Cataracts", 13);
                
                Map<String, Integer> femaleConditions = new HashMap<>();
                femaleConditions.put("Normal", 70);
                femaleConditions.put("Myopia", 30);
                femaleConditions.put("Hyperopia", 12);
                femaleConditions.put("Astigmatism", 18);
                femaleConditions.put("Cataracts", 17);
                
                demoData.put("Male", maleConditions);
                demoData.put("Female", femaleConditions);
                
                prevalence.put("byGender", demoData);
                prevalence.put("note", "Demo data - not based on actual database records");
            }
            
            return prevalence;
        } catch (Exception e) {
            System.err.println("Error getting condition prevalence: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to get condition prevalence", e);
        }
    }

    @Override
    public Map<String, Object> getGeographicalDistribution() {
        Map<String, Object> distribution = new HashMap<>();
        ODatabaseSession dbSession = getDatabaseSessionWithThreadBinding();
        
        try {

            
            // for demo purposes, add eye condition distribution by location
            // in a real implementation, this would involve complex queries joining patients, camps, and conditions
            
            {
                List<Map<String, Object>> demoLocationData = new ArrayList<>();
                
                String[] locations = {"London", "Montreal", "Toronto"};
                String[] conditions = {"Normal", "Myopia", "Hyperopia", "Astigmatism", "Cataracts"};
                Random random = new Random();
                
                for (String location : locations) {
                    Map<String, Object> locationStats = new HashMap<>();
                    locationStats.put("location", location);
                    
                    Map<String, Integer> conditionCounts = new HashMap<>();
                    for (String condition : conditions) {
                        conditionCounts.put(condition, 10 + random.nextInt(90));
                    }
                    locationStats.put("conditions", conditionCounts);
                    locationStats.put("totalPatients", conditionCounts.values().stream().mapToInt(Integer::intValue).sum());
                    
                    demoLocationData.add(locationStats);
                }
                
                distribution.put("conditionsByLocation", demoLocationData);
                distribution.put("note", "Demo data - not based on actual database records");
            }
            
            return distribution;
        } catch (Exception e) {
            System.err.println("Error getting geographical distribution: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to get geographical distribution", e);
        }
    }

    @Override
    public Map<String, Object> getCorrelationAnalysis() {
        Map<String, Object> correlations = new HashMap<>();
        
        try {
            // This would typically involve complex statistical analysis
            // For this demo, we'll create a correlation matrix between systemic and eye conditions
            
            //define the conditions we'll analyze
            String[] eyeConditions = {"Normal", "Myopia", "Hyperopia", "Astigmatism", "Cataracts", "Glaucoma"};
            String[] systemicConditions = {"Diabetes", "Hypertension", "Heart Disease", "None"};
            
            //create a correlation matrix (in real implementation, this would be computed from actual data)
            List<Map<String, Object>> correlationMatrix = new ArrayList<>();
            Random random = new Random();
            
            for (String eyeCondition : eyeConditions) {
                Map<String, Object> correlationRow = new HashMap<>();
                correlationRow.put("eyeCondition", eyeCondition);
                
                Map<String, Double> systemicCorrelations = new HashMap<>();
                for (String systemicCondition : systemicConditions) {
                    //generate a correlation coefficient between -0.1 and 0.8 (biased toward positive)
                    double correlation = (random.nextDouble() * 0.9) - 0.1;
                    //round to 2 decimal places
                    correlation = Math.round(correlation * 100.0) / 100.0;
                    systemicCorrelations.put(systemicCondition, correlation);
                }
                correlationRow.put("correlations", systemicCorrelations);
                
                correlationMatrix.add(correlationRow);
            }
            
            correlations.put("correlationMatrix", correlationMatrix);
            correlations.put("note", "Demo correlation data - for illustration purposes only");
            
            return correlations;
        } catch (Exception e) {
            System.err.println("Error getting correlation analysis: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to get correlation analysis", e);
        }
    }

    @Override
    public Map<String, Object> getTimeSeriesAnalysis(String condition, String timeframe) {
        Map<String, Object> timeSeries = new HashMap<>();
        
        try {
            // In a real implementation, this would query appointment data over time
            // For demo purposes, we'll generate time series data for the last 12 months
            
            String[] monthNames = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", 
                                   "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
            
            String[] conditions = (condition != null) ? 
                new String[]{condition} : 
                new String[]{"Myopia", "Hyperopia", "Astigmatism", "Cataracts", "Glaucoma"};
            
            List<Map<String, Object>> monthlyData = new ArrayList<>();
            Random random = new Random();
            
            //generate data for each month
            for (int i = 0; i < monthNames.length; i++) {
                Map<String, Object> monthData = new HashMap<>();
                monthData.put("month", monthNames[i]);
                
                Map<String, Integer> conditionCounts = new HashMap<>();
                for (String cond : conditions) {
                    //base value with some randomness and trend (increasing over time)
                    int baseValue = 20 + (i / 2);
                    int value = baseValue + random.nextInt(10) - 5; // +/- 5 from base value
                    conditionCounts.put(cond, Math.max(0, value));
                }
                monthData.put("conditions", conditionCounts);
                
                monthlyData.add(monthData);
            }
            
            timeSeries.put("monthlyData", monthlyData);
            timeSeries.put("conditions", Arrays.asList(conditions));
            timeSeries.put("note", "Demo time series data - for illustration purposes only");
            
            return timeSeries;
        } catch (Exception e) {
            System.err.println("Error getting time series analysis: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to get time series analysis", e);
        }
    }

    @Override
    public Map<String, Object> getClusterAnalysis(String clusterBy) {
        Map<String, Object> clusters = new HashMap<>();
        
        try {
            // In a real implementation, this would involve clustering algorithms
            // For demo purposes, we'll create mock clusters
            
            String clusteringDimension = (clusterBy != null) ? clusterBy : "symptoms";
            
            if ("symptoms".equalsIgnoreCase(clusteringDimension)) {
                //symptom-based clusters
                List<Map<String, Object>> symptomClusters = new ArrayList<>();
                
                String[] clusterNames = {"Vision Loss", "Pain & Redness", "Watering & Itching", "Mixed Symptoms"};
                String[][] symptoms = {
                    {"Vision Loss", "Blurry Vision", "Night Blindness"},
                    {"Eye Pain", "Redness", "Light Sensitivity"},
                    {"Watering", "Itching", "Discharge"},
                    {"Vision Loss", "Pain", "Watering"}
                };
                
                Random random = new Random();
                
                for (int i = 0; i < clusterNames.length; i++) {
                    Map<String, Object> cluster = new HashMap<>();
                    cluster.put("name", clusterNames[i]);
                    cluster.put("symptoms", Arrays.asList(symptoms[i]));
                    cluster.put("patientCount", 30 + random.nextInt(50));
                    cluster.put("averageAge", 30 + random.nextInt(30));
                    
                    symptomClusters.add(cluster);
                }
                
                clusters.put("symptomClusters", symptomClusters);
            } else if ("location".equalsIgnoreCase(clusteringDimension)) {
                //location-based clusters
                List<Map<String, Object>> locationClusters = new ArrayList<>();
                
                String[] locations = {"London", "Montreal", "Toronto"};
                String[][] commonConditions = {
                    {"Myopia", "Hyperopia", "Astigmatism"},
                    {"Cataracts", "Glaucoma", "Dry Eye"},
                    {"Conjunctivitis", "Myopia", "Presbyopia"}
                };
                
                Random random = new Random();
                
                for (int i = 0; i < locations.length; i++) {
                    Map<String, Object> cluster = new HashMap<>();
                    cluster.put("location", locations[i]);
                    cluster.put("commonConditions", Arrays.asList(commonConditions[i]));
                    cluster.put("patientCount", 50 + random.nextInt(100));
                    
                    locationClusters.add(cluster);
                }
                
                clusters.put("locationClusters", locationClusters);
            }
            
            clusters.put("clusteringDimension", clusteringDimension);
            clusters.put("note", "Demo clustering data - for illustration purposes only");
            
            return clusters;
        } catch (Exception e) {
            System.err.println("Error getting cluster analysis: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to get cluster analysis", e);
        }
    }

    @Override
    public Map<String, Object> getComparativeAnalysis(String factor) {
        Map<String, Object> analysis = new HashMap<>();
        
        try {
            // In a real implementation, this would involve statistical comparison
            // For demo purposes, we'll create mock comparative data
            
            String comparisonFactor = (factor != null) ? factor : "demographic";
            
            if ("demographic".equalsIgnoreCase(comparisonFactor)) {
                // treatment effectiveness by demographic factors
                List<Map<String, Object>> demographicComparisons = new ArrayList<>();
                
                String[] demographics = {"Age < 30", "Age 30-60", "Age > 60", "Male", "Female"};
                String[] treatments = {"Medication", "Surgery", "Therapy", "Combined"};
                
                Random random = new Random();
                
                for (String demographic : demographics) {
                    Map<String, Object> comparison = new HashMap<>();
                    comparison.put("demographic", demographic);
                    
                    Map<String, Double> effectivenessRates = new HashMap<>();
                    for (String treatment : treatments) {
                        // effectiveness percentage 50-95%
                        double effectiveness = 50.0 + random.nextDouble() * 45.0;
                        effectivenessRates.put(treatment, Math.round(effectiveness * 10.0) / 10.0);
                    }
                    comparison.put("treatmentEffectiveness", effectivenessRates);
                    
                    demographicComparisons.add(comparison);
                }
                
                analysis.put("demographicComparisons", demographicComparisons);
            } else if ("timing".equalsIgnoreCase(comparisonFactor)) {
                // early vs delayed intervention
                List<Map<String, Object>> timingComparisons = new ArrayList<>();
                
                String[] timings = {"Immediate (<1 week)", "Early (1-4 weeks)", "Delayed (1-3 months)", "Late (>3 months)"};
                String[] outcomes = {"Full Recovery", "Partial Recovery", "No Improvement", "Complication"};
                
                Random random = new Random();
                
                for (String timing : timings) {
                    Map<String, Object> comparison = new HashMap<>();
                    comparison.put("interventionTiming", timing);
                    
                    Map<String, Double> outcomePercentages = new HashMap<>();
                    
                    // For demonstration, make early intervention more effective
                    double baseRecoveryRate = timing.contains("Immediate") ? 85.0 :
                                             timing.contains("Early") ? 70.0 :
                                             timing.contains("Delayed") ? 50.0 : 30.0;
                    
                    // full recovery
                    double fullRecovery = baseRecoveryRate + random.nextDouble() * 10.0 - 5.0;
                    fullRecovery = Math.min(95.0, Math.max(5.0, fullRecovery));
                    outcomePercentages.put(outcomes[0], Math.round(fullRecovery * 10.0) / 10.0);
                    
                    // partial recovery
                    double partialRecovery = (100.0 - fullRecovery) * 0.7 + random.nextDouble() * 10.0 - 5.0;
                    partialRecovery = Math.min(90.0, Math.max(5.0, partialRecovery));
                    outcomePercentages.put(outcomes[1], Math.round(partialRecovery * 10.0) / 10.0);
                    
                    // calculate remaining percentages
                    double remaining = 100.0 - fullRecovery - partialRecovery;
                    
                    // no improvement
                    double noImprovement = remaining * 0.6 + random.nextDouble() * 5.0 - 2.5;
                    noImprovement = Math.min(remaining - 1.0, Math.max(0.0, noImprovement));
                    outcomePercentages.put(outcomes[2], Math.round(noImprovement * 10.0) / 10.0);
                    
                    // complication
                    double complication = remaining - noImprovement;
                    outcomePercentages.put(outcomes[3], Math.round(complication * 10.0) / 10.0);
                    
                    comparison.put("outcomes", outcomePercentages);
                    timingComparisons.add(comparison);
                }
                
                analysis.put("timingComparisons", timingComparisons);
            }
            
            analysis.put("comparisonFactor", comparisonFactor);
            analysis.put("note", "Demo comparative data - for illustration purposes only");
            
            return analysis;
        } catch (Exception e) {
            System.err.println("Error getting comparative analysis: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to get comparative analysis", e);
        }
    }

    @Override
    public Map<String, Object> getRiskFactors(String condition) {
        Map<String, Object> riskFactors = new HashMap<>();
        
        try {
            // In a real implementation, this would involve statistical analysis of risk factors
            // For demo purposes, we'll create mock risk factor data
            
            String targetCondition = (condition != null) ? condition : "Glaucoma";
            
            List<Map<String, Object>> factors = new ArrayList<>();
            
            //define risk factors based on condition
            if ("Glaucoma".equalsIgnoreCase(targetCondition)) {
                factors.add(createRiskFactor("Age > 60", 4.2, "Strong"));
                factors.add(createRiskFactor("Family History", 3.8, "Strong"));
                factors.add(createRiskFactor("Hypertension", 2.5, "Moderate"));
                factors.add(createRiskFactor("Diabetes", 2.1, "Moderate"));
                factors.add(createRiskFactor("Myopia", 1.7, "Weak"));
            } else if ("Cataracts".equalsIgnoreCase(targetCondition)) {
                factors.add(createRiskFactor("Age > 65", 5.0, "Strong"));
                factors.add(createRiskFactor("Diabetes", 3.2, "Strong"));
                factors.add(createRiskFactor("Smoking", 2.8, "Moderate"));
                factors.add(createRiskFactor("UV Exposure", 2.4, "Moderate"));
                factors.add(createRiskFactor("Steroid Use", 1.9, "Weak"));
            } else if ("Myopia".equalsIgnoreCase(targetCondition)) {
                factors.add(createRiskFactor("Genetic Predisposition", 3.6, "Strong"));
                factors.add(createRiskFactor("Extended Near Work", 2.7, "Moderate"));
                factors.add(createRiskFactor("Limited Outdoor Time", 2.3, "Moderate"));
                factors.add(createRiskFactor("Early Digital Device Use", 1.8, "Weak"));
            } else {
                // Default risk factors for other conditions
                factors.add(createRiskFactor("Age", 3.0, "Moderate"));
                factors.add(createRiskFactor("Family History", 2.5, "Moderate"));
                factors.add(createRiskFactor("Environmental Factors", 1.8, "Weak"));
            }
            
            riskFactors.put("condition", targetCondition);
            riskFactors.put("riskFactors", factors);
            riskFactors.put("note", "Demo risk factor data - for illustration purposes only");
            
            return riskFactors;
        } catch (Exception e) {
            System.err.println("Error getting risk factors: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to get risk factors", e);
        }
    }
    
    private Map<String, Object> createRiskFactor(String name, double riskRatio, String significance) {
        Map<String, Object> factor = new HashMap<>();
        factor.put("factor", name);
        factor.put("riskRatio", Math.round(riskRatio * 10.0) / 10.0);
        factor.put("significance", significance);
        return factor;
    }

    @Override
    public Map<String, Object> getFilteredData(Map<String, Object> filters) {
        Map<String, Object> filteredData = new HashMap<>();
        
        try {
            // In a real implementation, this would build and execute queries based on filters
            // For demo purposes, we'll create mock filtered data
            
            //extract filters
            String ageGroup = filters.containsKey("ageGroup") ? (String) filters.get("ageGroup") : "All";
            String gender = filters.containsKey("gender") ? (String) filters.get("gender") : "All";
            String region = filters.containsKey("region") ? (String) filters.get("region") : "All";
            String condition = filters.containsKey("condition") ? (String) filters.get("condition") : "All";
            
            //store applied filters
            filteredData.put("appliedFilters", Map.of(
                "ageGroup", ageGroup,
                "gender", gender,
                "region", region,
                "condition", condition
            ));
            
            //generate dummy data based on filters
            Random random = new Random();
            
            //patient distribution
            int totalPatients = 100 + random.nextInt(200);
            
            //apply filter modifiers
            if (!"All".equals(ageGroup)) {
                totalPatients = totalPatients / 4 + random.nextInt(50);
            }
            if (!"All".equals(gender)) {
                totalPatients = totalPatients / 2 + random.nextInt(30);
            }
            if (!"All".equals(region)) {
                totalPatients = totalPatients / 3 + random.nextInt(40);
            }
            if (!"All".equals(condition)) {
                totalPatients = totalPatients / 5 + random.nextInt(20);
            }
            
            filteredData.put("patientCount", totalPatients);
            
            //generate condition distribution
            List<Map<String, Object>> conditionDistribution = new ArrayList<>();
            String[] conditions = {"Normal", "Myopia", "Hyperopia", "Astigmatism", "Cataracts", "Glaucoma"};
            
            //if specific condition is selected, make it dominant
            if (!"All".equals(condition)) {
                Map<String, Object> selectedCondition = new HashMap<>();
                selectedCondition.put("condition", condition);
                selectedCondition.put("count", totalPatients);
                selectedCondition.put("percentage", 100.0);
                
                conditionDistribution.add(selectedCondition);
            } else {
                int remainingPatients = totalPatients;
                
                for (int i = 0; i < conditions.length; i++) {
                    Map<String, Object> conditionData = new HashMap<>();
                    conditionData.put("condition", conditions[i]);
                    
                    int count;
                    if (i == conditions.length - 1) {
                        //last condition gets remainder
                        count = remainingPatients;
                    } else {
                        //allocate random portion of remaining patients
                        count = (int) (remainingPatients * (0.1 + random.nextDouble() * 0.3));
                        remainingPatients -= count;
                    }
                    
                    conditionData.put("count", count);
                    double percentage = (double) count / totalPatients * 100.0;
                    conditionData.put("percentage", Math.round(percentage * 10.0) / 10.0);
                    
                    conditionDistribution.add(conditionData);
                }
            }
            
            filteredData.put("conditionDistribution", conditionDistribution);
            filteredData.put("note", "Demo filtered data - for illustration purposes only");
            
            return filteredData;
        } catch (Exception e) {
            System.err.println("Error getting filtered data: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to get filtered data", e);
        }
    }
}