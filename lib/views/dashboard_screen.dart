import 'package:flutter/material.dart';
import 'package:myapp/widgets/charts/completed_tasks_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dasbor'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          CompletedTasksChart(),
          SizedBox(height: 24),
          // Widget lain untuk statistik bisa ditambahkan di sini
        ],
      ),
    );
  }
}
