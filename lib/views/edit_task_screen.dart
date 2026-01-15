import 'package:flutter/material.dart';
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
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late Task _task;

  @override
  void initState() {
    super.initState();
    // Ambil data tugas yang ada dan isi controllernya
    final taskController = Provider.of<TaskController>(context, listen: false);
    _task = taskController.tasks.firstWhere((task) => task.id == widget.taskId);
    _titleController.text = _task.title;
    _descriptionController.text = _task.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedTask = _task.copyWith(
                  title: _titleController.text,
                  description: _descriptionController.text,
                );
                Provider.of<TaskController>(context, listen: false)
                    .updateTask(updatedTask);
                Navigator.of(context).pop();
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
