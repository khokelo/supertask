import 'dart:io';
import 'package:dio/dio.dart';
import 'package:myapp/models/task.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/services/api_config.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<String?> _uploadImage(File image) async {
    try {
      String fileName = image.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(image.path, filename: fileName),
      });
      final response = await _dio.post(
        ApiConfig.baseUrl + '/upload', // Assuming an /upload endpoint
        data: formData,
      );
      return response.data['url']; // Assuming the server returns the URL
    } catch (e) {
      return null;
    }
  }

  Future<User> login(String email, String password) async {
    final response = await _dio.post(
      ApiConfig.baseUrl + ApiConfig.login,
      data: {'email': email, 'password': password},
    );
    return User.fromJson(response.data);
  }

  Future<User> register(String name, String email, String password) async {
    final response = await _dio.post(
      ApiConfig.baseUrl + ApiConfig.register,
      data: {'name': name, 'email': email, 'password': password},
    );
    return User.fromJson(response.data);
  }

  Future<List<Task>> getTasks() async {
    final response = await _dio.get(ApiConfig.baseUrl + ApiConfig.tasks);
    return (response.data as List).map((task) => Task.fromJson(task)).toList();
  }

  Future<Task> createTask(Task task, {File? image}) async {
    String? imageUrl;
    if (image != null) {
      imageUrl = await _uploadImage(image);
    }
    final taskWithImage = task.copyWith(imageUrl: imageUrl);
    final response = await _dio.post(
      ApiConfig.baseUrl + ApiConfig.tasks,
      data: taskWithImage.toJson(),
    );
    return Task.fromJson(response.data);
  }

  Future<Task> updateTask(Task task) async {
    final response = await _dio.put(
      ApiConfig.baseUrl + ApiConfig.tasks + '/${task.id}',
      data: task.toJson(),
    );
    return Task.fromJson(response.data);
  }

  Future<void> deleteTask(String id) async {
    await _dio.delete(ApiConfig.baseUrl + ApiConfig.tasks + '/$id');
  }
}
