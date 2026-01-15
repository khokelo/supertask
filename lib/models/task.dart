class Task {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final String? imageUrl;
  final double? latitude;
  final double? longitude;
  final String? weather;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.imageUrl,
    this.latitude,
    this.longitude,
    this.weather,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'] ?? false,
      imageUrl: json['imageUrl'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      weather: json['weather'],
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
    );
  }
}
