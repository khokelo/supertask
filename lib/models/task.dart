import 'package:flutter/foundation.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final String? imageUrl;
  final double? latitude;
  final double? longitude;
  final String? weather;
  final DateTime createdAt;
  final DateTime? completedAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.imageUrl,
    this.latitude,
    this.longitude,
    this.weather,
    required this.createdAt,
    this.completedAt,
  });

  static DateTime _parseDate(dynamic date) {
    if (date is String) {
      return DateTime.tryParse(date) ?? DateTime.now();
    } else if (date is Map && date.containsKey('_seconds')) {
      return DateTime.fromMillisecondsSinceEpoch(date['_seconds'] * 1000);
    }
    return DateTime.now();
  }

  static DateTime? _parseNullableDate(dynamic date) {
    if (date == null) return null;
    if (date is String) {
      return DateTime.tryParse(date);
    } else if (date is Map && date.containsKey('_seconds')) {
      return DateTime.fromMillisecondsSinceEpoch(date['_seconds'] * 1000);
    }
    return null;
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      imageUrl: json['imageUrl'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      weather: json['weather'],
      createdAt: _parseDate(json['createdAt']),
      completedAt: _parseNullableDate(json['completedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'weather': weather,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    String? imageUrl,
    double? latitude,
    double? longitude,
    String? weather,
    DateTime? createdAt,
    ValueGetter<DateTime?>? completedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      imageUrl: imageUrl ?? this.imageUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      weather: weather ?? this.weather,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt != null ? completedAt() : this.completedAt,
    );
  }
}
