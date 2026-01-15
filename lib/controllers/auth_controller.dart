import 'package:flutter/material.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController with ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _user;
  String? _token;

  User? get user => _user;
  String? get token => _token;

  Future<void> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);
      _user = User.fromJson(response['user']);
      _token = response['token'];
      await _saveSession();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(String email, String password) async {
    try {
      final response = await _apiService.register(email, password);
      _user = User.fromJson(response['user']);
      _token = response['token'];
      await _saveSession();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', _token!);
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    notifyListeners();
  }
}
