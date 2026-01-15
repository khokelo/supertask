import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dasbor'),
      ),
      body: const Center(
        child: Text('Grafik progres dan statistik akan ditampilkan di sini'),
      ),
    );
  }
}
