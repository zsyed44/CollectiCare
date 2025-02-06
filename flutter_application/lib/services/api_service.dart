import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static Future<Map<String, dynamic>?> fetchData() async {
    try {
      final response = await http.get(Uri.parse('/api/hello'));

      // Ensure response is JSON before decoding
      if (response.statusCode == 200 &&
          response.headers['content-type']?.contains('application/json') == true) {
        return json.decode(response.body); // Convert JSON to Map
      } else {
        print('Error: Received non-JSON response');
        print('Response Body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}
