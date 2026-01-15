import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myapp/models/task.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TaskController with ChangeNotifier {
  List<Task> _tasks = [];
  final String _baseUrl = 'http://localhost:3000'; // Ganti dengan URL backend Anda

  List<Task> get tasks => _tasks;

  Future<void> fetchTasks() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/tasks'));
      if (response.statusCode == 200) {
        final List<dynamic> taskData = json.decode(response.body);
        _tasks = taskData.map((data) => Task.fromJson(data)).toList();
        notifyListeners();
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> createTask(Task task, {File? image}) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/tasks'));
      request.fields['task'] = json.encode(task.toJson());

      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath('image', image.path));
      }

      final response = await request.send();

      if (response.statusCode == 201) {
        await fetchTasks(); // Refresh the list
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/tasks/${task.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(task.toJson()),
      );
      if (response.statusCode == 200) {
        await fetchTasks(); // Refresh the list
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/tasks/$id'));
      if (response.statusCode == 200) {
        _tasks.removeWhere((task) => task.id == id);
        notifyListeners();
      }
    } catch (e) {
      // Handle error
    }
  }

  void toggleTaskStatus(Task task) {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    updateTask(updatedTask);
  }
}
