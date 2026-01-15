import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myapp/models/task.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:collection/collection.dart';

class TaskController with ChangeNotifier {
  List<Task> _tasks = [];
  final String _baseUrl = 'http://localhost:3000'; // Ganti dengan URL backend Anda
  bool _isLoading = false;
  String? _error;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Getter untuk data grafik
  Map<DateTime, int> get completedTasksByDay {
    final completedTasks = _tasks.where((task) => task.isCompleted && task.completedAt != null);

    final groupedTasks = groupBy(completedTasks, (Task task) {
      final date = task.completedAt!;
      return DateTime(date.year, date.month, date.day);
    });

    return groupedTasks.map((key, value) => MapEntry(key, value.length));
  }

  void _setState({bool loading = false, String? error}) {
    _isLoading = loading;
    _error = error;
    notifyListeners();
  }

  Future<void> fetchTasks() async {
    _setState(loading: true);
    try {
      final response = await http.get(Uri.parse('$_baseUrl/tasks'));
      if (response.statusCode == 200) {
        final List<dynamic> taskData = json.decode(response.body);
        _tasks = taskData.map((data) => Task.fromJson(data)).toList();
        _setState(loading: false);
      } else {
        _setState(loading: false, error: 'Failed to load tasks');
      }
    } catch (e) {
      developer.log('Fetch Tasks Error: $e');
      _setState(loading: false, error: e.toString());
    }
  }

  Future<void> createTask(Task task, {File? image}) async {
    _setState(loading: true);
    final newTask = task.copyWith(createdAt: DateTime.now());

    try {
      final request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/tasks'));
      request.fields['task'] = json.encode(newTask.toJson());

      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath('image', image.path));
      }

      final response = await request.send();

      if (response.statusCode == 201) {
        await fetchTasks();
      } else {
        final respStr = await response.stream.bytesToString();
        _setState(loading: false, error: 'Failed to create task: $respStr');
      }
    } catch (e) {
      developer.log('Create Task Error: $e');
      _setState(loading: false, error: e.toString());
    }
  }

  Future<void> updateTask(Task task, {File? image}) async {
    _setState(loading: true);
    try {
      final request = http.MultipartRequest('PUT', Uri.parse('$_baseUrl/tasks/${task.id}'));
      request.fields['task'] = json.encode(task.toJson());

      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath('image', image.path));
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        await fetchTasks();
      } else {
        final respStr = await response.stream.bytesToString();
        _setState(loading: false, error: 'Failed to update task: $respStr');
      }
    } catch (e) {
      developer.log('Update Task Error: $e');
      _setState(loading: false, error: e.toString());
    }
  }

  Future<void> deleteTask(String id) async {
    _setState(loading: true);
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/tasks/$id'));
      if (response.statusCode == 200) {
        _tasks.removeWhere((task) => task.id == id);
        _setState(loading: false);
      } else {
        _setState(loading: false, error: 'Failed to delete task');
      }
    } catch (e) {
      developer.log('Delete Task Error: $e');
      _setState(loading: false, error: e.toString());
    }
  }

  Future<void> toggleTaskStatus(Task task) async {
    final isCompleted = !task.isCompleted;
    final updatedTask = task.copyWith(
      isCompleted: isCompleted,
      completedAt: () => isCompleted ? DateTime.now() : null,
    );

    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/tasks/${task.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedTask.toJson()),
      );
      if (response.statusCode == 200) {
        final index = _tasks.indexWhere((t) => t.id == task.id);
        if (index != -1) {
          _tasks[index] = updatedTask;
          notifyListeners();
        }
      } else {
        developer.log("Failed to toggle task status");
      }
    } catch (e) {
      developer.log("Toggle Task Error: $e");
    }
  }
}
