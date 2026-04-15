/// Result display screen for risk assessment

}
  }
    );
      ),
        ),
          ],
            ),
              ),
                color: Colors.grey[600],
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
              'Assessment Date: ${result.timestamp.toString().split('.')[0]}',
            Text(
            // Timestamp

            const SizedBox(height: 24),
            ),
              ],
                ),
                  ),
                    label: const Text('Close'),
                    icon: const Icon(Icons.close),
                    onPressed: onClose,
                  child: OutlinedButton.icon(
                  width: double.infinity,
                SizedBox(
                const SizedBox(height: 12),
                ),
                  ),
                    label: const Text('Share Result'),
                    icon: const Icon(Icons.share),
                    onPressed: onShareResult,
                  child: OutlinedButton.icon(
                  width: double.infinity,
                SizedBox(
                const SizedBox(height: 12),
                ),
                  ),
                    ),
                      backgroundColor: const Color(0xFF1976D2),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    style: ElevatedButton.styleFrom(
                    label: const Text('Save Assessment'),
                    icon: const Icon(Icons.save),
                    onPressed: onSaveAssessment,
                  child: ElevatedButton.icon(
                  width: double.infinity,
                SizedBox(
              children: [
            Column(
            // Action buttons

            const SizedBox(height: 32),
            ),
              ),
                ),
                  ],
                    ),
                      ),
                        ],
                          ),
                            ),
                              height: 1.5,
                              color: Colors.orange[900],
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            AppConstants.medicalDisclaimer,
                          Text(
                          const SizedBox(height: 8),
                          ),
                            ),
                              color: Colors.orange[900],
                              fontWeight: FontWeight.w600,
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            'Medical Disclaimer',
                          Text(
                        children: [
                        crossAxisAlignment: CrossAxisAlignment.start,
                      child: Column(
                    Expanded(
                    const SizedBox(width: 12),
                    const Icon(Icons.warning_amber, color: Color(0xFFFF9800)),
                  children: [
                  crossAxisAlignment: CrossAxisAlignment.start,
                child: Row(
                padding: const EdgeInsets.all(16),
              child: Padding(
              ),
                side: const BorderSide(color: Color(0xFFFF9800), width: 1),
                borderRadius: BorderRadius.circular(12),
              shape: RoundedRectangleBorder(
              color: const Color(0xFFFFF3E0),
              elevation: 0,
            Card(
            // Medical disclaimer

            const SizedBox(height: 24),
            ),
              ),
                ),
                  ],
                    ),
                      ),
                        height: 1.6,
                        color: Colors.grey[700],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      _getDetailedRecommendation(),
                    Text(
                    const SizedBox(height: 12),
                    ),
                      ),
                        fontWeight: FontWeight.w600,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      'Recommendation',
                    Text(
                  children: [
                  crossAxisAlignment: CrossAxisAlignment.start,
                child: Column(
                padding: const EdgeInsets.all(16),
              child: Padding(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 1,
            Card(
            // Detailed recommendation

            const SizedBox(height: 24),
            ),
              ),
                ),
                  ],
                    ),
                      ),
                        ],
                          ),
                            ),
                              color: Colors.grey[700],
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            'AUC Score: ${result.modelAccuracy.toStringAsFixed(4)}',
                          Text(
                          const SizedBox(height: 4),
                          ),
                            ),
                              fontWeight: FontWeight.w600,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            'Model Confidence',
                          Text(
                        children: [
                        crossAxisAlignment: CrossAxisAlignment.start,
                      child: Column(
                    Expanded(
                    const SizedBox(width: 12),
                    const Icon(Icons.info_outline, color: Color(0xFF1976D2)),
                  children: [
                child: Row(
                padding: const EdgeInsets.all(16),
              child: Padding(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 1,
            Card(
            // Model accuracy info

            const SizedBox(height: 32),
            ),
              showLabel: true,
              modelType: result.modelType,
              riskPercentage: result.riskPercentage,
            RiskGaugeWidget(
            // Risk gauge
          children: [
        child: Column(
        padding: const EdgeInsets.all(16),
      body: SingleChildScrollView(
      ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Risk Assessment Result'),
      appBar: AppBar(
    return Scaffold(
  Widget build(BuildContext context) {
  @override

  }
    }
            'cardiologist for comprehensive evaluation and treatment planning.';
        return 'Your risk level is high. Please seek immediate medical attention and consult with a '
      case RiskCategory.HIGH:
            'for further evaluation and personalized recommendations.';
        return 'Your risk level is moderate. We recommend scheduling a consultation with a cardiologist '
      case RiskCategory.MODERATE:
            'balanced diet, and stress management. Regular health checkups are recommended.';
        return 'Your risk level is low. Continue maintaining a healthy lifestyle with regular exercise, '
      case RiskCategory.LOW:
    switch (result.category) {
  String _getDetailedRecommendation() {

  }) : super(key: key);
    this.onShareResult,
    this.onSaveAssessment,
    this.onClose,
    required this.result,
    Key? key,
  const RiskResultScreen({

  final VoidCallback? onShareResult;
  final VoidCallback? onSaveAssessment;
  final VoidCallback? onClose;
  final RiskAssessmentResult result;
class RiskResultScreen extends StatelessWidget {

import '../constants/app_constants.dart';
import '../widgets/risk_category_badge.dart';
import '../widgets/risk_gauge_widget.dart';
import '../models/risk_assessment_model.dart';
import '../models/model_config.dart';
import 'package:flutter/material.dart';

