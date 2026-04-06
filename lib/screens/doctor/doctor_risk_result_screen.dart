import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants.dart';
import '../../core/app_router.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/input_field.dart';

class DoctorRiskResultScreen extends StatelessWidget {
  const DoctorRiskResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double riskScore = 78.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Clinical Risk Assessment'),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.p24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRiskGauge(riskScore),
            const SizedBox(height: 24),
            _buildSectionHeader('AI Analysis Summary'),
            const SizedBox(height: 8),
            Text(
              'High probability of Coronary Artery Disease (78%). Significant ST depression (2.1mm) noted in Lead II. Recommendation: Immediate clinical consultation and further cardiac imaging.',
              style: TextStyle(color: Colors.grey.shade700, height: 1.5),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildActionBtn(
                    context,
                    label: 'View ECG Signal',
                    icon: Icons.show_chart,
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.ecgWaveform),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionBtn(
                    context,
                    label: 'Explain Prediction',
                    icon: Icons.auto_graph_rounded,
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.aiInsights),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('Doctor\'s Comments'),
            const SizedBox(height: 12),
            const CustomInputField(
              labelText: '',
              hintText: 'Add clinical notes, recommendations, or verification comments...',
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Verify & Submit Report',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Report verified and saved to database')),
                );
                Navigator.popUntil(context, ModalRoute.withName(AppRoutes.doctorDashboard));
              },
            ),
            const SizedBox(height: 32),
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
          const Text('PATIENT RISK SCORE', style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    startDegreeOffset: 180,
                    sectionsSpace: 0,
                    centerSpaceRadius: 60,
                    sections: [
                      PieChartSectionData(color: Colors.red, value: score, radius: 15, showTitle: false),
                      PieChartSectionData(color: Colors.grey.shade100, value: 100 - score, radius: 15, showTitle: false),
                    ],
                  ),
                ),
                Text('${score.toInt()}%', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text('STATUS: CRITICAL', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }

  Widget _buildActionBtn(BuildContext context, {required String label, required IconData icon, required VoidCallback onPressed}) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r12)),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
