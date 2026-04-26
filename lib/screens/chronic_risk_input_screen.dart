/// Input form for Chronic Risk Assessment (Cardiac Failure)

import 'package:flutter/material.dart';
import '../models/model_config.dart';
import '../models/risk_assessment_model.dart';
import '../models/cardiac_risk_calculator.dart';
import '../widgets/feature_input_field.dart';
import 'risk_result_screen.dart';
import '../models/user_model.dart';
import '../services/patient_record_service.dart';

class ChronicRiskInputScreen extends StatefulWidget {
  final CardiacRiskCalculator calculator;

  const ChronicRiskInputScreen({
    Key? key,
    required this.calculator,
  }) : super(key: key);

  @override
  State<ChronicRiskInputScreen> createState() => _ChronicRiskInputScreenState();
}

class _ChronicRiskInputScreenState extends State<ChronicRiskInputScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Form field controllers
  late TextEditingController _ageController;
  Sex _selectedSex = Sex.MALE;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _systolicBPController;
  late TextEditingController _diastolicBPController;
  late TextEditingController _cholesterolController;
  late TextEditingController _glucoseController;
  YesNo _selectedSmoker = YesNo.NO;
  YesNo _selectedAlcoholUser = YesNo.NO;
  YesNo _selectedPhysicallyActive = YesNo.YES;

  @override
  void initState() {
    super.initState();
    _ageController = TextEditingController();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
    _systolicBPController = TextEditingController();
    _diastolicBPController = TextEditingController();
    _cholesterolController = TextEditingController();
    _glucoseController = TextEditingController();
  }

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _systolicBPController.dispose();
    _diastolicBPController.dispose();
    _cholesterolController.dispose();
    _glucoseController.dispose();
    super.dispose();
  }

  double _calculateBMI() {
    if (_heightController.text.isEmpty || _weightController.text.isEmpty) {
      return 0;
    }
    final height = int.tryParse(_heightController.text) ?? 0;
    final weight = double.tryParse(_weightController.text) ?? 0;
    if (height == 0 || weight == 0) return 0;
    final heightM = height / 100.0;
    return weight / (heightM * heightM);
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final input = ChronicRiskInput(
        ageYears: int.parse(_ageController.text),
        sex: _selectedSex,
        heightCm: int.parse(_heightController.text),
        weightKg: double.parse(_weightController.text),
        systolicBP_mmHg: int.parse(_systolicBPController.text),
        diastolicBP_mmHg: int.parse(_diastolicBPController.text),
        cholesterol_mg_dL: int.parse(_cholesterolController.text),
        glucose_mg_dL: int.parse(_glucoseController.text),
        smoker: _selectedSmoker,
        alcoholUser: _selectedAlcoholUser,
        physicallyActive: _selectedPhysicallyActive,
      );

      final result = await widget.calculator.calculateChronicRisk(input);

      try {
        final patientService = PatientRecordService();
        
        final patientProfile = PatientProfile(
          age: input.ageYears,
          height: input.heightCm.toDouble(),
          weight: input.weightKg,
          gender: input.sex.name,
          isSmoker: input.smoker == YesNo.YES,
          consumesAlcohol: input.alcoholUser == YesNo.YES,
          isPhysicallyActive: input.physicallyActive == YesNo.YES,
        );

        await patientService.savePatientProfile(patientProfile);

        final clinicalData = ClinicalData(
          systolicBP: input.systolicBP_mmHg,
          diastolicBP: input.diastolicBP_mmHg,
          cholesterol: input.cholesterol_mg_dL,
          glucose: input.glucose_mg_dL,
          fastingBloodSugar: false, // fallback
          maxHeartRate: 70, // fallback
          stDepression: 0.0, // fallback
        );

        final ecgContext = ECGContext(
          chestPainType: 'N/A', // Not used for chronic
          restingECG: 'N/A', // Not used for chronic
          exerciseAngina: false, // Not used for chronic
          stSlope: 'N/A', // Not used for chronic
        );

        // Automatically save the assessment upon submission
        await patientService.saveFullAssessment(
          clinicalData: clinicalData,
          ecgContext: ecgContext,
          riskResults: {
            'chronic_risk_score': result.riskPercentage,
            'risk_level': result.category.name,
          },
        );
      } catch (e) {
        debugPrint('Auto-save error: $e');
      }

      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RiskResultScreen(
              result: result,
              onClose: () => Navigator.of(context).pop(),
              onSaveAssessment: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Assessment was automatically saved to Firebase')),
                );
              },
              onShareResult: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sharing not yet implemented')),
                );
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Cardiac Failure Risk Assessment',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please enter your health information below',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),

            // Age
            FeatureInputField(
              label: 'Age (years)',
              hintText: 'Enter your age',
              suffixText: 'years',
              inputType: TextInputType.number,
              controller: _ageController,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Age is required';
                final age = int.tryParse(value!);
                if (age == null) return 'Enter a valid number';
                if (age < 41 || age > 72) return 'Age must be 41-72 years';
                return null;
              },
              onChanged: (_) {},
            ),

            // Sex
            Text(
              'Sex *',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButton<Sex>(
              value: _selectedSex,
              isExpanded: true,
              items: Sex.values
                  .map((sex) => DropdownMenuItem(
                    value: sex,
                    child: Text(sex.label),
                  ))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedSex = value ?? Sex.MALE);
              },
            ),
            const SizedBox(height: 16),

            // Height
            FeatureInputField(
              label: 'Height',
              hintText: 'Enter your height',
              suffixText: 'cm',
              inputType: TextInputType.number,
              controller: _heightController,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Height is required';
                final h = int.tryParse(value!);
                if (h == null) return 'Enter a valid number';
                if (h < 157 || h > 200) return 'Height must be 157-200 cm';
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),

            // Weight
            FeatureInputField(
              label: 'Weight',
              hintText: 'Enter your weight',
              suffixText: 'kg',
              inputType: TextInputType.number,
              controller: _weightController,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Weight is required';
                final w = double.tryParse(value!);
                if (w == null) return 'Enter a valid number';
                if (w < 59 || w > 103) return 'Weight must be 59-103 kg';
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),

            // BMI Display
            if (_calculateBMI() > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Text(
                    'BMI: ${_calculateBMI().toStringAsFixed(2)} kg/m²',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.blue[900],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

            // Systolic BP
            FeatureInputField(
              label: 'Systolic Blood Pressure',
              hintText: 'Enter systolic BP',
              suffixText: 'mmHg',
              inputType: TextInputType.number,
              controller: _systolicBPController,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Systolic BP is required';
                final bp = int.tryParse(value!);
                if (bp == null) return 'Enter a valid number';
                if (bp < 99 || bp > 164) return 'Systolic BP must be 99-164 mmHg';
                return null;
              },
              onChanged: (_) {},
            ),

            // Diastolic BP
            FeatureInputField(
              label: 'Diastolic Blood Pressure',
              hintText: 'Enter diastolic BP',
              suffixText: 'mmHg',
              inputType: TextInputType.number,
              controller: _diastolicBPController,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Diastolic BP is required';
                final bp = int.tryParse(value!);
                if (bp == null) return 'Enter a valid number';
                if (bp < 60 || bp > 100) return 'Diastolic BP must be 60-100 mmHg';
                final systolic = int.tryParse(_systolicBPController.text);
                if (systolic != null && bp > systolic) {
                  return 'Diastolic BP cannot be greater than Systolic BP';
                }
                return null;
              },
              onChanged: (_) {},
            ),

            // Cholesterol
            FeatureInputField(
              label: 'Cholesterol',
              hintText: 'Enter cholesterol level',
              suffixText: 'mg/dL',
              inputType: TextInputType.number,
              controller: _cholesterolController,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Cholesterol is required';
                final chol = int.tryParse(value!);
                if (chol == null) return 'Enter a valid number';
                if (chol < 148 || chol > 284) return 'Cholesterol must be 148-284 mg/dL';
                return null;
              },
              onChanged: (_) {},
            ),

            // Glucose
            FeatureInputField(
              label: 'Fasting Glucose',
              hintText: 'Enter glucose level',
              suffixText: 'mg/dL',
              inputType: TextInputType.number,
              controller: _glucoseController,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Glucose is required';
                final glc = int.tryParse(value!);
                if (glc == null) return 'Enter a valid number';
                if (glc < 76 || glc > 147) return 'Glucose must be 76-147 mg/dL';
                return null;
              },
              onChanged: (_) {},
            ),

            // Smoker
            Text(
              'Current Smoker *',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButton<YesNo>(
              value: _selectedSmoker,
              isExpanded: true,
              items: YesNo.values
                  .map((val) => DropdownMenuItem(
                    value: val,
                    child: Text(val.label),
                  ))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedSmoker = value ?? YesNo.NO);
              },
            ),
            const SizedBox(height: 16),

            // Alcohol User
            Text(
              'Alcohol User *',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButton<YesNo>(
              value: _selectedAlcoholUser,
              isExpanded: true,
              items: YesNo.values
                  .map((val) => DropdownMenuItem(
                    value: val,
                    child: Text(val.label),
                  ))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedAlcoholUser = value ?? YesNo.NO);
              },
            ),
            const SizedBox(height: 16),

            // Physically Active
            Text(
              'Physically Active *',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButton<YesNo>(
              value: _selectedPhysicallyActive,
              isExpanded: true,
              items: YesNo.values
                  .map((val) => DropdownMenuItem(
                    value: val,
                    child: Text(val.label),
                  ))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedPhysicallyActive = value ?? YesNo.YES);
              },
            ),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: const Color(0xFF1976D2),
                  disabledBackgroundColor: Colors.grey[400],
                ),
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Text(
                  'Calculate Risk',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

