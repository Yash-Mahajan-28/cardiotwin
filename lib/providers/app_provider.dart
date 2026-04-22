import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AppProvider with ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;

  UserRole? get userRole => _user?.role;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }

  // Current analysis data (could be moved to a separate AnalysisProvider in a larger app)
  Map<String, dynamic> _currentAnalysisData = {};
  Map<String, dynamic> get currentAnalysisData => _currentAnalysisData;

  void updateAnalysisData(Map<String, dynamic> data) {
    _currentAnalysisData.addAll(data);
    notifyListeners();
  }

  void clearAnalysisData() {
    _currentAnalysisData = {};
    notifyListeners();
  }

  // Prediction Results
  Map<String, dynamic> _predictionResult = {};
  Map<String, dynamic> get predictionResult => _predictionResult;

  void setPredictionResult(Map<String, dynamic> result) {
    _predictionResult = result;
    notifyListeners();
  }

  void clearPredictionResult() {
    _predictionResult = {};
    notifyListeners();
  }

  double get riskScore {
    final acute = _predictionResult['acute_risk'] as double? ?? 0.0;
    final chronic = _predictionResult['chronic_risk'] as double? ?? 0.0;
    return ((acute + chronic) / 2).clamp(0.0, 100.0);
  }

  String get riskLevel {
    final double score = riskScore;
    if (score >= 70) return 'HIGH';
    if (score >= 40) return 'MEDIUM';
    return 'LOW';
  }
}
