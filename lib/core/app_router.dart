import 'package:flutter/material.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/auth/role_selection_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/patient_register_screen.dart';
import '../screens/auth/doctor_register_screen.dart';
import '../screens/patient/patient_dashboard.dart';
import '../screens/doctor/doctor_dashboard.dart';
import '../screens/doctor/reports_database_screen.dart';
import '../screens/common/settings_screen.dart';
import '../screens/common/loading_screen.dart';
import '../screens/common/main_navigation_screen.dart';
import '../screens/patient/ecg_waveform_screen.dart';
import '../screens/patient/ai_insights_screen.dart';

// Analysis Flow Screens (Reusable)
import '../screens/analysis/patient_info_screen.dart';
import '../screens/analysis/clinical_measurements_screen.dart';
import '../screens/analysis/ecg_context_screen.dart';
import '../screens/analysis/ecg_upload_screen.dart';
import '../screens/analysis/risk_result_screen.dart';
import '../screens/doctor/report_detail_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String roleSelection = '/role-selection';
  static const String login = '/login';
  static const String patientRegister = '/patient-register';
  static const String doctorRegister = '/doctor-register';
  static const String patientDashboard = '/patient-dashboard';
  static const String doctorDashboard = '/doctor-dashboard';
  static const String settings = '/settings';

  // Analysis Flow
  static const String analysisPatientInfo = '/analysis/patient-info';
  static const String analysisClinical = '/analysis/clinical';
  static const String analysisECGContext = '/analysis/ecg-context';
  static const String analysisECGUpload = '/analysis/ecg-upload';
  static const String loading = '/loading';
  static const String riskResult = '/risk-result';
  static const String ecgWaveform = '/ecg-waveform';
  static const String aiInsights = '/ai-insights';

  // Doctor Specific
  static const String reportsDatabase = '/reports-database';
  static const String reportDetail = '/report-detail';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case roleSelection:
        return MaterialPageRoute(builder: (_) => const RoleSelectionScreen());
      case login:
        final role = settings.arguments as String? ?? 'patient';
        return MaterialPageRoute(builder: (_) => LoginScreen(role: role));
      case patientRegister:
        return MaterialPageRoute(builder: (_) => const PatientRegisterScreen());
      case doctorRegister:
        return MaterialPageRoute(builder: (_) => const DoctorRegisterScreen());
      case patientDashboard:
      case doctorDashboard:
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen());
      case analysisPatientInfo:
        return MaterialPageRoute(builder: (_) => const PatientInfoScreen());
      case analysisClinical:
        return MaterialPageRoute(builder: (_) => const ClinicalMeasurementsScreen());
      case analysisECGContext:
        return MaterialPageRoute(builder: (_) => const ECGContextScreen());
      case analysisECGUpload:
        return MaterialPageRoute(builder: (_) => const ECGUploadScreen());
      case loading:
        return MaterialPageRoute(builder: (_) => const LoadingScreen());
      case riskResult:
        return MaterialPageRoute(builder: (_) => const RiskResultScreen());
      case ecgWaveform:
        return MaterialPageRoute(builder: (_) => const ECGWaveformScreen());
      case aiInsights:
        return MaterialPageRoute(builder: (_) => const AIInsightsScreen());
      case reportsDatabase:
        return MaterialPageRoute(builder: (_) => const ReportsDatabaseScreen());
      case reportDetail:
        final reportId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => ReportDetailScreen(reportId: reportId));
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
