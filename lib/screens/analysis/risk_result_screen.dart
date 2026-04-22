import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants.dart';
import '../../core/app_router.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/input_field.dart';
import '../../providers/app_provider.dart';
import '../../models/user_model.dart';

class RiskResultScreen extends StatelessWidget {
  const RiskResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userRole = context.watch<AppProvider>().userRole;
    final isDoctor = userRole == UserRole.doctor;
    final double riskScore = context.watch<AppProvider>().riskScore;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Cardiac Risk Assessment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.p24),
        child: Column(
          children: [
            _buildRiskGauge(riskScore),
            const SizedBox(height: 24),
            _buildAnalysisSummary(),
            const SizedBox(height: 24),
            Row(
            children: [
              Expanded(
                child: _buildSecondaryButton(
                  context,
                  label: isDoctor ? 'View ECG Report' : 'View ECG Signal',
                  icon: Icons.show_chart,
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.ecgWaveform),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSecondaryButton(
                  context,
                  label: 'Explain Prediction',
                  icon: Icons.lightbulb_outline,
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.aiInsights),
                ),
              ),
            ],
          ),
          if (isDoctor) ...[
            const SizedBox(height: 32),
            const Text(
              'Doctor\'s Comments',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            const CustomInputField(
              labelText: '',
              hintText: 'Enter your clinical observations here...',
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Submit Report',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Report submitted successfully')),
                );
                Navigator.popUntil(context, ModalRoute.withName(AppRoutes.doctorDashboard));
              },
            ),
          ],
          const SizedBox(height: 24),
          _buildWarningBox(),
        ],
      ),
    ),
      bottomNavigationBar: _buildBottomNav(context, isDoctor),
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
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('HIGH RISK STATUS', style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('AI Analysis Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        Text(
          'Based on your ECG and clinical data, there is a 78% probability of CAD. An elevated ST depression and high cholesterol levels, combined with your reported symptoms, indicate potential anterior ischemia.',
          style: TextStyle(color: Colors.grey.shade700, height: 1.5, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildSecondaryButton(BuildContext context, {required String label, required IconData icon, required VoidCallback onPressed}) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r12)),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildWarningBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Important Notice: AI results are probabilistic and for clinical support. Final diagnosis should be made by a qualified cardiologist.',
              style: TextStyle(fontSize: 11, color: Colors.brown, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, bool isDoctor) {
    return BottomNavigationBar(
      currentIndex: 0,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      items: isDoctor
          ? const [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.description_outlined), label: 'Reports'),
              BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Patients'),
            ]
          : const [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Stats'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
            ],
    );
  }
}
