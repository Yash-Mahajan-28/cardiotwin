import 'package:flutter/material.dart';
import '../../core/constants.dart';
import 'package:fl_chart/fl_chart.dart';

class ECGWaveformScreen extends StatelessWidget {
  const ECGWaveformScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('ECG Waveform'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.p24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBPMCard(),
            const SizedBox(height: 32),
            const Text(
              'Lead II Waveform',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildECGChart(),
            const SizedBox(height: 32),
            _buildWaveformInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildBPMCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppRadius.r16),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Heart Rate', style: TextStyle(color: AppColors.textSecondary)),
              SizedBox(height: 4),
              Text('72 BPM', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          Icon(Icons.favorite, color: Colors.red, size: 40),
        ],
      ),
    );
  }

  Widget _buildECGChart() {
    return Container(
      height: 300,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.r12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 1,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.1),
              strokeWidth: 1,
            ),
            getDrawingVerticalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.1),
              strokeWidth: 1,
            ),
          ),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: _generateECGSpots(),
              isCurved: true,
              color: Colors.redAccent,
              barWidth: 2,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.redAccent.withOpacity(0.05),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _generateECGSpots() {
    return const [
      FlSpot(0, 0.5),
      FlSpot(1, 0.6),
      FlSpot(1.5, 0.4),
      FlSpot(1.8, 2.5),
      FlSpot(2, -0.5),
      FlSpot(2.2, 0.6),
      FlSpot(3, 0.7),
      FlSpot(4, 0.5),
      FlSpot(5, 0.6),
      FlSpot(5.5, 0.4),
      FlSpot(5.8, 2.5),
      FlSpot(6, -0.5),
      FlSpot(6.2, 0.6),
      FlSpot(7, 0.7),
    ];
  }

  Widget _buildWaveformInfo() {
    return Column(
      children: [
        _buildInfoRow('Sampling Rate', '500 Hz'),
        _buildInfoRow('Duration', '10 Seconds'),
        _buildInfoRow('Filter', '0.5 - 150 Hz'),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
