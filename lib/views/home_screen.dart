import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/controllers/task_controller.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskController>(context, listen: false).fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Tasks'),
        elevation: 4,
      ),
      body: Consumer<TaskController>(
        builder: (context, taskController, child) {
          if (taskController.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (taskController.error != null) {
            return Center(
              child: Text(
                'Error: ${taskController.error}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }

          if (taskController.tasks.isEmpty) {
            return const Center(
              child: Text(
                'No tasks yet. Add one!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => taskController.fetchTasks(),
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: taskController.tasks.length,
              itemBuilder: (context, index) {
                final task = taskController.tasks[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15.0),
                    leading: task.imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              task.imageUrl!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 50),
                            ),
                          )
                        : null,
                    title: Text(
                      task.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(task.description),
                          const SizedBox(height: 8),
                          // --- Menampilkan Tanggal --- 
                          Text(
                            DateFormat('dd MMMM yyyy').format(task.createdAt),
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          if (task.latitude != null && task.longitude != null)
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Lat: ${task.latitude!.toStringAsFixed(2)}, Lon: ${task.longitude!.toStringAsFixed(2)}',
                                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          if (task.weather != null)
                            Row(
                              children: [
                                const Icon(Icons.wb_sunny, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    task.weather!,
                                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    trailing: Checkbox(
                      value: task.isCompleted,
                      onChanged: (_) => taskController.toggleTaskStatus(task),
                      activeColor: Theme.of(context).primaryColor,
                    ),
                    onTap: () => context.go('/edit-task/${task.id}'),
                    onLongPress: () => _confirmDelete(context, taskController, task.id),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/add-task'),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _confirmDelete(BuildContext context, TaskController controller, String taskId) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                controller.deleteTask(taskId);
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
