import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ApiService {
  final String baseUrl = ApiConfig.baseUrl;

  // User
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return _handleResponse(response);
  }

  // Tasks
  Future<List<dynamic>> getTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/tasks'));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> createTask(Map<String, dynamic> taskData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(taskData),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> updateTask(
      String taskId, Map<String, dynamic> taskData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/tasks/$taskId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(taskData),
    );
    return _handleResponse(response);
  }

  Future<void> deleteTask(String taskId) async {
    final response = await http.delete(Uri.parse('$baseUrl/tasks/$taskId'));
    _handleResponse(response, noBody: true);
  }

  // Generic response handler
  dynamic _handleResponse(http.Response response, {bool noBody = false}) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (noBody) return;
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to perform action. Status code: ${response.statusCode}');
    }
  }
}
