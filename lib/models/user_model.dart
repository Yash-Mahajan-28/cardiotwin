enum UserRole { patient, doctor }

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? profileImageUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profileImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.toString().split('.').last,
      'profileImageUrl': profileImageUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] == 'doctor' ? UserRole.doctor : UserRole.patient,
      profileImageUrl: map['profileImageUrl'],
    );
  }
}

class PatientProfile {
  final int age;
  final double height;
  final double weight;
  final String gender;
  final bool isSmoker;
  final bool consumesAlcohol;
  final bool isPhysicallyActive;

  PatientProfile({
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
    required this.isSmoker,
    required this.consumesAlcohol,
    required this.isPhysicallyActive,
  });

  Map<String, dynamic> toMap() {
    return {
      'age': age,
      'height': height,
      'weight': weight,
      'gender': gender,
      'isSmoker': isSmoker,
      'consumesAlcohol': consumesAlcohol,
      'isPhysicallyActive': isPhysicallyActive,
    };
  }

  factory PatientProfile.fromMap(Map<String, dynamic> map) {
    return PatientProfile(
      age: map['age']?.toInt() ?? 0,
      height: map['height']?.toDouble() ?? 0.0,
      weight: map['weight']?.toDouble() ?? 0.0,
      gender: map['gender'] ?? '',
      isSmoker: map['isSmoker'] ?? false,
      consumesAlcohol: map['consumesAlcohol'] ?? false,
      isPhysicallyActive: map['isPhysicallyActive'] ?? false,
    );
  }
}

class ClinicalData {
  final int systolicBP;
  final int diastolicBP;
  final int cholesterol;
  final int glucose;
  final bool fastingBloodSugar;
  final int maxHeartRate;
  final double stDepression;

  ClinicalData({
    required this.systolicBP,
    required this.diastolicBP,
    required this.cholesterol,
    required this.glucose,
    required this.fastingBloodSugar,
    required this.maxHeartRate,
    required this.stDepression,
  });

  Map<String, dynamic> toMap() {
    return {
      'systolicBP': systolicBP,
      'diastolicBP': diastolicBP,
      'cholesterol': cholesterol,
      'glucose': glucose,
      'fastingBloodSugar': fastingBloodSugar,
      'maxHeartRate': maxHeartRate,
      'stDepression': stDepression,
    };
  }

  factory ClinicalData.fromMap(Map<String, dynamic> map) {
    return ClinicalData(
      systolicBP: map['systolicBP']?.toInt() ?? 0,
      diastolicBP: map['diastolicBP']?.toInt() ?? 0,
      cholesterol: map['cholesterol']?.toInt() ?? 0,
      glucose: map['glucose']?.toInt() ?? 0,
      fastingBloodSugar: map['fastingBloodSugar'] ?? false,
      maxHeartRate: map['maxHeartRate']?.toInt() ?? 0,
      stDepression: map['stDepression']?.toDouble() ?? 0.0,
    );
  }
}

class ECGContext {
  final String chestPainType;
  final String restingECG;
  final bool exerciseAngina;
  final String stSlope;

  ECGContext({
    required this.chestPainType,
    required this.restingECG,
    required this.exerciseAngina,
    required this.stSlope,
  });

  Map<String, dynamic> toMap() {
    return {
      'chestPainType': chestPainType,
      'restingECG': restingECG,
      'exerciseAngina': exerciseAngina,
      'stSlope': stSlope,
    };
  }

  factory ECGContext.fromMap(Map<String, dynamic> map) {
    return ECGContext(
      chestPainType: map['chestPainType'] ?? '',
      restingECG: map['restingECG'] ?? '',
      exerciseAngina: map['exerciseAngina'] ?? false,
      stSlope: map['stSlope'] ?? '',
    );
  }
}
