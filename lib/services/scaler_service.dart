/// Service for feature normalization using scaler parameters

import '../models/scaler_parameters.dart';

class ScalerService {
  /// Normalize acute risk features using pre-computed scaler parameters
  /// Formula: (feature - mean) / scale
  static List<double> normalizeAcuteRiskFeatures(List<double> features) {
    if (features.length != ScalerParameters.acuteRiskMean.length) {
      throw ArgumentError(
        'Feature count mismatch: got ${features.length}, '
        'expected ${ScalerParameters.acuteRiskMean.length}',
      );
    }

    return List<double>.generate(
      features.length,
      (i) => (features[i] - ScalerParameters.acuteRiskMean[i]) /
          ScalerParameters.acuteRiskScale[i],
    );
  }

  /// Normalize chronic risk features using pre-computed scaler parameters
  /// Formula: (feature - mean) / scale
  static List<double> normalizeChronicRiskFeatures(List<double> features) {
    if (features.length != ScalerParameters.chronicRiskMean.length) {
      throw ArgumentError(
        'Feature count mismatch: got ${features.length}, '
        'expected ${ScalerParameters.chronicRiskMean.length}',
      );
    }

    return List<double>.generate(
      features.length,
      (i) => (features[i] - ScalerParameters.chronicRiskMean[i]) /
          ScalerParameters.chronicRiskScale[i],
    );
  }

  /// Normalize a single feature value
  static double normalizeSingleFeature(
    double value,
    double mean,
    double scale,
  ) {
    return (value - mean) / scale;
  }

  /// Get the mean value for a specific acute risk feature
  static double getAcuteRiskMean(int featureIndex) {
    return ScalerParameters.acuteRiskMean[featureIndex];
  }

  /// Get the scale (std dev) value for a specific acute risk feature
  static double getAcuteRiskScale(int featureIndex) {
    return ScalerParameters.acuteRiskScale[featureIndex];
  }

  /// Get the mean value for a specific chronic risk feature
  static double getChronicRiskMean(int featureIndex) {
    return ScalerParameters.chronicRiskMean[featureIndex];
  }

  /// Get the scale (std dev) value for a specific chronic risk feature
  static double getChronicRiskScale(int featureIndex) {
    return ScalerParameters.chronicRiskScale[featureIndex];
  }
}

