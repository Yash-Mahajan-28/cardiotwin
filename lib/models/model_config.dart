/// Model configuration and enums for Cardiac Risk Assessment

// ============ ACUTE RISK (Heart Disease) ENUMS ============

/// Chest pain type categories for Acute Risk Model
enum ChestPainType {
  ASY(0, 'Asymptomatic'),
  ATA(1, 'Atypical Angina'),
  NAP(2, 'Non-Anginal Pain'),
  TA(3, 'Typical Angina');

  final int code;
  final String label;
  const ChestPainType(this.code, this.label);

  static ChestPainType fromCode(int code) {
    return ChestPainType.values.firstWhere((e) => e.code == code);
  }
}

/// Resting ECG results for Acute Risk Model
enum RestingECG {
  LVH(0, 'Left Ventricular Hypertrophy'),
  NORMAL(1, 'Normal'),
  ST(2, 'ST-T Abnormality');

  final int code;
  final String label;
  const RestingECG(this.code, this.label);

  static RestingECG fromCode(int code) {
    return RestingECG.values.firstWhere((e) => e.code == code);
  }
}

/// ST segment slope for Acute Risk Model
enum STSlope {
  DOWN(0, 'Downsloping'),
  FLAT(1, 'Flat'),
  UP(2, 'Upsloping');

  final int code;
  final String label;
  const STSlope(this.code, this.label);

  static STSlope fromCode(int code) {
    return STSlope.values.firstWhere((e) => e.code == code);
  }
}

/// Sex category (applies to both models)
enum Sex {
  FEMALE(0, 'Female'),
  MALE(1, 'Male');

  final int code;
  final String label;
  const Sex(this.code, this.label);

  static Sex fromCode(int code) {
    return Sex.values.firstWhere((e) => e.code == code);
  }
}

/// Binary yes/no category (applies to both models)
enum YesNo {
  NO(0, 'No'),
  YES(1, 'Yes');

  final int code;
  final String label;
  const YesNo(this.code, this.label);

  static YesNo fromCode(int code) {
    return YesNo.values.firstWhere((e) => e.code == code);
  }
}

// ============ RISK CATEGORIES ============

/// Risk assessment categories
enum RiskCategory {
  LOW(0, 'LOW', 'Continue healthy lifestyle'),
  MODERATE(1, 'MODERATE', 'Consult cardiologist'),
  HIGH(2, 'HIGH', 'Seek immediate medical attention');

  final int code;
  final String label;
  final String recommendation;
  const RiskCategory(this.code, this.label, this.recommendation);

  static RiskCategory fromPercentage(double percentage) {
    if (percentage < 30) return RiskCategory.LOW;
    if (percentage <= 60) return RiskCategory.MODERATE;
    return RiskCategory.HIGH;
  }
}

// ============ MODEL CONFIGURATIONS ============

/// Configuration for Acute Risk Model (Heart Disease)
class AcuteRiskModelConfig {
  static const String modelFileName = 'best_acute_risk_model.tflite';
  static const int featureCount = 11;
  static const List<String> featureNames = [
    'AgeYears',
    'Sex',
    'ChestPainType',
    'RestingBP_mmHg',
    'Cholesterol_mg_dL',
    'FastingBS_gt_120mgdL',
    'RestingECG',
    'MaxHR_bpm',
    'ExerciseAngina',
    'Oldpeak',
    'ST_Slope',
  ];

  // Input validation ranges
  static const Map<String, Map<String, num>> validationRanges = {
    'AgeYears': {'min': 32, 'max': 76},
    'RestingBP_mmHg': {'min': 80, 'max': 200},
    'Cholesterol_mg_dL': {'min': 0, 'max': 400},
    'MaxHR_bpm': {'min': 60, 'max': 202},
    'Oldpeak': {'min': 0.0, 'max': 6.2},
  };

  // Cholesterol missing value replacement
  static const double cholesterolMissingValue = 194.0;
}

/// Configuration for Chronic Risk Model (Cardiac Failure)
class ChronicRiskModelConfig {
  static const String modelFileName = 'best_chronic_risk_model.tflite';
  static const int featureCount = 11;
  static const List<String> featureNames = [
    'AgeYears',
    'Sex',
    'HeightCm',
    'WeightKg',
    'SystolicBP_mmHg',
    'DiastolicBP_mmHg',
    'Cholesterol_mg_dL',
    'Glucose_mg_dL',
    'Smoker',
    'AlcoholUser',
    'PhysicallyActive',
  ];

  // Input validation ranges
  static const Map<String, Map<String, num>> validationRanges = {
    'AgeYears': {'min': 41, 'max': 72},
    'HeightCm': {'min': 157, 'max': 200},
    'WeightKg': {'min': 59.0, 'max': 103.0},
    'SystolicBP_mmHg': {'min': 99, 'max': 164},
    'DiastolicBP_mmHg': {'min': 60, 'max': 100},
    'Cholesterol_mg_dL': {'min': 148, 'max': 284},
    'Glucose_mg_dL': {'min': 76, 'max': 147},
  };
}

// ============ MODEL OUTPUT SPECS ============

/// TFLite model specifications
class ModelSpecs {
  static const int inputShape = 11; // Features: [1, 11]
  static const int outputShape = 2; // Probabilities: [1, 2]
  static const String inputDataType = 'float32';
  static const String outputDataType = 'float32';

  // Output indices
  static const int outputIndexNoDisease = 0;
  static const int outputIndexHasDisease = 1;
}

// ============ COMPOSITE RISK WEIGHTS ============

/// Default weights for composite risk calculation
class CompositeRiskWeights {
  static const double acuteWeight = 0.4; // 40%
  static const double chronicWeight = 0.6; // 60%

  static const double minWeight = 0.3;
  static const double maxWeight = 0.7;
}

