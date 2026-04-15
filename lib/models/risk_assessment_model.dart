/// Data classes for risk assessment models and results

/// Acute Risk Assessment Input Data
class AcuteRiskInput {
  final int ageYears;
  final Sex sex;
  final ChestPainType chestPainType;
  final int restingBP_mmHg;
  final int cholesterol_mg_dL;
  final YesNo fastingBS_gt_120mgdL;
  final RestingECG restingECG;
  final int maxHR_bpm;
  final YesNo exerciseAngina;
  final double oldpeak;
  final STSlope stSlope;

  AcuteRiskInput({
    required this.ageYears,
    required this.sex,
    required this.chestPainType,
    required this.restingBP_mmHg,
    required this.cholesterol_mg_dL,
    required this.fastingBS_gt_120mgdL,
    required this.restingECG,
    required this.maxHR_bpm,
    required this.exerciseAngina,
    required this.oldpeak,
    required this.stSlope,
  });

  /// Convert to normalized feature list for TFLite inference
  /// Order MUST match: [AgeYears, Sex, ChestPainType, RestingBP, Cholesterol,
  /// FastingBS, RestingECG, MaxHR, ExerciseAngina, Oldpeak, ST_Slope]
  List<double> toFeatureList() {
    // Handle missing cholesterol value (0 means missing in dataset)
    double cholesterol = cholesterol_mg_dL == 0
        ? AcuteRiskModelConfig.cholesterolMissingValue
        : cholesterol_mg_dL.toDouble();

    return [
      ageYears.toDouble(),
      sex.code.toDouble(),
      chestPainType.code.toDouble(),
      restingBP_mmHg.toDouble(),
      cholesterol,
      fastingBS_gt_120mgdL.code.toDouble(),
      restingECG.code.toDouble(),
      maxHR_bpm.toDouble(),
      exerciseAngina.code.toDouble(),
      oldpeak,
      stSlope.code.toDouble(),
    ];
  }

  @override
  String toString() {
    return '''AcuteRiskInput{
      age: $ageYears, sex: ${sex.label}, chestPain: ${chestPainType.label},
      restingBP: $restingBP_mmHg, cholesterol: $cholesterol_mg_dL,
      fastingBS: ${fastingBS_gt_120mgdL.label}, ecg: ${restingECG.label},
      maxHR: $maxHR_bpm, exerciseAngina: ${exerciseAngina.label},
      oldpeak: $oldpeak, stSlope: ${stSlope.label}
    }''';
  }
}

/// Chronic Risk Assessment Input Data
class ChronicRiskInput {
  final int ageYears;
  final Sex sex;
  final int heightCm;
  final double weightKg;
  final int systolicBP_mmHg;
  final int diastolicBP_mmHg;
  final int cholesterol_mg_dL;
  final int glucose_mg_dL;
  final YesNo smoker;
  final YesNo alcoholUser;
  final YesNo physicallyActive;

  ChronicRiskInput({
    required this.ageYears,
    required this.sex,
    required this.heightCm,
    required this.weightKg,
    required this.systolicBP_mmHg,
    required this.diastolicBP_mmHg,
    required this.cholesterol_mg_dL,
    required this.glucose_mg_dL,
    required this.smoker,
    required this.alcoholUser,
    required this.physicallyActive,
  });

  /// Calculate BMI (Body Mass Index)
  double calculateBMI() {
    double heightMeters = heightCm / 100.0;
    return weightKg / (heightMeters * heightMeters);
  }

  /// Convert to normalized feature list for TFLite inference
  /// Order MUST match: [AgeYears, Sex, HeightCm, WeightKg, SystolicBP, DiastolicBP,
  /// Cholesterol, Glucose, Smoker, AlcoholUser, PhysicallyActive]
  List<double> toFeatureList() {
    return [
      ageYears.toDouble(),
      sex.code.toDouble(),
      heightCm.toDouble(),
      weightKg,
      systolicBP_mmHg.toDouble(),
      diastolicBP_mmHg.toDouble(),
      cholesterol_mg_dL.toDouble(),
      glucose_mg_dL.toDouble(),
      smoker.code.toDouble(),
      alcoholUser.code.toDouble(),
      physicallyActive.code.toDouble(),
    ];
  }

  @override
  String toString() {
    return '''ChronicRiskInput{
      age: $ageYears, sex: ${sex.label}, height: $heightCm cm, weight: $weightKg kg,
      systolicBP: $systolicBP_mmHg, diastolicBP: $diastolicBP_mmHg,
      cholesterol: $cholesterol_mg_dL, glucose: $glucose_mg_dL,
      smoker: ${smoker.label}, alcoholUser: ${alcoholUser.label},
      physicallyActive: ${physicallyActive.label}
    }''';
  }
}

/// Risk Assessment Result
class RiskAssessmentResult {
  final String modelType; // 'acute' or 'chronic'
  final double riskPercentage; // 0-100
  final RiskCategory category;
  final String recommendation;
  final double modelAccuracy; // AUC score for reference
  final DateTime timestamp;
  final String? disclaimer;

  RiskAssessmentResult({
    required this.modelType,
    required this.riskPercentage,
    required this.category,
    required this.recommendation,
    required this.modelAccuracy,
    required this.timestamp,
    this.disclaimer,
  });

  /// Get color based on risk category (RGB hex)
  String getRiskColor() {
    switch (category) {
      case RiskCategory.LOW:
        return '#4CAF50'; // Green
      case RiskCategory.MODERATE:
        return '#FFC107'; // Amber/Yellow
      case RiskCategory.HIGH:
        return '#F44336'; // Red
    }
  }

  /// Get emoji for risk category
  String getRiskEmoji() {
    switch (category) {
      case RiskCategory.LOW:
        return '🟢';
      case RiskCategory.MODERATE:
        return '🟡';
      case RiskCategory.HIGH:
        return '🔴';
    }
  }

  @override
  String toString() {
    return '''RiskAssessmentResult{
      model: $modelType, risk: ${riskPercentage.toStringAsFixed(1)}%,
      category: ${category.label}, accuracy: $modelAccuracy,
      timestamp: $timestamp
    }''';
  }
}

/// Composite Risk Assessment (combining acute and chronic)
class CompositeRiskAssessment {
  final RiskAssessmentResult acuteRisk;
  final RiskAssessmentResult chronicRisk;
  final double acuteWeight; // 0.3-0.7
  final double chronicWeight; // 0.3-0.7
  final double compositeRiskPercentage;
  final RiskCategory compositeCategory;

  CompositeRiskAssessment({
    required this.acuteRisk,
    required this.chronicRisk,
    required this.acuteWeight,
    required this.chronicWeight,
    required this.compositeRiskPercentage,
    required this.compositeCategory,
  });

  /// Validate weights sum to 1.0
  bool isValidWeightDistribution() {
    return (acuteWeight + chronicWeight - 1.0).abs() < 0.01;
  }

  @override
  String toString() {
    return '''CompositeRiskAssessment{
      acute: ${acuteRisk.riskPercentage.toStringAsFixed(1)}% (weight: $acuteWeight),
      chronic: ${chronicRisk.riskPercentage.toStringAsFixed(1)}% (weight: $chronicWeight),
      composite: ${compositeRiskPercentage.toStringAsFixed(1)}% (${compositeCategory.label})
    }''';
  }
}

/// Validation Error Details
class ValidationError {
  final String fieldName;
  final String message;
  final String? expectedRange;

  ValidationError({
    required this.fieldName,
    required this.message,
    this.expectedRange,
  });

  @override
  String toString() => '$fieldName: $message${expectedRange != null ? ' ($expectedRange)' : ''}';
}

