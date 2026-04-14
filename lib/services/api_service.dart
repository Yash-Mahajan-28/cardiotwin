import 'dart:async';
import '../models/user_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    // Mocking logic to decide role based on email if needed
    UserRole role = email.contains('doctor') ? UserRole.doctor : UserRole.patient;
    return UserModel(
      id: '123',
      name: email.split('@')[0],
      email: email,
      role: role,
    );
  }

  Future<bool> registerPatient(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> registerDoctor(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<Map<String, dynamic>> getRiskResult() async {
    await Future.delayed(const Duration(seconds: 3));
    return {
      'riskScore': 78,
      'riskLevel': 'High',
      'explanation': 'Based on your ECG and clinical data, there is a 78% probability of CAD. An elevated ST depression and high cholesterol are key contributing factors.',
    };
  }

  Future<List<Map<String, dynamic>>> getReports() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      {
        'id': '1',
        'patientName': 'John Doe',
        'age': 54,
        'gender': 'Male',
        'status': 'Pending Verification',
        'date': 'Oct 24, 2023',
        'acuteRisk': 'High',
        'chronicRisk': 'Moderate',
      },
      {
        'id': '2',
        'patientName': 'Sarah Jenkins',
        'age': 62,
        'gender': 'Female',
        'status': 'Verified',
        'date': 'Oct 23, 2023',
        'acuteRisk': 'High',
        'chronicRisk': 'Low',
      },
    ];
  }
}
