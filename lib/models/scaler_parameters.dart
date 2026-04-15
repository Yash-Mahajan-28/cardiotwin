/// Hardcoded scaler parameters extracted from pickle files
/// These are used to normalize features before TensorFlow Lite inference

class ScalerParameters {
  // ============ ACUTE RISK SCALER (scaler_heart.pkl) ============
  // Used for Heart Disease prediction model
  // Extracted from: scaler_heart.mean_ and scaler_heart.scale_
  // Formula: (feature - mean) / scale for each feature

  static const List<double> acuteRiskMean = [
    53.78,                    // 0. AgeYears
    0.635,                    // 1. Sex
    1.0341666666666667,      // 2. ChestPainType
    135.685,                 // 3. RestingBP_mmHg
    227.64416666666668,      // 4. Cholesterol_mg_dL
    0.16666666666666666,     // 5. FastingBS_gt_120mgdL
    1.125,                   // 6. RestingECG
    164.66666666666666,      // 7. MaxHR_bpm
    0.3375,                  // 8. ExerciseAngina
    1.3270833333333334,      // 9. Oldpeak
    1.2233333333333334,      // 10. ST_Slope
  ];

  static const List<double> acuteRiskScale = [
    9.265344030309937,        // 0. AgeYears
    0.48143016108258113,      // 1. Sex
    0.9964935050242705,       // 2. ChestPainType
    17.309124039072575,       // 3. RestingBP_mmHg
    41.06154992981742,        // 4. Cholesterol_mg_dL
    0.37267799624996495,      // 5. FastingBS_gt_120mgdL
    0.6514407110397692,       // 6. RestingECG
    17.269980377007446,       // 7. MaxHR_bpm
    0.47285700798444347,      // 8. ExerciseAngina
    0.9277525674385864,       // 9. Oldpeak
    0.7405778524608709,       // 10. ST_Slope
  ];

  // ============ CHRONIC RISK SCALER (scaler_cardiac.pkl) ============
  // Used for Cardiac Failure prediction model
  // Extracted from: scaler_cardiac.mean_ and scaler_cardiac.scale_
  // Formula: (feature - mean) / scale for each feature

  static const List<double> chronicRiskMean = [
    52.01533333333333,        // 0. AgeYears
    0.5986666666666667,       // 1. Sex
    171.302,                  // 2. HeightCm
    76.93466666666667,        // 3. WeightKg
    131.656,                  // 4. SystolicBP_mmHg
    82.42733333333334,        // 5. DiastolicBP_mmHg
    214.092,                  // 6. Cholesterol_mg_dL
    101.56466666666667,       // 7. Glucose_mg_dL
    0.27,                     // 8. Smoker
    0.16733333333333333,      // 9. AlcoholUser
    0.6413333333333333,       // 10. PhysicallyActive
  ];

  static const List<double> chronicRiskScale = [
    10.516483801896694,       // 0. AgeYears
    0.49016822509102825,      // 1. Sex
    8.810380014505617,        // 2. HeightCm
    15.155672146830776,       // 3. WeightKg
    15.730956656647852,       // 4. SystolicBP_mmHg
    8.035466355822514,        // 5. DiastolicBP_mmHg
    35.24608067100038,        // 6. Cholesterol_mg_dL
    16.069821142612497,       // 7. Glucose_mg_dL
    0.4439594576084623,       // 8. Smoker
    0.37327320944435444,      // 9. AlcoholUser
    0.4796091000897386,       // 10. PhysicallyActive
  ];

  /// Normalize a single feature using its mean and scale
  static double normalize(double value, double mean, double scale) {
    return (value - mean) / scale;
  }

  /// Normalize an entire feature list for Acute Risk Model
  static List<double> normalizeAcuteRisk(List<double> features) {
    assert(features.length == acuteRiskMean.length,
        'Feature count must match scaler parameters (${acuteRiskMean.length})');

    return List<double>.generate(
      features.length,
      (i) => normalize(features[i], acuteRiskMean[i], acuteRiskScale[i]),
    );
  }

  /// Normalize an entire feature list for Chronic Risk Model
  static List<double> normalizeChronicRisk(List<double> features) {
    assert(features.length == chronicRiskMean.length,
        'Feature count must match scaler parameters (${chronicRiskMean.length})');

    return List<double>.generate(
      features.length,
      (i) => normalize(features[i], chronicRiskMean[i], chronicRiskScale[i]),
    );
  }
}

