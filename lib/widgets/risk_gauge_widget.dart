/// Circular risk gauge widget for displaying risk percentage

import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/model_config.dart';

class RiskGaugeWidget extends StatelessWidget {
  final double riskPercentage;
  final String modelType; // 'acute' or 'chronic'
  final VoidCallback? onTap;
  final bool showLabel;

  const RiskGaugeWidget({
    Key? key,
    required this.riskPercentage,
    required this.modelType,
    this.onTap,
    this.showLabel = true,
  }) : super(key: key);

  Color _getRiskColor() {
    if (riskPercentage < 30) return const Color(0xFF4CAF50); // Green
    if (riskPercentage <= 60) return const Color(0xFFFFC107); // Amber
    return const Color(0xFFF44336); // Red
  }

  String _getRiskLabel() {
    if (riskPercentage < 30) return 'LOW RISK';
    if (riskPercentage <= 60) return 'MODERATE RISK';
    return 'HIGH RISK';
  }

  String _getModelLabel() {
    if (modelType == 'acute') return 'Heart Disease';
    if (modelType == 'chronic') return 'Cardiac Failure';
    return 'Composite Risk';
  }

  @override
  Widget build(BuildContext context) {
    final riskColor = _getRiskColor();
    final riskLabel = _getRiskLabel();
    final modelLabel = _getModelLabel();

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Model type label
              if (showLabel)
                Text(
                  modelLabel,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                ),
              if (showLabel) const SizedBox(height: 16),

              // Circular progress indicator
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: riskColor.withOpacity(0.1),
                  border: Border.all(
                    color: riskColor,
                    width: 8,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${riskPercentage.toStringAsFixed(1)}%',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: riskColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        riskLabel,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: riskColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Risk category badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: riskColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: riskColor, width: 1),
                ),
                child: Text(
                  _getRiskEmoji() + ' ' + riskLabel,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: riskColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRiskEmoji() {
    if (riskPercentage < 30) return '🟢';
    if (riskPercentage <= 60) return '🟡';
    return '🔴';
  }
}

