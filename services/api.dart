import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://49.206.202.116:1010/cyberthreya_api';

  static Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api.php?action=login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    final data = jsonDecode(response.body);
    if (data['token'] != null) {
      return data['token'];
    }
    throw data['error'] ?? 'Login failed';
  }

  static Future<void> startMachines() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('$baseUrl/api.php?action=start'),
      headers: {'Authorization': 'Bearer $token'},
    );
    final data = jsonDecode(response.body);
    if (!data['success']) {
      throw data['error'] ?? 'Failed to start machines';
    }
  }

  static Future<Map<String, Map<String, String>>> getStatuses() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('$baseUrl/api.php?action=status'),
      headers: {'Authorization': 'Bearer $token'},
    );
    final data = jsonDecode(response.body);
    if (data is Map) {
      return data.map((key, value) => MapEntry(key, Map<String, String>.from(value)));
    }
    throw data['error'] ?? 'Failed to fetch statuses';
  }

  static Future<List<Map<String, String>>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('$baseUrl/api.php?action=notifications'),
      headers: {'Authorization': 'Bearer $token'},
    );
    final data = jsonDecode(response.body);
    if (data is List) {
      return List<Map<String, String>>.from(data.map((n) => Map<String, String>.from(n)));
    }
    throw data['error'] ?? 'Failed to fetch notifications';
  }
}
