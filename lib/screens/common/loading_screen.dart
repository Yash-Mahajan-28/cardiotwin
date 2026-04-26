import 'package:flutter/material.dart';
import '../../core/constants.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/cardiac_risk_calculator.dart';
import '../../models/risk_assessment_model.dart';
import '../../models/model_config.dart';
import '../../core/app_router.dart';
import '../../services/patient_record_service.dart';
import '../../models/user_model.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _runMLInference(context);
      }
    });
  }

  Future<void> _runMLInference(BuildContext context) async {
    final appProvider = context.read<AppProvider>();
    final data = appProvider.currentAnalysisData;
    
    try {
      final calculator = CardiacRiskCalculator();
      await calculator.initialize();

      int age = data['age'] ?? 45;
      Sex sex = (data['gender'] == 'Female') ? Sex.FEMALE : Sex.MALE;
      double height = data['height'] ?? 175.0;
      double weight = data['weight'] ?? 70.0;
      double sys = (data['systolic'] is double) ? data['systolic'] : double.tryParse(data['systolic']?.toString() ?? '120') ?? 120.0;
      double dia = (data['diastolic'] is double) ? data['diastolic'] : double.tryParse(data['diastolic']?.toString() ?? '80') ?? 80.0;
      double chol = (data['cholesterol'] is double) ? data['cholesterol'] : double.tryParse(data['cholesterol']?.toString() ?? '200') ?? 200.0;
      double gluc = (data['glucose'] is double) ? data['glucose'] : double.tryParse(data['glucose']?.toString() ?? '100') ?? 100.0;
      double maxHr = (data['maxHR'] is double) ? data['maxHR'] : double.tryParse(data['maxHR']?.toString() ?? '150') ?? 150.0;
      double oldpeak = (data['oldpeak'] is double) ? data['oldpeak'] : double.tryParse(data['oldpeak']?.toString() ?? '1.5') ?? 1.5;
      
      YesNo fastingBS = data['fastingBS'] == true ? YesNo.YES : YesNo.NO;
      YesNo smoker = data['smoker'] == true ? YesNo.YES : YesNo.NO;
      YesNo alcohol = data['alcohol'] == true ? YesNo.YES : YesNo.NO;
      YesNo physicallyActive = data['physicallyActive'] == true ? YesNo.YES : YesNo.NO;
      YesNo exerciseAngina = data['exerciseAngina'] == true ? YesNo.YES : YesNo.NO;

      ChestPainType cp = ChestPainType.NAP;
      if (data['chestPainType'] == 'Typical Angina') cp = ChestPainType.TA;
      else if (data['chestPainType'] == 'Atypical Angina') cp = ChestPainType.ATA;
      else if (data['chestPainType'] == 'Asymptomatic') cp = ChestPainType.ASY;

      RestingECG recg = RestingECG.NORMAL;
      if (data['restingECG'] == 'ST-T Wave Abnormality') recg = RestingECG.ST;
      else if (data['restingECG'] == 'Left Ventricular Hypertrophy') recg = RestingECG.LVH;

      STSlope slope = STSlope.FLAT;
      if (data['stSlope'] == 'Upsloping') slope = STSlope.UP;
      else if (data['stSlope'] == 'Downsloping') slope = STSlope.DOWN;

      final acuteInput = AcuteRiskInput(
        ageYears: age,
        sex: sex,
        chestPainType: cp,
        restingBP_mmHg: sys.toInt(),
        cholesterol_mg_dL: chol.toInt(),
        fastingBS_gt_120mgdL: fastingBS,
        restingECG: recg,
        maxHR_bpm: maxHr.toInt(),
        exerciseAngina: exerciseAngina,
        oldpeak: oldpeak,
        stSlope: slope,
      );

      final chronicInput = ChronicRiskInput(
        ageYears: age,
        sex: sex,
        heightCm: height.toInt(),
        weightKg: weight,
        systolicBP_mmHg: sys.toInt(),
        diastolicBP_mmHg: dia.toInt(),
        cholesterol_mg_dL: chol.toInt(),
        glucose_mg_dL: gluc.toInt(),
        smoker: smoker,
        alcoholUser: alcohol,
        physicallyActive: physicallyActive,
      );

      final acuteResult = await calculator.calculateAcuteRisk(acuteInput);
      final chronicResult = await calculator.calculateChronicRisk(chronicInput);

      appProvider.setPredictionResult({
        'acute_risk': acuteResult.riskPercentage,
        'chronic_risk': chronicResult.riskPercentage,
      });

      // Save accumulated data to Firebase
      try {
        final patientService = PatientRecordService();
        
        final profile = PatientProfile(
          age: age,
          height: height,
          weight: weight,
          gender: data['gender']?.toString() ?? 'Male',
          isSmoker: data['smoker'] == true,
          consumesAlcohol: data['alcohol'] == true,
          isPhysicallyActive: data['physicallyActive'] == true,
        );

        final clinicalData = ClinicalData(
          systolicBP: sys.toInt(),
          diastolicBP: dia.toInt(),
          cholesterol: chol.toInt(),
          glucose: gluc.toInt(),
          fastingBloodSugar: data['fastingBS'] == true,
          maxHeartRate: maxHr.toInt(),
          stDepression: oldpeak,
        );

        final ecgContext = ECGContext(
          chestPainType: data['chestPainType']?.toString() ?? 'Asymptomatic',
          restingECG: data['restingECG']?.toString() ?? 'Normal',
          exerciseAngina: data['exerciseAngina'] == true,
          stSlope: data['stSlope']?.toString() ?? 'Flat',
        );

        await patientService.savePatientProfile(profile);
        await patientService.saveFullAssessment(
          clinicalData: clinicalData,
          ecgContext: ecgContext,
          riskResults: {
            'acute_risk': acuteResult.riskPercentage,
            'chronic_risk': chronicResult.riskPercentage,
          },
        );
      } catch (e) {
        debugPrint("Error saving assessment to Firebase: $e");
      }

    } catch (e) {
      debugPrint("Error during ML calculation: $e");
      appProvider.setPredictionResult({
        'acute_risk': 50.0,
        'chronic_risk': 50.0,
      });
    }

    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.riskResult);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.bolt_rounded,
              size: 80,
              color: AppColors.primary,
            ),
            const SizedBox(height: 32),
            const Text(
              'Analyzing ECG using AI...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Comparing with 10k+ clinical patterns',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                backgroundColor: AppColors.primary.withOpacity(0.1),
                color: AppColors.primary,
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
