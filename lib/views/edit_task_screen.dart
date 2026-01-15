import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/controllers/location_controller.dart';
import 'package:myapp/controllers/task_controller.dart';
import 'package:myapp/models/task.dart';
import 'package:provider/provider.dart';

class EditTaskScreen extends StatefulWidget {
  final String taskId;

  const EditTaskScreen({super.key, required this.taskId});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late Task _task;
  File? _image;

  @override
  void initState() {
    super.initState();
    final taskController = Provider.of<TaskController>(context, listen: false);
    _task = taskController.tasks.firstWhere((task) => task.id == widget.taskId);
    _titleController = TextEditingController(text: _task.title);
    _descriptionController = TextEditingController(text: _task.description);

    // Inisialisasi data lokasi jika belum ada
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LocationController>(context, listen: false).getCurrentLocationAndWeather();
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _updateTask() {
    if (_formKey.currentState!.validate()) {
      final taskController = Provider.of<TaskController>(context, listen: false);
      final locationController = Provider.of<LocationController>(context, listen: false);

      final updatedTask = _task.copyWith(
        title: _titleController.text,
        description: _descriptionController.text,
        latitude: locationController.currentPosition?.latitude ?? _task.latitude,
        longitude: locationController.currentPosition?.longitude ?? _task.longitude,
        weather: locationController.weather != null
            ? '${locationController.weather!.weatherMain}, ${locationController.weather!.temperature?.celsius?.toStringAsFixed(1)}°C'
            : _task.weather,
        // Jangan perbarui imageUrl di sini, itu ditangani di controller
      );
      taskController.updateTask(updatedTask, image: _image);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                controller: _titleController,
                labelText: 'Title',
                validator: (value) => value!.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                labelText: 'Description',
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Description is required' : null,
              ),
              const SizedBox(height: 24),
              _buildImagePicker(),
              const SizedBox(height: 24),
              _buildLocationInfo(),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _updateTask,
                child: const Text('Save Changes', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String labelText, int maxLines = 1, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      validator: validator,
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Image', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade400, width: 1),
            ),
            child: _image != null
                ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.file(_image!, fit: BoxFit.cover))
                : (_task.imageUrl != null
                    ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(_task.imageUrl!, fit: BoxFit.cover))
                    : const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, color: Colors.grey, size: 40),
                            SizedBox(height: 8),
                            Text('Tap to select an image', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationInfo() {
    return Consumer<LocationController>(
      builder: (context, locationController, child) {
        if (locationController.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (locationController.error != null) {
          return Center(
            child: Text(
              'Error getting location: ${locationController.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        // Menampilkan lokasi yang ada jika ada, atau lokasi baru jika tersedia
        final lat = locationController.currentPosition?.latitude ?? _task.latitude;
        final lon = locationController.currentPosition?.longitude ?? _task.longitude;
        final weather = locationController.weather != null 
            ? '${locationController.weather!.weatherMain}, ${locationController.weather!.temperature?.celsius?.toStringAsFixed(1)}°C'
            : _task.weather;

        if (lat != null && lon != null) {
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Location & Weather', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 18, color: Colors.blueAccent),
                      const SizedBox(width: 8),
                      Expanded(child: Text('Lat: ${lat.toStringAsFixed(3)}, Lon: ${lon.toStringAsFixed(3)}')),
                    ],
                  ),
                  if (weather != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.thermostat, size: 18, color: Colors.orangeAccent),
                          const SizedBox(width: 8),
                          Expanded(child: Text(weather)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink(); // Jangan tampilkan apa pun jika tidak ada lokasi
      },
    );
  }
}
