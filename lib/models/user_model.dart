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
}
