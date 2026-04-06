import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants.dart';
import '../../core/app_router.dart';
import '../../widgets/custom_button.dart';

class PatientRiskResultScreen extends StatelessWidget {
  const PatientRiskResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double riskScore = 78.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Cardiac Risk Assessment'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.popUntil(context, ModalRoute.withName(AppRoutes.patientDashboard)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.p24),
        child: Column(
          children: [
            _buildRiskGauge(riskScore),
            const SizedBox(height: 32),
            _buildAnalysisSummary(),
            const SizedBox(height: 32),
            CustomButton(
              text: 'View ECG Waveform',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.ecgWaveform),
            ),
            const SizedBox(height: 16),
            CustomOutlineButton(
              text: 'Explain AI Prediction',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.aiInsights),
            ),
            const SizedBox(height: 32),
            _buildRecommendationBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskGauge(double score) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.r16),
      ),
      child: Column(
        children: [
          const Text('RISK LEVEL SCORE', style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    startDegreeOffset: 180,
                    sectionsSpace: 0,
                    centerSpaceRadius: 65,
                    sections: [
                      PieChartSectionData(color: AppColors.primary, value: score, radius: 18, showTitle: false),
                      PieChartSectionData(color: Colors.grey.shade100, value: 100 - score, radius: 18, showTitle: false),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${score.toInt()}%', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                    const Text('High Risk', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('AI Analysis Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 12),
        Text(
          'Based on your ECG and clinical data, there is a 78% probability of CAD. An elevated ST depression and high cholesterol are key contributing factors.',
          style: TextStyle(color: Colors.grey.shade700, height: 1.5, fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildRecommendationBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'High Risk Detected: We recommend consulting a cardiologist immediately.',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
