import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';

  static final headers = {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*'
  };

  // GET request
  static Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers
      );
      return _handleResponse(response);
    } catch (e) {
      print("API Error: $e");
      // Return mock data for development if API is unavailable
      return _getMockData(endpoint);
    }
  }

  // POST request
  static Future<dynamic> post(String endpoint, dynamic data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
        body: json.encode(data)
      );
      return _handleResponse(response);
    } catch (e) {
      print("API Error: $e");
      // Return mock data for development if API is unavailable
      return _getMockData(endpoint);
    }
  }

  // Handle response
  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('API request failed: ${response.statusCode}');
    }
  }

  // Analysis-specific methods
  static Future<Map<String, dynamic>> getAnalysisSummary() async {
    return await _getMockData('analysis/summary');
  }

  static Future<Map<String, dynamic>> getAgeDistribution() async {
    return await get('analysis/age-distribution');
  }

  static Future<Map<String, dynamic>> getConditionPrevalence(String demographic) async {
    return await get('analysis/condition-prevalence?demographic=$demographic');
  }

  static Future<Map<String, dynamic>> getGeographicalDistribution() async {
    return await get('analysis/geographical-distribution');
  }

  static Future<Map<String, dynamic>> getCorrelationAnalysis() async {
    return await get('analysis/correlation-analysis');
  }

  static Future<Map<String, dynamic>> getTimeSeriesAnalysis({String? condition, String? timeframe}) async {
    String params = '';
    if (condition != null) params += 'condition=$condition';
    if (timeframe != null) {
      if (params.isNotEmpty) params += '&';
      params += 'timeframe=$timeframe';
    }
    
    return await get('analysis/time-series${params.isNotEmpty ? '?' + params : ''}');
  }

  static Future<Map<String, dynamic>> getClusterAnalysis(String clusterBy) async {
    return await get('analysis/clusters?clusterBy=$clusterBy');
  }

  static Future<Map<String, dynamic>> getComparativeAnalysis(String factor) async {
    return await get('analysis/comparative-analysis?factor=$factor');
  }

  static Future<Map<String, dynamic>> getRiskFactors(String condition) async {
    return await get('analysis/risk-factors?condition=$condition');
  }

  static Future<Map<String, dynamic>> getFilteredData(Map<String, dynamic> filters) async {
    return await post('analysis/filter', filters);
  }

  // Fallback mock data for development/testing
  static dynamic _getMockData(String endpoint) {
    // Check if the endpoint is for analysis
    if (endpoint.contains('analysis')) {
      return {
        'note': 'Mock data - API server unavailable',
        'totalPatients': 1245,
        'averageAge': 42.5,
        'genderDistribution': {'Male': 623, 'Female': 622},
        'commonEyeCondition': 'Myopia',
        'systemicConditions': {'diabetes': 23.5, 'hypertension': 31.2, 'heartDisease': 15.8}
      };
    }
    
    // Default mock response
    return {'message': 'Mock data - API server unavailable'};
  }
}