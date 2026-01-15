import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController with ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _user;

  User? get user => _user;

  bool get isAuthenticated => _user != null;

  Future<void> login(String email, String password) async {
    try {
      _user = await _apiService.login(email, password);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('user', jsonEncode(_user!.toJson()));
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      _user = await _apiService.register(name, email, password);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('user', jsonEncode(_user!.toJson()));
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
    notifyListeners();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user')) {
      _user = User.fromJson(jsonDecode(prefs.getString('user')!));
      notifyListeners();
    }
  }
}