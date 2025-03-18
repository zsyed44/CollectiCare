import 'package:flutter/material.dart';
import 'dart:math';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({Key? key}) : super(key: key);

  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Random _random = Random();
  
  // Mock data for different analysis types
  final List<Map<String, dynamic>> _demographicData = [];
  final List<Map<String, dynamic>> _conditionData = [];
  final List<Map<String, dynamic>> _timeSeriesData = [];
  final List<Map<String, dynamic>> _correlationData = [];
  
  // Filter values
  String _selectedAgeGroup = 'All';
  String _selectedGender = 'All';
  String _selectedRegion = 'All';
  String _selectedCondition = 'All';
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _generateMockData();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  // Generate random mock data for demonstration
  void _generateMockData() {
    // Age groups
    final ageGroups = ['0-18', '19-40', '41-60', '61+'];
    // Genders
    final genders = ['Male', 'Female'];
    // Regions (mockup)
    final regions = ['London', 'Montreal', 'Toronto'];
    // Eye conditions
    final conditions = ['Myopia', 'Hyperopia', 'Astigmatism', 'Cataracts', 'Glaucoma'];
    // Systemic conditions
    final systemicConditions = ['Diabetes', 'Hypertension', 'None'];
    
    // Generate demographic data
    for (var i = 0; i < 100; i++) {
      _demographicData.add({
        'id': i,
        'age': 10 + _random.nextInt(80),
        'ageGroup': ageGroups[_random.nextInt(ageGroups.length)],
        'gender': genders[_random.nextInt(genders.length)],
        'region': regions[_random.nextInt(regions.length)],
      });
    }
    
    // Generate condition data
    for (var i = 0; i < 100; i++) {
      _conditionData.add({
        'id': i,
        'condition': conditions[_random.nextInt(conditions.length)],
        'severity': _random.nextInt(5) + 1,
        'systemicCondition': systemicConditions[_random.nextInt(systemicConditions.length)],
        'treatment': _random.nextBool() ? 'Yes' : 'No',
      });
    }
    
    // Generate time series data (for the last 12 months)
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    for (var condition in conditions) {
      for (var i = 0; i < months.length; i++) {
        _timeSeriesData.add({
          'month': months[i],
          'condition': condition,
          'cases': _random.nextInt(50) + 10,
        });
      }
    }
    
    // Generate correlation data
    for (var condition in conditions) {
      for (var systemic in systemicConditions) {
        _correlationData.add({
          'eyeCondition': condition,
          'systemicCondition': systemic,
          'correlation': _random.nextDouble() * 0.8,
        });
      }
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
            onPressed: () {
              // In a real app, this would refresh the data based on filters
              setState(() {
                // Regenerate mock data for demonstration
                _generateMockData();
              });
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Apply Filters'),
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
              child: Icon(
                Icons.bar_chart,
                size: 80,
                color: Colors.blue[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Descriptive Statistics Tab
  Widget _buildDescriptiveTab() {
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
                '1,245',
                Colors.blue,
                Icons.people,
              ),
              _buildStatCard(
                'Average Age',
                '42.5',
                Colors.amber,
                Icons.calendar_today,
              ),
              _buildStatCard(
                'Common Condition',
                'Myopia',
                Colors.green,
                Icons.visibility,
              ),
              _buildStatCard(
                'Diabetic Patients',
                '23%',
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
        child: const Icon(Icons.add),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Create new analysis')),
          );
        },
      ),
    );
  }
}