import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myapp/controllers/task_controller.dart';
import 'package:provider/provider.dart';

class CompletedTasksChart extends StatelessWidget {
  const CompletedTasksChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskController>(
      builder: (context, taskController, child) {
        final data = _prepareChartData(taskController.completedTasksByDay);

        if (data.isEmpty) {
          return const Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No completed tasks to display.'),
              ),
            ),
          );
        }

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Completed Tasks per Day',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: (data.map((d) => d.y).reduce((a, b) => a > b ? a : b) + 2).toDouble(),
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              rod.toY.round().toString(),
                              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: true, reservedSize: 28, interval: 1),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 38,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              // PENDEKATAN YANG DISEDERHANAKAN: Hanya mengembalikan Text Widget
                              return Text(
                                _getWeekday(value.toInt()),
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      gridData: const FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 1),
                      barGroups: data.map((d) {
                        return BarChartGroupData(
                          x: d.x,
                          barRods: [
                            BarChartRodData(
                              toY: d.y.toDouble(),
                              color: Theme.of(context).primaryColor,
                              width: 16,
                              borderRadius: BorderRadius.circular(4),
                            )
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<ChartData> _prepareChartData(Map<DateTime, int> completedTasks) {
    if (completedTasks.isEmpty) {
      return [];
    }
    final List<ChartData> data = [];
    final today = DateTime.now();

    for (int i = 6; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      final key = DateTime(date.year, date.month, date.day);
      final count = completedTasks[key] ?? 0;
      data.add(ChartData(date.weekday, count));
    }
    return data;
  }

  String _getWeekday(int weekday) {
    switch (weekday) {
      case 1: return 'MON';
      case 2: return 'TUE';
      case 3: return 'WED';
      case 4: return 'THU';
      case 5: return 'FRI';
      case 6: return 'SAT';
      case 7: return 'SUN';
      default: return '';
    }
  }
}

class ChartData {
  final int x;
  final int y;

  ChartData(this.x, this.y);
}
