/// Service for validating patient input data

import '../models/model_config.dart';
import '../models/risk_assessment_model.dart';

class ValidationService {
  /// Validate acute risk input data
  static List<ValidationError> validateAcuteRiskInput(AcuteRiskInput input) {
    final errors = <ValidationError>[];

    // Age validation
    if (input.ageYears < AcuteRiskModelConfig.validationRanges['AgeYears']!['min'] ||
        input.ageYears > AcuteRiskModelConfig.validationRanges['AgeYears']!['max']) {
      errors.add(ValidationError(
        fieldName: 'Age',
        message: 'Age must be between 32-76 years',
        expectedRange: '32-76 years',
      ));
    }

    // Resting Blood Pressure validation
    if (input.restingBP_mmHg < AcuteRiskModelConfig.validationRanges['RestingBP_mmHg']!['min'] ||
        input.restingBP_mmHg > AcuteRiskModelConfig.validationRanges['RestingBP_mmHg']!['max']) {
      errors.add(ValidationError(
        fieldName: 'Resting BP',
        message: 'Resting Blood Pressure must be between 80-200 mmHg',
        expectedRange: '80-200 mmHg',
      ));
    } else if (input.restingBP_mmHg > 160) {
      // Warning (but allow submission)
      print('⚠️ Warning: Resting BP ${input.restingBP_mmHg} mmHg is elevated');
    }

    // Cholesterol validation
    if (input.cholesterol_mg_dL < 0 ||
        input.cholesterol_mg_dL > AcuteRiskModelConfig.validationRanges['Cholesterol_mg_dL']!['max']) {
      errors.add(ValidationError(
        fieldName: 'Cholesterol',
        message: 'Cholesterol must be between 0-400 mg/dL (0 = missing/unknown)',
        expectedRange: '0-400 mg/dL',
      ));
    }

    // Maximum Heart Rate validation
    if (input.maxHR_bpm < AcuteRiskModelConfig.validationRanges['MaxHR_bpm']!['min'] ||
        input.maxHR_bpm > AcuteRiskModelConfig.validationRanges['MaxHR_bpm']!['max']) {
      errors.add(ValidationError(
        fieldName: 'Max HR',
        message: 'Maximum Heart Rate must be between 60-202 bpm',
        expectedRange: '60-202 bpm',
      ));
    }

    // Oldpeak validation
    if (input.oldpeak < 0 ||
        input.oldpeak > AcuteRiskModelConfig.validationRanges['Oldpeak']!['max']) {
      errors.add(ValidationError(
        fieldName: 'Oldpeak',
        message: 'Oldpeak must be between 0-6.2',
        expectedRange: '0-6.2',
      ));
    }

    return errors;
  }

  /// Validate chronic risk input data
  static List<ValidationError> validateChronicRiskInput(ChronicRiskInput input) {
    final errors = <ValidationError>[];

    // Age validation
    if (input.ageYears < ChronicRiskModelConfig.validationRanges['AgeYears']!['min'] ||
        input.ageYears > ChronicRiskModelConfig.validationRanges['AgeYears']!['max']) {
      errors.add(ValidationError(
        fieldName: 'Age',
        message: 'Age must be between 41-72 years',
        expectedRange: '41-72 years',
      ));
    }

    // Height validation
    if (input.heightCm < ChronicRiskModelConfig.validationRanges['HeightCm']!['min'] ||
        input.heightCm > ChronicRiskModelConfig.validationRanges['HeightCm']!['max']) {
      errors.add(ValidationError(
        fieldName: 'Height',
        message: 'Height must be between 157-200 cm',
        expectedRange: '157-200 cm',
      ));
    }

    // Weight validation
    if (input.weightKg < ChronicRiskModelConfig.validationRanges['WeightKg']!['min'] ||
        input.weightKg > ChronicRiskModelConfig.validationRanges['WeightKg']!['max']) {
      errors.add(ValidationError(
        fieldName: 'Weight',
        message: 'Weight must be between 59-103 kg',
        expectedRange: '59-103 kg',
      ));
    }

    // Systolic Blood Pressure validation
    if (input.systolicBP_mmHg < ChronicRiskModelConfig.validationRanges['SystolicBP_mmHg']!['min'] ||
        input.systolicBP_mmHg > ChronicRiskModelConfig.validationRanges['SystolicBP_mmHg']!['max']) {
      errors.add(ValidationError(
        fieldName: 'Systolic BP',
        message: 'Systolic Blood Pressure must be between 99-164 mmHg',
        expectedRange: '99-164 mmHg',
      ));
    }

    // Diastolic Blood Pressure validation
    if (input.diastolicBP_mmHg < ChronicRiskModelConfig.validationRanges['DiastolicBP_mmHg']!['min'] ||
        input.diastolicBP_mmHg > ChronicRiskModelConfig.validationRanges['DiastolicBP_mmHg']!['max']) {
      errors.add(ValidationError(
        fieldName: 'Diastolic BP',
        message: 'Diastolic Blood Pressure must be between 60-100 mmHg',
        expectedRange: '60-100 mmHg',
      ));
    }

    // Check if diastolic > systolic
    if (input.diastolicBP_mmHg > input.systolicBP_mmHg) {
      errors.add(ValidationError(
        fieldName: 'Blood Pressure',
        message:
            'Diastolic BP (${input.diastolicBP_mmHg}) cannot be greater than Systolic BP (${input.systolicBP_mmHg})',
      ));
    }

    // Cholesterol validation
    if (input.cholesterol_mg_dL < ChronicRiskModelConfig.validationRanges['Cholesterol_mg_dL']!['min'] ||
        input.cholesterol_mg_dL > ChronicRiskModelConfig.validationRanges['Cholesterol_mg_dL']!['max']) {
      errors.add(ValidationError(
        fieldName: 'Cholesterol',
        message: 'Cholesterol must be between 148-284 mg/dL',
        expectedRange: '148-284 mg/dL',
      ));
    }

    // Glucose validation
    if (input.glucose_mg_dL < ChronicRiskModelConfig.validationRanges['Glucose_mg_dL']!['min'] ||
        input.glucose_mg_dL > ChronicRiskModelConfig.validationRanges['Glucose_mg_dL']!['max']) {
      errors.add(ValidationError(
        fieldName: 'Glucose',
        message: 'Glucose must be between 76-147 mg/dL',
        expectedRange: '76-147 mg/dL',
      ));
    }

    return errors;
  }

  /// Clip age to valid range for acute risk
  static int clipAcuteRiskAge(int age) {
    final min = AcuteRiskModelConfig.validationRanges['AgeYears']!['min'] as int;
    final max = AcuteRiskModelConfig.validationRanges['AgeYears']!['max'] as int;
    return age.clamp(min, max);
  }

  /// Clip age to valid range for chronic risk
  static int clipChronicRiskAge(int age) {
    final min = ChronicRiskModelConfig.validationRanges['AgeYears']!['min'] as int;
    final max = ChronicRiskModelConfig.validationRanges['AgeYears']!['max'] as int;
    return age.clamp(min, max);
  }

  /// Check if all required fields are provided (non-null)
  static bool areAllFieldsFilled({
    required bool acuteTest,
    required List<ValidationError> errors,
  }) {
    return errors.isEmpty;
  }
}

