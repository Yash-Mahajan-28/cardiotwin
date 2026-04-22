/// Result display screen for risk assessment
import 'package:flutter/material.dart';
import '../models/model_config.dart';
import '../models/risk_assessment_model.dart';
import '../widgets/risk_gauge_widget.dart';
import '../widgets/risk_category_badge.dart';
import '../constants/app_constants.dart';

class RiskResultScreen extends StatelessWidget {
  final RiskAssessmentResult result;
  final VoidCallback? onClose;
  final VoidCallback? onSaveAssessment;
  final VoidCallback? onShareResult;

  const RiskResultScreen({
    Key? key,
    required this.result,
    this.onClose,
    this.onSaveAssessment,
    this.onShareResult,
  }) : super(key: key);

  String _getDetailedRecommendation() {
    switch (result.category) {
      case RiskCategory.LOW:
        return 'Your risk level is low. Continue maintaining a healthy lifestyle with regular exercise, '
            'balanced diet, and stress management. Regular health checkups are recommended.';
      case RiskCategory.MODERATE:
        return 'Your risk level is moderate. We recommend scheduling a consultation with a cardiologist '
            'for further evaluation and personalized recommendations.';
      case RiskCategory.HIGH:
        return 'Your risk level is high. Please seek immediate medical attention and consult with a '
            'cardiologist for comprehensive evaluation and treatment planning.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Risk Assessment Result'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Risk gauge
            RiskGaugeWidget(
              riskPercentage: result.riskPercentage,
              modelType: result.modelType,
              showLabel: true,
            ),
            const SizedBox(height: 32),

            // Model accuracy info
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xFF1976D2)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Model Confidence',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'AUC Score: ${result.modelAccuracy.toStringAsFixed(4)}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Detailed recommendation
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recommendation',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _getDetailedRecommendation(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Medical disclaimer
            Card(
              elevation: 0,
              color: const Color(0xFFFFF3E0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFFFF9800), width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning_amber, color: Color(0xFFFF9800)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Medical Disclaimer',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.orange[900],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppConstants.medicalDisclaimer,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.orange[900],
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Action buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onSaveAssessment,
                    icon: const Icon(Icons.save),
                    label: const Text('Save Assessment'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: const Color(0xFF1976D2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onShareResult,
                    icon: const Icon(Icons.share),
                    label: const Text('Share Result'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onClose,
                    icon: const Icon(Icons.close),
                    label: const Text('Close'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Timestamp
            Text(
              'Assessment Date: ${result.timestamp.toString().split('.')[0]}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}