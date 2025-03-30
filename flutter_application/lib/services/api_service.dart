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
    final response =
        await http.get(Uri.parse('$baseUrl/$endpoint'), headers: headers);
    return json.decode(response.body);
  }

  // POST request
  static Future<dynamic> post(String endpoint, dynamic data) async {
    final response = await http.post(Uri.parse('$baseUrl/$endpoint'),
        headers: headers, body: json.encode(data));
    return json.decode(response.body);
  }

  // PUT request
  static Future<dynamic> put(String endpoint, dynamic data) async {
    final response = await http.put(Uri.parse('$baseUrl/$endpoint'),
        headers: headers, body: json.encode(data));
    return json.decode(response.body);
  }
}

  // // Handle response
  // static dynamic _handleResponse(http.Response response) {
  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   } else {
  //     throw Exception('Failed: ${response.statusCode}');
  //   }
  

