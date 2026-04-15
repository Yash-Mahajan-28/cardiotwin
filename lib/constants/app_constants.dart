/// Application-wide constants

class AppConstants {
  // App info
  static const String appName = 'CardioTwin';
  static const String appVersion = '1.0.0';

  // UI constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;

  // Risk assessment defaults
  static const double defaultAcuteWeight = 0.4;
  static const double defaultChronicWeight = 0.6;
  static const double minRiskWeight = 0.3;
  static const double maxRiskWeight = 0.7;

  // Model timeouts
  static const Duration modelLoadTimeout = Duration(seconds: 30);
  static const Duration inferenceTimeout = Duration(seconds: 2);

  // API endpoints (if applicable)
  static const String apiBaseUrl = 'https://api.cardiotwin.com';

  // Storage keys
  static const String lastAcuteAssessmentKey = 'last_acute_assessment';
  static const String lastChronicAssessmentKey = 'last_chronic_assessment';
  static const String assessmentHistoryKey = 'assessment_history';

  // Medical disclaimers
  static const String medicalDisclaimer =
      'Results are probabilistic estimates and for clinical support only. '
      'They should not be used as a substitute for professional medical advice, '
      'diagnosis, or treatment. Always consult with qualified healthcare professionals.';

  static const String dataPrivacyNote =
      'Patient data is processed locally on this device and is not transmitted to external servers.';
}

class ColorConstants {
  // Risk level colors
  static const String lowRiskColor = '#4CAF50'; // Green
  static const String moderateRiskColor = '#FFC107'; // Amber
  static const String highRiskColor = '#F44336'; // Red

  // Status colors
  static const String successColor = '#4CAF50'; // Green
  static const String warningColor = '#FF9800'; // Orange
  static const String errorColor = '#F44336'; // Red
  static const String infoColor = '#2196F3'; // Blue

  // Neutral colors
  static const String primaryColor = '#1976D2'; // Material Blue
  static const String accentColor = '#F50057'; // Material Pink
  static const String backgroundColor = '#F5F5F5'; // Light Gray
  static const String surfaceColor = '#FFFFFF'; // White
  static const String textPrimaryColor = '#212121'; // Dark Gray
  static const String textSecondaryColor = '#757575'; // Medium Gray
  static const String dividerColor = '#BDBDBD'; // Border Gray
}

class TextConstants {
  // Risk category labels
  static const String lowRiskLabel = 'LOW RISK';
  static const String moderateRiskLabel = 'MODERATE RISK';
  static const String highRiskLabel = 'HIGH RISK';

  // Recommendations
  static const String lowRiskRecommendation = '🟢 Continue healthy lifestyle';
  static const String moderateRiskRecommendation = '🟡 Consult a cardiologist';
  static const String highRiskRecommendation = '🔴 Seek immediate medical attention';

  // Model types
  static const String acuteRiskModelName = 'Heart Disease Risk';
  static const String chronicRiskModelName = 'Cardiac Failure Risk';
  static const String compositeRiskModelName = 'Composite Cardiac Risk';

  // Accuracy labels
  static const String acuteModelAccuracy = 'Model AUC: 0.7164';
  static const String chronicModelAccuracy = 'Model AUC: 0.6658';
}

class NumericConstants {
  // Risk thresholds
  static const double lowRiskThreshold = 30.0; // < 30%
  static const double highRiskThreshold = 60.0; // >= 60%
  // 30-60% is moderate

  // Feature count
  static const int acuteFeatureCount = 11;
  static const int chronicFeatureCount = 11;

  // Validation ranges
  static const Map<String, Map<String, num>> acuteValidationRanges = {
    'age': {'min': 32, 'max': 76},
    'restingBP': {'min': 80, 'max': 200},
    'cholesterol': {'min': 0, 'max': 400},
    'maxHR': {'min': 60, 'max': 202},
    'oldpeak': {'min': 0.0, 'max': 6.2},
  };

  static const Map<String, Map<String, num>> chronicValidationRanges = {
    'age': {'min': 41, 'max': 72},
    'height': {'min': 157, 'max': 200},
    'weight': {'min': 59.0, 'max': 103.0},
    'systolicBP': {'min': 99, 'max': 164},
    'diastolicBP': {'min': 60, 'max': 100},
    'cholesterol': {'min': 148, 'max': 284},
    'glucose': {'min': 76, 'max': 147},
  };

  // Missing value replacements
  static const double cholesterolMissingValue_Acute = 194.0;
  static const double cholesterolMissingValue_Chronic = 216.0;
}

class AnalyticsConstants {
  // Event names
  static const String eventAcuteAssessment = 'acute_risk_assessment';
  static const String eventChronicAssessment = 'chronic_risk_assessment';
  static const String eventCompositeAssessment = 'composite_risk_assessment';
  static const String eventModelError = 'model_load_error';
  static const String eventValidationError = 'validation_error';

  // Property names
  static const String propRiskPercentage = 'risk_percentage';
  static const String propRiskCategory = 'risk_category';
  static const String propModelType = 'model_type';
  static const String propTimestamp = 'timestamp';
}

