import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/constants.dart';

class ECGChart extends StatelessWidget {
  final List<FlSpot> spots;
  final double height;
  final Color color;
  final bool showMedicalGrid;

  const ECGChart({
    super.key,
    required this.spots,
    this.height = 200,
    this.color = Colors.redAccent,
    this.showMedicalGrid = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F5), // Subtle red tint like ECG paper
        borderRadius: BorderRadius.circular(AppRadius.r12),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.r12),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: showMedicalGrid,
              drawVerticalLine: true,
              horizontalInterval: 0.2, // Small grid
              verticalInterval: 0.2,
              getDrawingHorizontalLine: (value) {
                // Large grid every 1.0 units
                bool isMajor = (value * 10).round() % 10 == 0;
                return FlLine(
                  color: isMajor ? Colors.red.withOpacity(0.2) : Colors.red.withOpacity(0.05),
                  strokeWidth: isMajor ? 1.0 : 0.5,
                );
              },
              getDrawingVerticalLine: (value) {
                bool isMajor = (value * 10).round() % 10 == 0;
                return FlLine(
                  color: isMajor ? Colors.red.withOpacity(0.2) : Colors.red.withOpacity(0.05),
                  strokeWidth: isMajor ? 1.0 : 0.5,
                );
              },
            ),
            titlesData: const FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: false, // ECGs are usually linear between points at high frequency
                color: color,
                barWidth: 1.5,
                dotData: const FlDotData(show: false),
              ),
            ],
            minX: spots.first.x,
            maxX: spots.last.x,
            minY: -1.5,
            maxY: 3.5,
          ),
        ),
      ),
    );
  }

  static List<FlSpot> get mockSpots => const [
        FlSpot(0, 0.5),
        FlSpot(0.2, 0.6),
        FlSpot(0.4, 0.5),
        FlSpot(0.6, 0.7),
        FlSpot(0.8, 0.5),
        FlSpot(1.0, 0.6),
        FlSpot(1.2, 0.4),
        FlSpot(1.3, 2.5), // QRS
        FlSpot(1.4, -0.8),
        FlSpot(1.5, 0.5),
        FlSpot(2.0, 0.8), // T wave
        FlSpot(2.5, 0.5),
        FlSpot(3.0, 0.5),
        FlSpot(3.2, 0.6),
        FlSpot(3.4, 0.5),
        FlSpot(3.6, 0.7),
        FlSpot(3.8, 0.5),
        FlSpot(4.0, 0.6),
        FlSpot(4.2, 0.4),
        FlSpot(4.3, 2.5), // QRS
        FlSpot(4.4, -0.8),
        FlSpot(4.5, 0.5),
        FlSpot(5.0, 0.8), // T wave
        FlSpot(5.5, 0.5),
      ];
}
