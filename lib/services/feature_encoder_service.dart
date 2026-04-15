/// Service for encoding categorical features

import '../models/model_config.dart';

class FeatureEncoderService {
  /// Encode sex string to integer
  /// "Male" or "M" -> 1
  /// "Female" or "F" -> 0
  static int encodeSex(String value) {
    final normalized = value.trim().toUpperCase();
    if (normalized == 'MALE' || normalized == 'M' || normalized == '1') {
      return Sex.MALE.code;
    } else if (normalized == 'FEMALE' || normalized == 'F' || normalized == '0') {
      return Sex.FEMALE.code;
    }
    throw ArgumentError('Invalid sex value: $value');
  }

  /// Encode sex enum to integer
  static int encodeSexEnum(Sex sex) {
    return sex.code;
  }

  /// Decode integer back to Sex enum
  static Sex decodeSex(int code) {
    return Sex.fromCode(code);
  }

  /// Encode chest pain type string to integer
  static int encodeChestPainType(String value) {
    final normalized = value.trim().toUpperCase();
    if (normalized == 'ASY' || normalized == 'ASYMPTOMATIC' || normalized == '0') {
      return ChestPainType.ASY.code;
    } else if (normalized == 'ATA' || normalized == 'ATYPICAL' || normalized == '1') {
      return ChestPainType.ATA.code;
    } else if (normalized == 'NAP' || normalized == 'NON-ANGINAL' || normalized == '2') {
      return ChestPainType.NAP.code;
    } else if (normalized == 'TA' || normalized == 'TYPICAL' || normalized == '3') {
      return ChestPainType.TA.code;
    }
    throw ArgumentError('Invalid chest pain type: $value');
  }

  /// Encode chest pain type enum to integer
  static int encodeChestPainTypeEnum(ChestPainType type) {
    return type.code;
  }

  /// Decode integer back to ChestPainType enum
  static ChestPainType decodeChestPainType(int code) {
    return ChestPainType.fromCode(code);
  }

  /// Encode resting ECG string to integer
  static int encodeRestingECG(String value) {
    final normalized = value.trim().toUpperCase();
    if (normalized == 'LVH' || normalized == 'LEFT VENTRICULAR' || normalized == '0') {
      return RestingECG.LVH.code;
    } else if (normalized == 'NORMAL' || normalized == '1') {
      return RestingECG.NORMAL.code;
    } else if (normalized == 'ST' || normalized == 'ST-T ABNORMALITY' || normalized == '2') {
      return RestingECG.ST.code;
    }
    throw ArgumentError('Invalid resting ECG: $value');
  }

  /// Encode resting ECG enum to integer
  static int encodeRestingECGEnum(RestingECG ecg) {
    return ecg.code;
  }

  /// Decode integer back to RestingECG enum
  static RestingECG decodeRestingECG(int code) {
    return RestingECG.fromCode(code);
  }

  /// Encode ST slope string to integer
  static int encodeSTSlope(String value) {
    final normalized = value.trim().toUpperCase();
    if (normalized == 'DOWN' || normalized == 'DOWNSLOPING' || normalized == '0') {
      return STSlope.DOWN.code;
    } else if (normalized == 'FLAT' || normalized == '1') {
      return STSlope.FLAT.code;
    } else if (normalized == 'UP' || normalized == 'UPSLOPING' || normalized == '2') {
      return STSlope.UP.code;
    }
    throw ArgumentError('Invalid ST slope: $value');
  }

  /// Encode ST slope enum to integer
  static int encodeSTSlopeEnum(STSlope slope) {
    return slope.code;
  }

  /// Decode integer back to STSlope enum
  static STSlope decodeSTSlope(int code) {
    return STSlope.fromCode(code);
  }

  /// Encode yes/no string to integer
  static int encodeYesNo(String value) {
    final normalized = value.trim().toUpperCase();
    if (normalized == 'YES' || normalized == 'Y' || normalized == 'TRUE' || normalized == '1') {
      return YesNo.YES.code;
    } else if (normalized == 'NO' || normalized == 'N' || normalized == 'FALSE' || normalized == '0') {
      return YesNo.NO.code;
    }
    throw ArgumentError('Invalid yes/no value: $value');
  }

  /// Encode yes/no enum to integer
  static int encodeYesNoEnum(YesNo value) {
    return value.code;
  }

  /// Decode integer back to YesNo enum
  static YesNo decodeYesNo(int code) {
    return YesNo.fromCode(code);
  }

  /// Get all available options for a categorical feature
  static List<String> getChestPainTypeOptions() {
    return ChestPainType.values.map((e) => e.label).toList();
  }

  static List<String> getRestingECGOptions() {
    return RestingECG.values.map((e) => e.label).toList();
  }

  static List<String> getSTSlopeOptions() {
    return STSlope.values.map((e) => e.label).toList();
  }

  static List<String> getSexOptions() {
    return Sex.values.map((e) => e.label).toList();
  }

  static List<String> getYesNoOptions() {
    return YesNo.values.map((e) => e.label).toList();
  }
}

