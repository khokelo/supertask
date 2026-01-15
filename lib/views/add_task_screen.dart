import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/controllers/location_controller.dart';
import 'package:myapp/controllers/task_controller.dart';
import 'package:myapp/models/task.dart';
import 'package:provider/provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
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

  void _addTask() {
    if (_formKey.currentState!.validate()) {
      final taskController = Provider.of<TaskController>(context, listen: false);
      final locationController = Provider.of<LocationController>(context, listen: false);

      final task = Task(
        id: DateTime.now().toIso8601String(),
        title: _titleController.text,
        description: _descriptionController.text,
        latitude: locationController.currentPosition?.latitude,
        longitude: locationController.currentPosition?.longitude,
        weather: locationController.currentWeather != null
            ? '${locationController.currentWeather!.weatherMain}, ${locationController.currentWeather!.temperature?.celsius?.toStringAsFixed(1)}°C'
            : null,
      );
      taskController.createTask(task, image: _image);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task'),
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
                onPressed: _addTask,
                child: const Text('Add Task', style: TextStyle(fontSize: 16)),
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
        Text('Image (optional)', style: Theme.of(context).textTheme.titleMedium),
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
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(_image!, fit: BoxFit.cover),
                  )
                : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo, color: Colors.grey, size: 40),
                        SizedBox(height: 8),
                        Text('Tap to select an image', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationInfo() {
    return Consumer<LocationController>(
      builder: (context, locationController, child) {
        if (locationController.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (locationController.currentPosition != null) {
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Current Location & Weather', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 18, color: Colors.blueAccent),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Lat: ${locationController.currentPosition!.latitude.toStringAsFixed(3)}, Lon: ${locationController.currentPosition!.longitude.toStringAsFixed(3)}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (locationController.currentWeather != null)
                    Row(
                      children: [
                        const Icon(Icons.thermostat, size: 18, color: Colors.orangeAccent),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${locationController.currentWeather!.weatherMain}, ${locationController.currentWeather!.temperature?.celsius?.toStringAsFixed(1)}°C',
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink(); // Don't show anything if location is not available
      },
    );
  }
}
