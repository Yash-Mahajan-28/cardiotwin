import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../core/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/input_field.dart';
import 'package:fl_chart/fl_chart.dart';

class PatientRiskResultScreen extends StatelessWidget {
  final bool isDoctorMode;

  const PatientRiskResultScreen({super.key, this.isDoctorMode = false});

  @override
  Widget build(BuildContext context) {
    // Get mode from arguments if not passed directly (for named routes)
    final bool effectiveDoctorMode = isDoctorMode || (ModalRoute.of(context)?.settings.arguments as bool? ?? false);
    
    final double riskScore = context.watch<AppProvider>().riskScore;
    final String riskLevel = context.watch<AppProvider>().riskLevel;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Cardiac Risk Assessment'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.p24),
        child: Column(
          children: [
            _buildRiskGauge(riskScore, riskLevel),
            const SizedBox(height: 32),
            _buildExplanationCard(context),
            const SizedBox(height: 32),
            if (effectiveDoctorMode) ...[
              _buildDoctorActions(context),
              const SizedBox(height: 32),
            ],
            CustomButton(
              text: 'View ECG Waveform',
              onPressed: () => Navigator.pushNamed(context, '/ecg-waveform'),
            ),
            const SizedBox(height: 16),
            CustomOutlineButton(
              text: 'Explain AI Prediction',
              onPressed: () => Navigator.pushNamed(context, '/ai-insights'),
            ),
            const SizedBox(height: 32),
            _buildRecommendationSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskGauge(double score, String level) {
    return Container(
      height: 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.r16),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              startDegreeOffset: 180,
              sectionsSpace: 0,
              centerSpaceRadius: 80,
              sections: [
                PieChartSectionData(
                  color: AppColors.primary,
                  value: score,
                  radius: 20,
                  showTitle: false,
                ),
                PieChartSectionData(
                  color: Colors.grey.shade200,
                  value: 100 - score,
                  radius: 20,
                  showTitle: false,
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${score.toInt()}%',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Risk: $level',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExplanationCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.r12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Analysis Summary',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Text(
            'Based on your ECG and clinical data, there is a 78% probability of CAD. An elevated ST depression and high cholesterol are key contributing factors.',
            style: TextStyle(color: Colors.grey.shade700, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Clinical Verification',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const CustomInputField(
          labelText: 'Doctor Comments',
          hintText: 'Add your clinical observations and notes...',
          keyboardType: TextInputType.multiline,
        ),
        const SizedBox(height: 16),
        CustomButton(
          text: 'Verify & Submit Report',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Report verified and submitted successfully')),
            );
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _buildRecommendationSection() {
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
              'High Risk Detected: Immediate clinical follow-up is recommended.',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
