import 'package:flutter/material.dart';
import 'dart:math';
import 'services/api_service.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Selected filter values
  String _selectedAgeGroup = 'All';
  String _selectedGender = 'All';
  String _selectedRegion = 'All';
  String _selectedCondition = 'All';
  
  // Data states
  bool _isLoading = true;
  String? _errorMessage;
  
  // Data containers
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
    _tabController = TabController(length: 6, vsync: this);
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
      // Load summary statistics first (most important)
      _summaryData = await ApiService.getAnalysisSummary();
      
      // Load other data in parallel
      await Future.wait([
        ApiService.getAgeDistribution().then((data) => _ageDistributionData = data),
        ApiService.getConditionPrevalence('gender').then((data) => _conditionPrevalenceData = data),
        ApiService.getGeographicalDistribution().then((data) => _geographicalData = data),
        ApiService.getCorrelationAnalysis().then((data) => _correlationData = data),
        ApiService.getTimeSeriesAnalysis().then((data) => _timeSeriesData = data),
        ApiService.getClusterAnalysis('symptoms').then((data) => _clusterData = data),
        ApiService.getComparativeAnalysis('demographic').then((data) => _comparativeData = data),
        ApiService.getRiskFactors('Glaucoma').then((data) => _riskFactorData = data),
      ]);
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Failed to load dashboard data: $e";
      });
    }
  }
  
  // Apply filters and refresh data
  Future<void> _applyFilters() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // Create filter map
      Map<String, dynamic> filters = {
        'ageGroup': _selectedAgeGroup,
        'gender': _selectedGender,
        'region': _selectedRegion,
        'condition': _selectedCondition
      };
      
      // Get filtered data
      final filteredData = await ApiService.getFilteredData(filters);
      
      // Update relevant data containers
      if (filteredData.containsKey('patientCount')) {
        _summaryData['totalPatients'] = filteredData['patientCount'];
      }
      
      if (filteredData.containsKey('conditionDistribution')) {
        _conditionPrevalenceData['filteredDistribution'] = filteredData['conditionDistribution'];
      }
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Failed to apply filters: $e";
      });
    }
  }
  
  // Build filter section
  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Data Filters',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  'Age Group',
                  ['All', '0-18', '19-40', '41-60', '61+'],
                  _selectedAgeGroup,
                  (value) {
                    setState(() {
                      _selectedAgeGroup = value!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdown(
                  'Gender',
                  ['All', 'Male', 'Female'],
                  _selectedGender,
                  (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  'Region',
                  ['All', 'London', 'Montreal', 'Toronto'],
                  _selectedRegion,
                  (value) {
                    setState(() {
                      _selectedRegion = value!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdown(
                  'Condition',
                  ['All', 'Myopia', 'Hyperopia', 'Astigmatism', 'Cataracts', 'Glaucoma'],
                  _selectedCondition,
                  (value) {
                    setState(() {
                      _selectedCondition = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _applyFilters,
            icon: _isLoading 
                ? Container(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.refresh),
            label: Text(_isLoading ? 'Loading...' : 'Apply Filters'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper to build dropdown filters
  Widget _buildDropdown(
    String label,
    List<String> items,
    String selectedValue,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[700]!),
          ),
          child: DropdownButton<String>(
            value: selectedValue,
            onChanged: onChanged,
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            isExpanded: true,
            dropdownColor: Colors.grey[800],
            style: const TextStyle(color: Colors.white),
            underline: Container(),
          ),
        ),
      ],
    );
  }
  
  // Build stat card widget
  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              Icon(
                icon,
                color: color,
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  // Mock visualization widgets
  Widget _buildChartPlaceholder(String title, double height) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bar_chart,
                    size: 80,
                    color: Colors.blue[700],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Data visualization will appear here",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Connect to backend API to see real data",
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Loading indicator
  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.blue[700]),
          const SizedBox(height: 16),
          Text(
            "Loading data...",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
  
  // Error display
  Widget _buildErrorDisplay() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red[400], size: 48),
          const SizedBox(height: 16),
          Text(
            _errorMessage ?? "An error occurred",
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loadDashboardData,
            icon: Icon(Icons.refresh),
            label: Text("Try Again"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  
  // Descriptive Statistics Tab
  Widget _buildDescriptiveTab() {
    if (_isLoading) {
      return _buildLoadingIndicator();
    }
    
    if (_errorMessage != null) {
      return _buildErrorDisplay();
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Key Statistics',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            childAspectRatio: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildStatCard(
                'Total Patients',
                (_summaryData['totalPatients'] ?? 0).toString(),
                Colors.blue,
                Icons.people,
              ),
              _buildStatCard(
                'Average Age',
                '${_summaryData['averageAge'] ?? 0}',
                Colors.amber,
                Icons.calendar_today,
              ),
              _buildStatCard(
                'Common Condition',
                _summaryData['commonEyeCondition'] ?? 'Unknown',
                Colors.green,
                Icons.visibility,
              ),
              _buildStatCard(
                'Diabetic Patients',
                '${_summaryData.containsKey('systemicConditions') ? _summaryData['systemicConditions']['diabetes'] : 0}%',
                Colors.red,
                Icons.bloodtype,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildChartPlaceholder('Age Distribution', 300),
          const SizedBox(height: 16),
          _buildChartPlaceholder('Condition Prevalence by Gender', 300),
          const SizedBox(height: 16),
          _buildChartPlaceholder('Regional Distribution of Eye Conditions', 400),
        ],
      ),
    );
  }
  
  // Correlation Analysis Tab
  Widget _buildCorrelationTab() {
    if (_isLoading) {
      return _buildLoadingIndicator();
    }
    
    if (_errorMessage != null) {
      return _buildErrorDisplay();
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Correlation Analysis',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildChartPlaceholder('Correlation Matrix: Systemic vs Eye Conditions', 350),
          const SizedBox(height: 16),
          _buildChartPlaceholder('Environmental Factors vs Vision Problems', 300),
          const SizedBox(height: 16),
          _buildChartPlaceholder('Socioeconomic Status vs Eye Health', 300),
        ],
      ),
    );
  }
  
  // Time Series Analysis Tab
  Widget _buildTimeSeriesTab() {
    if (_isLoading) {
      return _buildLoadingIndicator();
    }
    
    if (_errorMessage != null) {
      return _buildErrorDisplay();
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Time Series Analysis',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildChartPlaceholder('Monthly Trend of Eye Conditions', 300),
          const SizedBox(height: 16),
          _buildChartPlaceholder('Treatment Effectiveness Over Time', 300),
          const SizedBox(height: 16),
          _buildChartPlaceholder('Seasonal Patterns in Eye Conditions', 300),
        ],
      ),
    );
  }
  
  // Cluster Analysis Tab
  Widget _buildClusterTab() {
    if (_isLoading) {
      return _buildLoadingIndicator();
    }
    
    if (_errorMessage != null) {
      return _buildErrorDisplay();
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cluster Analysis',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildChartPlaceholder('Patient Clusters by Symptoms', 350),
          const SizedBox(height: 16),
          _buildChartPlaceholder('Geographic Clusters of Eye Conditions', 400),
        ],
      ),
    );
  }
  
  // Comparative Analysis Tab
  Widget _buildComparativeTab() {
    if (_isLoading) {
      return _buildLoadingIndicator();
    }
    
    if (_errorMessage != null) {
      return _buildErrorDisplay();
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Comparative Analysis',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildChartPlaceholder('Treatment Effectiveness by Demographic', 300),
          const SizedBox(height: 16),
          _buildChartPlaceholder('Outcomes by Healthcare Access', 300),
          const SizedBox(height: 16),
          _buildChartPlaceholder('Early vs. Delayed Intervention Results', 300),
        ],
      ),
    );
  }
  
  // Multivariate Analysis Tab
  Widget _buildMultivariateTab() {
    if (_isLoading) {
      return _buildLoadingIndicator();
    }
    
    if (_errorMessage != null) {
      return _buildErrorDisplay();
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Multivariate Analysis',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildChartPlaceholder('Risk Factors for Glaucoma', 300),
          const SizedBox(height: 16),
          _buildChartPlaceholder('Predictive Model: Cataract Development', 350),
          const SizedBox(height: 16),
          _buildChartPlaceholder('Risk Assessment Matrix', 300),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Analysis Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Report downloaded successfully')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing options opened')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings opened')),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Descriptive'),
            Tab(text: 'Correlation'),
            Tab(text: 'Time Series'),
            Tab(text: 'Cluster'),
            Tab(text: 'Comparative'),
            Tab(text: 'Multivariate'),
          ],
          indicatorColor: Colors.blue,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.white70,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildFilters(),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDescriptiveTab(),
                  _buildCorrelationTab(),
                  _buildTimeSeriesTab(),
                  _buildClusterTab(),
                  _buildComparativeTab(),
                  _buildMultivariateTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[700],
        child: const Icon(Icons.refresh),
        onPressed: _loadDashboardData,
        tooltip: 'Refresh Data',
      ),
    );
  }
}