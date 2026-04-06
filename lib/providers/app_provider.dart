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
}
