import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math';
import 'services/api_service.dart'; // Assuming api_service.dart is in lib/services

// Helper classes for chart data points
class _ChartData {
  final String x; // Category or Label
  final num y;   // Value
  final String? group; // Optional grouping category
  _ChartData(this.x, this.y, {this.group});
}

class _ScatterData {
    final String x; // Eye Condition - Systemic Condition Label
    final double y; // Correlation Coefficient
     _ScatterData(this.x, this.y);
}

class _TimeSeriesData {
  final String x; // Month
  final num y; // Count
  final String seriesName; // Condition Name
  _TimeSeriesData(this.x, this.y, this.seriesName);
}

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TooltipBehavior _tooltipBehavior;

  // Data states
  bool _isLoading = true;
  String? _errorMessage;

  // Data containers - using specific types where possible for clarity
  Map<String, dynamic> _summaryData = {};
  Map<String, dynamic> _ageDistributionData = {};
  Map<String, dynamic> _conditionPrevalenceData = {};
  Map<String, dynamic> _geographicalData = {};
  Map<String, dynamic> _correlationData = {};
  Map<String, dynamic> _timeSeriesData = {};
  Map<String, dynamic> _clusterData = {};
  Map<String, dynamic> _comparativeData = {};
  Map<String, dynamic> _riskFactorData = {};

  @override
  void initState() {
    super.initState();
    // Updated tab controller length
    _tabController = TabController(length: 6, vsync: this);
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      canShowMarker: true, // Ensure marker is shown for scatter/line
      // Format adjusted for different chart types later if needed
      format: 'point.x : point.y',
      header: '' // Remove header for cleaner look
    );
    _loadDashboardData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Load initial dashboard data
  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Fetch all data points concurrently for faster loading
      final results = await Future.wait([
        ApiService.getAnalysisSummary(),
        ApiService.getAgeDistribution(),
        // Fetching prevalence by gender as per existing chart
        ApiService.getConditionPrevalence('gender'),
        ApiService.getGeographicalDistribution(),
        ApiService.getCorrelationAnalysis(),
        // Fetching default time series
        ApiService.getTimeSeriesAnalysis(),
        // Fetching default clusters (symptoms)
        ApiService.getClusterAnalysis('symptoms'),
        // Fetching default comparative analysis (demographic)
        ApiService.getComparativeAnalysis('demographic'),
        // Fetching default risk factors (Glaucoma)
        ApiService.getRiskFactors('Glaucoma'),
      ]);

      // Assign results to state variables
      _summaryData = results[0] as Map<String, dynamic>;
      _ageDistributionData = results[1] as Map<String, dynamic>;
      _conditionPrevalenceData = results[2] as Map<String, dynamic>;
      _geographicalData = results[3] as Map<String, dynamic>;
      _correlationData = results[4] as Map<String, dynamic>;
      _timeSeriesData = results[5] as Map<String, dynamic>;
      _clusterData = results[6] as Map<String, dynamic>;
      _comparativeData = results[7] as Map<String, dynamic>;
      _riskFactorData = results[8] as Map<String, dynamic>;

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading dashboard data: $e"); // Log the error
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
        _riskFactorData = {};
      });
    }
  }

  // --- Chart Building Functions ---

  // Generic Error Widget for Charts
  Widget _buildChartErrorWidget(String message) {
    return Container(
      height: 300, // Give it a defined height
      alignment: Alignment.center,
       margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.redAccent)
      ),
      child: Text(
        message,
        style: TextStyle(color: Colors.red[700], fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Age Distribution Pie Chart
  Widget _buildAgeDistributionChart() {
    if (_ageDistributionData.isEmpty || !_ageDistributionData.containsKey('ageGroups') || (_ageDistributionData['ageGroups'] as List).isEmpty) {
      return _buildChartErrorWidget("No age distribution data available to display.");
    }

    try {
        final List<dynamic> ageGroups = _ageDistributionData['ageGroups'];
         // Filter out any potential nulls or invalid entries
        final List<_ChartData> chartData = ageGroups
            .where((group) => group != null && group['group'] != null && group['percentage'] != null)
            .map((group) => _ChartData(
                  group['group'].toString(),
                  (group['percentage'] as num).toDouble()
                ))
            .toList();

         if (chartData.isEmpty) {
            return _buildChartErrorWidget("Processed age distribution data is empty.");
         }


        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SfCircularChart(
              title: ChartTitle(text: 'Patient Age Distribution (%)'),
              legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
              tooltipBehavior: TooltipBehavior(enable: true, format: 'point.x : point.y%'),
              series: <CircularSeries>[
                PieSeries<_ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (_ChartData data, _) => data.x,
                  yValueMapper: (_ChartData data, _) => data.y,
                  dataLabelSettings: DataLabelSettings(isVisible: true, labelPosition: ChartDataLabelPosition.outside),
                  enableTooltip: true,
                )
              ],
            ),
          ),
        );
     } catch (e) {
         print("Error building age chart: $e");
         return _buildChartErrorWidget("Error displaying age distribution chart.");
     }
  }

  // Condition Prevalence Bar Chart (Grouped by Gender)
  Widget _buildConditionPrevalenceChart() {
    if (_conditionPrevalenceData.isEmpty || !_conditionPrevalenceData.containsKey('byGender') || (_conditionPrevalenceData['byGender'] as Map).isEmpty) {
      return _buildChartErrorWidget("No condition prevalence data available.");
    }

    try {
        final Map<String, dynamic> genderData = _conditionPrevalenceData['byGender'];
        final List<_ChartData> chartData = [];
        final List<String> conditions = []; // To define the columns

        // First pass to gather all conditions and data
        genderData.forEach((gender, conditionMap) {
          if (conditionMap is Map) {
            conditionMap.forEach((condition, count) {
              if (condition != null && count != null && gender != null) {
                 final conditionStr = condition.toString();
                 if (!conditions.contains(conditionStr)) {
                     conditions.add(conditionStr);
                 }
                 chartData.add(_ChartData(conditionStr, count as num, group: gender.toString()));
              }
            });
          }
        });

         if (chartData.isEmpty) {
             return _buildChartErrorWidget("Processed condition prevalence data is empty.");
         }

        // Build series for each gender
        List<String> genders = genderData.keys.toList();
        List<CartesianSeries<_ChartData, String>> seriesList = genders.map((gender) {
          List<_ChartData> genderSpecificData = chartData.where((d) => d.group == gender).toList();
          return ColumnSeries<_ChartData, String>(
            dataSource: genderSpecificData,
            name: gender, // Legend label
            xValueMapper: (_ChartData data, _) => data.x, // Condition
            yValueMapper: (_ChartData data, _) => data.y,  // Count
            dataLabelSettings: DataLabelSettings(isVisible: true, labelAlignment: ChartDataLabelAlignment.top),
            enableTooltip: true,
          );
        }).toList();

        return Card(
          elevation: 2,
           margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
             padding: const EdgeInsets.all(8.0),
            child: SfCartesianChart(
              title: ChartTitle(text: 'Condition Prevalence by Gender'),
              primaryXAxis: CategoryAxis(
                  title: AxisTitle(text: 'Condition'),
                   majorGridLines: MajorGridLines(width: 0) // Cleaner look
              ),
              primaryYAxis: NumericAxis(
                title: AxisTitle(text: 'Number of Patients'),
                 labelFormat: '{value}', // Format as integer
                 majorTickLines: MajorTickLines(size: 0)
              ),
              legend: Legend(isVisible: true, position: LegendPosition.bottom),
              tooltipBehavior: TooltipBehavior(enable: true, header: '', format: 'point.x (series.name): point.y patients'), // Custom tooltip
              series: seriesList,
            ),
          ),
        );
     } catch (e) {
         print("Error building prevalence chart: $e");
         return _buildChartErrorWidget("Error displaying condition prevalence chart.");
     }
  }

   // Geographical Distribution Bar Chart
  Widget _buildGeographicalChart() {
    // Using 'conditionsByLocation' if available (demo data structure), fallback to 'campDistribution'
    bool useConditionsByLocation = _geographicalData.containsKey('conditionsByLocation');
    dynamic geoList = useConditionsByLocation
        ? _geographicalData['conditionsByLocation']
        : _geographicalData['campDistribution'];

    if (_geographicalData.isEmpty || geoList == null || (geoList as List).isEmpty) {
      return _buildChartErrorWidget("No geographical distribution data available.");
    }

    try {
        final List<_ChartData> chartData = (geoList as List).map((item) {
           if (item == null || item['location'] == null || item['totalPatients'] == null) return null;
          return _ChartData(
            item['location'].toString(),
            (item['totalPatients'] as num)
          );
        }).whereType<_ChartData>().toList(); // Filter out nulls

         if (chartData.isEmpty) {
             return _buildChartErrorWidget("Processed geographical data is empty.");
         }

        return Card(
          elevation: 2,
           margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SfCartesianChart(
              title: ChartTitle(text: 'Patient Distribution by Location'),
              primaryXAxis: CategoryAxis(
                   title: AxisTitle(text: 'Location'),
                   majorGridLines: MajorGridLines(width: 0)
              ),
              primaryYAxis: NumericAxis(
                  title: AxisTitle(text: 'Total Patients'),
                   labelFormat: '{value}',
                    majorTickLines: MajorTickLines(size: 0)
              ),
              tooltipBehavior: TooltipBehavior(enable: true, format: 'point.x: point.y patients'),
              series: <CartesianSeries>[
                BarSeries<_ChartData, String>( // Using BarSeries for horizontal bars
                  dataSource: chartData,
                  xValueMapper: (_ChartData data, _) => data.x,
                  yValueMapper: (_ChartData data, _) => data.y,
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                  enableTooltip: true,
                )
              ],
            ),
          ),
        );
      } catch (e) {
         print("Error building geographical chart: $e");
         return _buildChartErrorWidget("Error displaying geographical distribution chart.");
     }
  }

  // Time Series Line Chart
  Widget _buildTimeSeriesChart() {
    if (_timeSeriesData.isEmpty || !_timeSeriesData.containsKey('monthlyData') || (_timeSeriesData['monthlyData'] as List).isEmpty || !_timeSeriesData.containsKey('conditions') || (_timeSeriesData['conditions'] as List).isEmpty) {
      return _buildChartErrorWidget("No time series data available.");
    }

    try {
        final List<dynamic> monthlyData = _timeSeriesData['monthlyData'];
        final List<String> conditions = List<String>.from(_timeSeriesData['conditions']);
         final List<_TimeSeriesData> chartData = [];

         // Process data into a flat list for easier series creation
         for (var monthEntry in monthlyData) {
             if (monthEntry != null && monthEntry['month'] != null && monthEntry['conditions'] is Map) {
                 String month = monthEntry['month'].toString();
                 (monthEntry['conditions'] as Map).forEach((conditionKey, count) {
                     if (count != null && conditions.contains(conditionKey)) {
                         chartData.add(_TimeSeriesData(month, count as num, conditionKey));
                     }
                 });
             }
         }

         if (chartData.isEmpty) {
             return _buildChartErrorWidget("Processed time series data is empty.");
         }

        // Create a series for each condition
        final List<CartesianSeries<_TimeSeriesData, String>> seriesList = conditions.map((condition) {
          // Filter data for the current condition
          final List<_TimeSeriesData> conditionData = chartData.where((d) => d.seriesName == condition).toList();
          return LineSeries<_TimeSeriesData, String>(
            name: condition, // Legend label
            dataSource: conditionData,
            xValueMapper: (_TimeSeriesData data, _) => data.x, // Month
            yValueMapper: (_TimeSeriesData data, _) => data.y, // Count
            markerSettings: MarkerSettings(isVisible: true),
            enableTooltip: true,
          );
        }).toList();

        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SfCartesianChart(
              title: ChartTitle(text: 'Monthly Condition Trends'),
              primaryXAxis: CategoryAxis(
                  title: AxisTitle(text: 'Month'),
                  majorGridLines: MajorGridLines(width: 0)
              ),
              primaryYAxis: NumericAxis(
                  title: AxisTitle(text: 'Number of Cases'),
                   labelFormat: '{value}',
                   majorTickLines: MajorTickLines(size: 0)
              ),
              legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap, position: LegendPosition.bottom),
              tooltipBehavior: TooltipBehavior(enable: true, header: '', format: 'point.x - series.name: point.y cases'),
              series: seriesList,
            ),
          ),
        );
      } catch (e) {
         print("Error building time series chart: $e");
         return _buildChartErrorWidget("Error displaying time series chart.");
     }
  }

  // Correlation Scatter Plot
  Widget _buildCorrelationChart() {
    if (_correlationData.isEmpty || !_correlationData.containsKey('correlationMatrix') || (_correlationData['correlationMatrix'] as List).isEmpty) {
      return _buildChartErrorWidget("No correlation data available.");
    }

     try {
        final List<dynamic> correlationMatrix = _correlationData['correlationMatrix'];
        final List<_ScatterData> chartData = [];

        for (var row in correlationMatrix) {
           if (row != null && row['eyeCondition'] != null && row['correlations'] is Map) {
               String eyeCondition = row['eyeCondition'].toString();
               (row['correlations'] as Map).forEach((systemicCondition, value) {
                   if (value != null && systemicCondition != null) {
                       chartData.add(_ScatterData('$eyeCondition vs $systemicCondition', (value as num).toDouble()));
                   }
               });
           }
        }

        if (chartData.isEmpty) {
             return _buildChartErrorWidget("Processed correlation data is empty.");
         }

        // Sort data for better axis readability if needed, though category axis handles it
        // chartData.sort((a, b) => a.x.compareTo(b.x));

        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
             padding: const EdgeInsets.all(8.0),
            child: SfCartesianChart(
              title: ChartTitle(text: 'Systemic vs Eye Condition Correlation'),
              primaryXAxis: CategoryAxis(
                  title: AxisTitle(text: 'Condition Pair'),
                   labelIntersectAction: AxisLabelIntersectAction.rotate45, // Rotate labels if they overlap
                   majorGridLines: MajorGridLines(width: 0)
              ),
              primaryYAxis: NumericAxis(
                title: AxisTitle(text: 'Correlation Coefficient'),
                minimum: -1, // Standard correlation range
                maximum: 1,
                 majorTickLines: MajorTickLines(size: 0)
              ),
              tooltipBehavior: TooltipBehavior(enable: true, format: 'point.x\nCorrelation: point.y'),
              series: <CartesianSeries>[
                ScatterSeries<_ScatterData, String>(
                  dataSource: chartData,
                  xValueMapper: (_ScatterData data, _) => data.x, // Combined label
                  yValueMapper: (_ScatterData data, _) => data.y, // Coefficient
                  markerSettings: MarkerSettings(isVisible: true, height: 8, width: 8), // Smaller markers
                  enableTooltip: true,
                )
              ],
            ),
          ),
        );
      } catch (e) {
         print("Error building correlation chart: $e");
         return _buildChartErrorWidget("Error displaying correlation chart.");
     }
  }


  // Cluster Analysis Chart (Example: Patient Count per Symptom Cluster)
  Widget _buildClusterChart() {
    // Assuming clustering by symptoms from the backend demo data
    if (_clusterData.isEmpty || !_clusterData.containsKey('symptomClusters') || (_clusterData['symptomClusters'] as List).isEmpty) {
        // Add fallback or alternative view if needed, e.g., location clusters
         if (_clusterData.containsKey('locationClusters') && (_clusterData['locationClusters'] as List).isNotEmpty) {
             // Optionally build a chart for location clusters here
         }
      return _buildChartErrorWidget("No symptom cluster data available.");
    }

     try {
        final List<dynamic> clusters = _clusterData['symptomClusters'];
        final List<_ChartData> chartData = clusters.map((cluster) {
          if (cluster == null || cluster['name'] == null || cluster['patientCount'] == null) return null;
          return _ChartData(
            cluster['name'].toString(),
            cluster['patientCount'] as num
          );
        }).whereType<_ChartData>().toList();

         if (chartData.isEmpty) {
             return _buildChartErrorWidget("Processed cluster data is empty.");
         }


        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
             padding: const EdgeInsets.all(8.0),
            child: SfCartesianChart(
              title: ChartTitle(text: 'Patient Count by Symptom Cluster'),
              primaryXAxis: CategoryAxis(
                  title: AxisTitle(text: 'Cluster Name'),
                  majorGridLines: MajorGridLines(width: 0)
              ),
              primaryYAxis: NumericAxis(
                  title: AxisTitle(text: 'Number of Patients'),
                   labelFormat: '{value}',
                   majorTickLines: MajorTickLines(size: 0)
              ),
              tooltipBehavior: TooltipBehavior(enable: true, format: 'point.x: point.y patients'),
              series: <CartesianSeries>[
                ColumnSeries<_ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (_ChartData data, _) => data.x,
                  yValueMapper: (_ChartData data, _) => data.y,
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                  enableTooltip: true,
                )
              ],
            ),
          ),
        );
       } catch (e) {
         print("Error building cluster chart: $e");
         return _buildChartErrorWidget("Error displaying cluster analysis chart.");
     }
  }

  // Comparative Analysis Chart (Example: Treatment Effectiveness by Demographic)
  Widget _buildComparativeChart() {
     // Assuming comparison by demographic from backend demo
    if (_comparativeData.isEmpty || !_comparativeData.containsKey('demographicComparisons') || (_comparativeData['demographicComparisons'] as List).isEmpty) {
        // Add fallback for timing comparisons if needed
        return _buildChartErrorWidget("No demographic comparison data available.");
    }

     try {
        final List<dynamic> comparisons = _comparativeData['demographicComparisons'];
        final List<_ChartData> chartData = [];
         final List<String> treatments = []; // Define treatments for grouping

         comparisons.forEach((comp) {
             if (comp != null && comp['demographic'] != null && comp['treatmentEffectiveness'] is Map) {
                 String demographic = comp['demographic'].toString();
                 (comp['treatmentEffectiveness'] as Map).forEach((treatment, effectiveness) {
                     if (treatment != null && effectiveness != null) {
                         final treatmentStr = treatment.toString();
                          if (!treatments.contains(treatmentStr)) {
                              treatments.add(treatmentStr);
                          }
                         chartData.add(_ChartData(demographic, effectiveness as num, group: treatmentStr));
                     }
                 });
             }
         });

        if (chartData.isEmpty) {
             return _buildChartErrorWidget("Processed comparative data is empty.");
         }

        // Build series for each treatment type
        final List<CartesianSeries<_ChartData, String>> seriesList = treatments.map((treatment) {
          List<_ChartData> treatmentData = chartData.where((d) => d.group == treatment).toList();
          return ColumnSeries<_ChartData, String>(
            dataSource: treatmentData,
            name: treatment, // Legend label
            xValueMapper: (_ChartData data, _) => data.x, // Demographic
            yValueMapper: (_ChartData data, _) => data.y, // Effectiveness (%)
            dataLabelSettings: DataLabelSettings(isVisible: true, labelAlignment: ChartDataLabelAlignment.top), // Show percentage
            enableTooltip: true,
          );
        }).toList();


        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
             padding: const EdgeInsets.all(8.0),
            child: SfCartesianChart(
              title: ChartTitle(text: 'Treatment Effectiveness by Demographic'),
              primaryXAxis: CategoryAxis(
                  title: AxisTitle(text: 'Demographic Group'),
                   majorGridLines: MajorGridLines(width: 0)
              ),
              primaryYAxis: NumericAxis(
                title: AxisTitle(text: 'Effectiveness Rate (%)'),
                 labelFormat: '{value}%',
                 minimum: 0, // Percentage starts at 0
                 maximum: 100, // Percentage ends at 100
                 majorTickLines: MajorTickLines(size: 0)
              ),
              legend: Legend(isVisible: true, position: LegendPosition.bottom),
              tooltipBehavior: TooltipBehavior(enable: true, header: '', format: 'point.x (series.name): point.y% effective'),
              series: seriesList,
            ),
          ),
        );
      } catch (e) {
         print("Error building comparative chart: $e");
         return _buildChartErrorWidget("Error displaying comparative analysis chart.");
     }
  }


  // Risk Factor Chart (Example: Risk Ratios for Glaucoma)
  Widget _buildRiskFactorChart() {
     if (_riskFactorData.isEmpty || !_riskFactorData.containsKey('riskFactors') || (_riskFactorData['riskFactors'] as List).isEmpty) {
        return _buildChartErrorWidget("No risk factor data available.");
    }

      try {
        final List<dynamic> factors = _riskFactorData['riskFactors'];
        final String condition = _riskFactorData['condition'] ?? 'Selected Condition'; // Get condition name
        final List<_ChartData> chartData = factors.map((factor) {
           if (factor == null || factor['factor'] == null || factor['riskRatio'] == null) return null;
          return _ChartData(
            factor['factor'].toString(), // Risk factor name
            factor['riskRatio'] as num   // Risk ratio value
          );
        }).whereType<_ChartData>().toList();

         if (chartData.isEmpty) {
             return _buildChartErrorWidget("Processed risk factor data is empty.");
         }

        // Sort by risk ratio descending for better visualization
        chartData.sort((a, b) => b.y.compareTo(a.y));

        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
             padding: const EdgeInsets.all(8.0),
            child: SfCartesianChart(
              title: ChartTitle(text: 'Risk Factors for $condition'),
              primaryXAxis: CategoryAxis(
                  title: AxisTitle(text: 'Risk Factor'),
                   majorGridLines: MajorGridLines(width: 0)
              ),
              primaryYAxis: NumericAxis(
                title: AxisTitle(text: 'Risk Ratio (Odds Ratio)'),
                 labelFormat: '{value}', // Format as number
                 // minimum: 0, // Start axis at 0 or 1 depending on preference
                  majorTickLines: MajorTickLines(size: 0)
              ),
              tooltipBehavior: TooltipBehavior(enable: true, format: 'point.x\nRisk Ratio: point.y'),
              series: <CartesianSeries>[
                BarSeries<_ChartData, String>( // Horizontal bars often good for factors
                  dataSource: chartData,
                  xValueMapper: (_ChartData data, _) => data.x,
                  yValueMapper: (_ChartData data, _) => data.y,
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                  enableTooltip: true,
                )
              ],
            ),
          ),
        );
      } catch (e) {
         print("Error building risk factor chart: $e");
         return _buildChartErrorWidget("Error displaying risk factor chart.");
     }
  }


  // --- UI Building Functions ---

  // Loading Indicator
  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  // Error Display for whole page
  Widget _buildErrorDisplay() {
    return Center(
      child: Padding(
         padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            SizedBox(height: 16),
            Text(
              _errorMessage ?? "An unknown error occurred",
              style: TextStyle(color: Colors.red[700], fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.refresh),
              label: Text("Retry Loading Data"),
              onPressed: _loadDashboardData,

            ),
          ],
        ),
      ),
    );
  }

  // Stat Card Widget for Summary
  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Card(
      elevation: 2, // Reduced elevation
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0), // Adjusted padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible( // Prevent text overflow
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(icon, color: color, size: 20), // Slightly smaller icon
              ],
            ),
            SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Descriptive Tab Content
  Widget _buildDescriptiveTab() {
    if (_isLoading) return _buildLoadingIndicator();
    if (_errorMessage != null && _summaryData.isEmpty) return _buildErrorDisplay(); // Show full error if summary failed

     // Format summary data safely
    final String totalPatients = _summaryData['totalPatients']?.toString() ?? 'N/A';
    final String averageAge = _summaryData['averageAge']?.toStringAsFixed(1) ?? 'N/A'; // 1 decimal place
    final String commonCondition = _summaryData['commonEyeCondition']?.toString() ?? 'N/A';
    final String diabetesPercent = (_summaryData['systemicConditions']?['diabetes'] as num?)?.toStringAsFixed(1) ?? 'N/A';


    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Key Statistics',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16),
          GridView.count(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2, // Adjust based on screen size if needed
            childAspectRatio: 2.0, // Adjust aspect ratio for better fit
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildStatCard('Total Patients', totalPatients, Colors.blue, Icons.people_outline),
              _buildStatCard('Average Age', averageAge, Colors.orange, Icons.cake_outlined),
              _buildStatCard('Common Condition', commonCondition, Colors.green, Icons.visibility_outlined),
              _buildStatCard('Diabetes Prevalence', '$diabetesPercent%', Colors.red, Icons.bloodtype_outlined),
            ],
          ),
          SizedBox(height: 24),
           Text(
             'Visualizations',
              style: Theme.of(context).textTheme.titleLarge,
           ),
           SizedBox(height: 8),
          _buildAgeDistributionChart(),
          _buildConditionPrevalenceChart(),
          _buildGeographicalChart(), // Added geographical chart here
        ],
      ),
    );
  }

  // Generic Tab Builder
  Widget _buildChartTab(String title, Widget chartWidget) {
     if (_isLoading) return _buildLoadingIndicator();
     // Show specific error only if the main data load succeeded but this chart's data is missing/invalid
     // The chartWidget itself handles the specific error display based on its data check
     if (_errorMessage != null && !_isLoading) {
        // If there was a general load error, maybe show a simpler message here
        // return Center(child: Text("Data loading failed. Cannot display $title.", style: TextStyle(color: Colors.orange)));
        // Or let the chart widget show its specific error message
     }

     return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                 // Title removed as it's in the chart itself
                 chartWidget, // The chart handles its own title and error state
            ],
        ),
     );
  }


  // Main Build Method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analysis Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
           indicatorColor: Theme.of(context).primaryColor,
           labelColor: Theme.of(context).primaryColorLight,
           unselectedLabelColor: Colors.grey[600],
          tabs: [
            Tab(text: 'Descriptive'),
            Tab(text: 'Correlation'),
            Tab(text: 'Time Series'),
            Tab(text: 'Clusters'),
            Tab(text: 'Comparative'),
            Tab(text: 'Risk Factors'),
          ],
        ),
      ),
      body: _isLoading
          ? _buildLoadingIndicator()
          : _errorMessage != null && _summaryData.isEmpty // Show full error if essential summary failed
              ? _buildErrorDisplay()
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildDescriptiveTab(),
                    _buildChartTab('Correlation Analysis', _buildCorrelationChart()),
                    _buildChartTab('Time Series Analysis', _buildTimeSeriesChart()),
                    _buildChartTab('Cluster Analysis', _buildClusterChart()),
                    _buildChartTab('Comparative Analysis', _buildComparativeChart()),
                    _buildChartTab('Risk Factor Analysis', _buildRiskFactorChart()), 
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadDashboardData, // Keep refresh button
        tooltip: 'Refresh Data',
         backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}