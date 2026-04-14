import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../widgets/custom_button.dart';
import 'package:fl_chart/fl_chart.dart';

class ECGUploadScreen extends StatefulWidget {
  const ECGUploadScreen({super.key});

  @override
  State<ECGUploadScreen> createState() => _ECGUploadScreenState();
}

class _ECGUploadScreenState extends State<ECGUploadScreen> {
  bool _isFileUploaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Upload ECG'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppPadding.p24),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildUploadArea(),
                  const SizedBox(height: 32),
                  if (_isFileUploaded) _buildWaveformPreview(),
                ],
              ),
            ),
            CustomButton(
              text: 'Run AI Analysis',
              onPressed: _isFileUploaded
                  ? () => Navigator.pushNamed(context, '/loading')
                  : () {},
              backgroundColor: _isFileUploaded ? AppColors.primary : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadArea() {
    return InkWell(
      onTap: () => setState(() => _isFileUploaded = true),
      borderRadius: BorderRadius.circular(AppRadius.r16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.r16),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.5),
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              _isFileUploaded ? Icons.check_circle_rounded : Icons.cloud_upload_outlined,
              size: 64,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              _isFileUploaded ? 'ECG File Ready' : 'Upload ECG File',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _isFileUploaded ? 'sample_ecg_data.csv' : 'Supports .csv, .edf, .json',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            if (!_isFileUploaded)
              TextButton(
                onPressed: () => setState(() => _isFileUploaded = true),
                child: const Text('Use Sample Data'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaveformPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Waveform Preview',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          height: 120,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.r12),
          ),
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    const FlSpot(0, 1),
                    const FlSpot(1, 1.2),
                    const FlSpot(2, 0.8),
                    const FlSpot(2.5, 3),
                    const FlSpot(3, -1),
                    const FlSpot(3.5, 1),
                    const FlSpot(5, 1.1),
                  ],
                  isCurved: true,
                  color: AppColors.primary,
                  barWidth: 2,
                  dotData: const FlDotData(show: false),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
