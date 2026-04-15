/// Input form for Acute Risk Assessment (Heart Disease)

import 'package:flutter/material.dart';
import '../models/model_config.dart';
import '../models/risk_assessment_model.dart';
import '../models/cardiac_risk_calculator.dart';
import '../services/feature_encoder_service.dart';
import '../services/validation_service.dart';
import '../widgets/feature_input_field.dart';
import '../widgets/risk_gauge_widget.dart';
import 'risk_result_screen.dart';

class AcuteRiskInputScreen extends StatefulWidget {
  final CardiacRiskCalculator calculator;

  const AcuteRiskInputScreen({
    Key? key,
    required this.calculator,
  }) : super(key: key);

  @override
  State<AcuteRiskInputScreen> createState() => _AcuteRiskInputScreenState();
}

class _AcuteRiskInputScreenState extends State<AcuteRiskInputScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Form field controllers
  late TextEditingController _ageController;
  Sex _selectedSex = Sex.MALE;
  ChestPainType _selectedChestPainType = ChestPainType.ASY;
  late TextEditingController _restingBPController;
  late TextEditingController _cholesterolController;
  YesNo _selectedFastingBS = YesNo.NO;
  RestingECG _selectedRestingECG = RestingECG.NORMAL;
  late TextEditingController _maxHRController;
  YesNo _selectedExerciseAngina = YesNo.NO;
  late TextEditingController _oldpeakController;
  STSlope _selectedSTSlope = STSlope.UP;

  @override
  void initState() {
    super.initState();
    _ageController = TextEditingController();
    _restingBPController = TextEditingController();
    _cholesterolController = TextEditingController();
    _maxHRController = TextEditingController();
    _oldpeakController = TextEditingController();
  }

  @override
  void dispose() {
    _ageController.dispose();
    _restingBPController.dispose();
    _cholesterolController.dispose();
    _maxHRController.dispose();
    _oldpeakController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final input = AcuteRiskInput(
        ageYears: int.parse(_ageController.text),
        sex: _selectedSex,
        chestPainType: _selectedChestPainType,
        restingBP_mmHg: int.parse(_restingBPController.text),
        cholesterol_mg_dL: int.parse(_cholesterolController.text),
        fastingBS_gt_120mgdL: _selectedFastingBS,
        restingECG: _selectedRestingECG,
        maxHR_bpm: int.parse(_maxHRController.text),
        exerciseAngina: _selectedExerciseAngina,
        oldpeak: double.parse(_oldpeakController.text),
        stSlope: _selectedSTSlope,
      );

      final result = await widget.calculator.calculateAcuteRisk(input);

      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RiskResultScreen(
              result: result,
              onClose: () => Navigator.of(context).pop(),
              onSaveAssessment: () {
                // TODO: Implement save to database
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Assessment saved')),
                );
              },
              onShareResult: () {
                // TODO: Implement share functionality
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
              'Heart Disease Risk Assessment',
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
                if (age < 32 || age > 76) return 'Age must be 32-76 years';
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

            // Chest Pain Type
            Text(
              'Chest Pain Type *',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButton<ChestPainType>(
              value: _selectedChestPainType,
              isExpanded: true,
              items: ChestPainType.values
                  .map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type.label),
                  ))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedChestPainType = value ?? ChestPainType.ASY);
              },
            ),
            const SizedBox(height: 16),

            // Resting Blood Pressure
            FeatureInputField(
              label: 'Resting Blood Pressure',
              hintText: 'Enter resting BP',
              suffixText: 'mmHg',
              inputType: TextInputType.number,
              controller: _restingBPController,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Resting BP is required';
                final bp = int.tryParse(value!);
                if (bp == null) return 'Enter a valid number';
                if (bp < 80 || bp > 200) return 'BP must be 80-200 mmHg';
                return null;
              },
              onChanged: (_) {},
            ),

            // Cholesterol
            FeatureInputField(
              label: 'Cholesterol',
              hintText: 'Enter cholesterol level (0 for unknown)',
              suffixText: 'mg/dL',
              inputType: TextInputType.number,
              controller: _cholesterolController,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Cholesterol is required';
                final chol = int.tryParse(value!);
                if (chol == null) return 'Enter a valid number';
                if (chol < 0 || chol > 400) return 'Cholesterol must be 0-400 mg/dL';
                return null;
              },
              onChanged: (_) {},
            ),

            // Fasting Blood Sugar
            Text(
              'Fasting Blood Sugar > 120 mg/dL *',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButton<YesNo>(
              value: _selectedFastingBS,
              isExpanded: true,
              items: YesNo.values
                  .map((val) => DropdownMenuItem(
                    value: val,
                    child: Text(val.label),
                  ))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedFastingBS = value ?? YesNo.NO);
              },
            ),
            const SizedBox(height: 16),

            // Resting ECG
            Text(
              'Resting ECG *',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButton<RestingECG>(
              value: _selectedRestingECG,
              isExpanded: true,
              items: RestingECG.values
                  .map((ecg) => DropdownMenuItem(
                    value: ecg,
                    child: Text(ecg.label),
                  ))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedRestingECG = value ?? RestingECG.NORMAL);
              },
            ),
            const SizedBox(height: 16),

            // Max Heart Rate
            FeatureInputField(
              label: 'Maximum Heart Rate Achieved',
              hintText: 'Enter max HR',
              suffixText: 'bpm',
              inputType: TextInputType.number,
              controller: _maxHRController,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Max HR is required';
                final hr = int.tryParse(value!);
                if (hr == null) return 'Enter a valid number';
                if (hr < 60 || hr > 202) return 'Max HR must be 60-202 bpm';
                return null;
              },
              onChanged: (_) {},
            ),

            // Exercise Induced Angina
            Text(
              'Exercise Induced Angina *',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButton<YesNo>(
              value: _selectedExerciseAngina,
              isExpanded: true,
              items: YesNo.values
                  .map((val) => DropdownMenuItem(
                    value: val,
                    child: Text(val.label),
                  ))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedExerciseAngina = value ?? YesNo.NO);
              },
            ),
            const SizedBox(height: 16),

            // Oldpeak
            FeatureInputField(
              label: 'Oldpeak (ST depression)',
              hintText: 'Enter oldpeak value',
              inputType: TextInputType.number,
              controller: _oldpeakController,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Oldpeak is required';
                final peak = double.tryParse(value!);
                if (peak == null) return 'Enter a valid number';
                if (peak < 0 || peak > 6.2) return 'Oldpeak must be 0-6.2';
                return null;
              },
              onChanged: (_) {},
            ),

            // ST Slope
            Text(
              'ST Segment Slope *',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButton<STSlope>(
              value: _selectedSTSlope,
              isExpanded: true,
              items: STSlope.values
                  .map((slope) => DropdownMenuItem(
                    value: slope,
                    child: Text(slope.label),
                  ))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedSTSlope = value ?? STSlope.UP);
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

