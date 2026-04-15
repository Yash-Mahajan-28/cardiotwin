/// Core cardiac risk assessment calculator

import '../models/model_config.dart';
import '../models/risk_assessment_model.dart';
import '../models/scaler_parameters.dart';
import '../services/tflite_service.dart';
import '../services/scaler_service.dart';
import '../services/validation_service.dart';

class CardiacRiskCalculator {
  final TFLiteService _tfliteService = TFLiteService();

  /// Calculate acute risk (Heart Disease)
  Future<RiskAssessmentResult> calculateAcuteRisk(AcuteRiskInput input) async {
    // Validate input
    final errors = ValidationService.validateAcuteRiskInput(input);
    if (errors.isNotEmpty) {
      throw ArgumentError('Validation errors: ${errors.join(', ')}');
    }

    try {
      // Convert to feature list
      final features = input.toFeatureList();

      // Normalize features
      final normalizedFeatures = ScalerService.normalizeAcuteRiskFeatures(features);

      // Run inference
      final output = _tfliteService.predictAcuteRisk(normalizedFeatures);

      // Extract risk score from output [1, 2]
      // output[0][0] = probability of no disease
      // output[0][1] = probability of has disease
      final hasDisease = output[0][1]; // Index 1 is the disease probability
      final riskPercentage = (hasDisease * 100).clamp(0.0, 100.0);

      // Categorize risk
      final category = RiskCategory.fromPercentage(riskPercentage);

      return RiskAssessmentResult(
        modelType: 'acute',
        riskPercentage: riskPercentage,
        category: category,
        recommendation: category.recommendation,
        modelAccuracy: 0.7164, // AUC score for Acute Risk Model
        timestamp: DateTime.now(),
        disclaimer:
            'Results are probabilistic and for clinical support only. Consult healthcare professionals.',
      );
    } catch (e) {
      throw Exception('Acute risk calculation failed: $e');
    }
  }

  /// Calculate chronic risk (Cardiac Failure)
  Future<RiskAssessmentResult> calculateChronicRisk(ChronicRiskInput input) async {
    // Validate input
    final errors = ValidationService.validateChronicRiskInput(input);
    if (errors.isNotEmpty) {
      throw ArgumentError('Validation errors: ${errors.join(', ')}');
    }

    try {
      // Convert to feature list
      final features = input.toFeatureList();

      // Normalize features
      final normalizedFeatures = ScalerService.normalizeChronicRiskFeatures(features);

      // Run inference
      final output = _tfliteService.predictChronicRisk(normalizedFeatures);

      // Extract risk score from output [1, 2]
      // output[0][0] = probability of no failure
      // output[0][1] = probability of has failure
      final hasFailure = output[0][1]; // Index 1 is the failure probability
      final riskPercentage = (hasFailure * 100).clamp(0.0, 100.0);

      // Categorize risk
      final category = RiskCategory.fromPercentage(riskPercentage);

      return RiskAssessmentResult(
        modelType: 'chronic',
        riskPercentage: riskPercentage,
        category: category,
        recommendation: category.recommendation,
        modelAccuracy: 0.6658, // AUC score for Chronic Risk Model
        timestamp: DateTime.now(),
        disclaimer:
            'Results are probabilistic and for clinical support only. Consult healthcare professionals.',
      );
    } catch (e) {
      throw Exception('Chronic risk calculation failed: $e');
    }
  }

  /// Calculate composite risk from both acute and chronic assessments
  Future<CompositeRiskAssessment> calculateCompositeRisk(
    AcuteRiskInput acuteInput,
    ChronicRiskInput chronicInput, {
    double acuteWeight = CompositeRiskWeights.acuteWeight,
    double chronicWeight = CompositeRiskWeights.chronicWeight,
  }) async {
    // Validate weights
    if ((acuteWeight + chronicWeight - 1.0).abs() > 0.01) {
      throw ArgumentError('Weights must sum to 1.0 (acute: $acuteWeight, chronic: $chronicWeight)');
    }
    if (acuteWeight < CompositeRiskWeights.minWeight ||
        acuteWeight > CompositeRiskWeights.maxWeight) {
      throw ArgumentError(
          'Acute weight must be between ${CompositeRiskWeights.minWeight}-${CompositeRiskWeights.maxWeight}');
    }
    if (chronicWeight < CompositeRiskWeights.minWeight ||
        chronicWeight > CompositeRiskWeights.maxWeight) {
      throw ArgumentError(
          'Chronic weight must be between ${CompositeRiskWeights.minWeight}-${CompositeRiskWeights.maxWeight}');
    }

    try {
      // Calculate both risks
      final acuteRisk = await calculateAcuteRisk(acuteInput);
      final chronicRisk = await calculateChronicRisk(chronicInput);

      // Combine with weights
      final compositePercentage = (acuteRisk.riskPercentage * acuteWeight) +
          (chronicRisk.riskPercentage * chronicWeight);
      final compositeCategory = RiskCategory.fromPercentage(compositePercentage);

      return CompositeRiskAssessment(
        acuteRisk: acuteRisk,
        chronicRisk: chronicRisk,
        acuteWeight: acuteWeight,
        chronicWeight: chronicWeight,
        compositeRiskPercentage: compositePercentage,
        compositeCategory: compositeCategory,
      );
    } catch (e) {
      throw Exception('Composite risk calculation failed: $e');
    }
  }

  /// Initialize the calculator (load models)
  Future<void> initialize() async {
    try {
      await _tfliteService.initialize();
    } catch (e) {
      throw Exception('Failed to initialize Cardiac Risk Calculator: $e');
    }
  }

  /// Check if models are loaded
  bool get isReady => _tfliteService.isInitialized;

  /// Dispose resources
  void dispose() {
    _tfliteService.dispose();
  }

  /// Get model debug info
  Map<String, dynamic> getDebugInfo() {
    return {
      'acuteModelReady': _tfliteService.isAcuteModelLoaded,
      'chronicModelReady': _tfliteService.isChronicModelLoaded,
      'acuteModelShape': _tfliteService.getAcuteModelShape(),
      'chronicModelShape': _tfliteService.getChronicModelShape(),
    };
  }
}

