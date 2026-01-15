import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/controllers/location_controller.dart';
import 'package:myapp/controllers/task_controller.dart';
import 'package:myapp/views/add_task_screen.dart';
import 'package:myapp/views/edit_task_screen.dart';
import 'package:myapp/views/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/add-task',
      builder: (context, state) => const AddTaskScreen(),
    ),
    GoRoute(
      path: '/edit-task/:taskId',
      builder: (context, state) {
        final taskId = state.pathParameters['taskId']!;
        return EditTaskScreen(taskId: taskId);
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskController()),
        ChangeNotifierProvider(create: (_) => LocationController()),
      ],
      child: MaterialApp.router(
        title: 'Task Manager App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routerConfig: _router,
      ),
    );
  }
}
