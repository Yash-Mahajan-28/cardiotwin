import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/app_router.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/ecg_chart.dart';

class ReportDetailScreen extends StatelessWidget {
  final String reportId;

  const ReportDetailScreen({super.key, required this.reportId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Report Details'),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.print_outlined), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.p20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPatientHeader(),
            const SizedBox(height: 24),
            _buildRiskSummaryCard(),
            const SizedBox(height: 24),
            const Text('ECG Analysis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ECGChart(spots: ECGChart.mockSpots),
            const SizedBox(height: 24),
            _buildClinicalDataGrid(),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Verify & Close Report',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.r12),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primary,
            child: Text('JD', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('John Doe', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('ID: #CT-9921 • 54Y, Male', style: TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(AppRadius.r12),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('AI Risk Score', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              Text('78%', style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'The AI detected severe ST depression and abnormal T-wave inversion in Lead II.',
            style: TextStyle(color: Colors.red, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildClinicalDataGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Clinical Parameters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 2.5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _buildDataPoint('Blood Pressure', '145/92'),
            _buildDataPoint('Cholesterol', '260 mg/dL'),
            _buildDataPoint('Max HR', '162 bpm'),
            _buildDataPoint('Glucose', '110 mg/dL'),
          ],
        ),
      ],
    );
  }

  Widget _buildDataPoint(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
