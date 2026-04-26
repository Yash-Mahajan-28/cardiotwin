import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/input_field.dart';
import '../../services/patient_record_service.dart';
import '../../models/user_model.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  String _gender = 'Male';
  bool _isSmoker = false;
  bool _consumesAlcohol = false;
  bool _isPhysicallyActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Personal Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.p24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomInputField(
              labelText: 'Age',
              hintText: 'Enter your age',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            const Row(
              children: [
                Expanded(
                  child: CustomInputField(
                    labelText: 'Height (cm)',
                    hintText: 'e.g. 175',
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: CustomInputField(
                    labelText: 'Weight (kg)',
                    hintText: 'e.g. 70',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Gender',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildGenderOption('Male'),
                const SizedBox(width: 12),
                _buildGenderOption('Female'),
                const SizedBox(width: 12),
                _buildGenderOption('Other'),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Lifestyle Factors',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildSwitchTile(
              'Smoker',
              'Do you smoke currently?',
              _isSmoker,
              (val) => setState(() => _isSmoker = val),
            ),
            _buildSwitchTile(
              'Alcohol Consumption',
              'Do you consume alcohol regularly?',
              _consumesAlcohol,
              (val) => setState(() => _consumesAlcohol = val),
            ),
            _buildSwitchTile(
              'Physically Active',
              'Do you exercise at least 3 times a week?',
              _isPhysicallyActive,
              (val) => setState(() => _isPhysicallyActive = val),
            ),
            const SizedBox(height: 40),
            CustomButton(
              text: 'Continue',
              onPressed: () async {
                try {
                  final patientService = PatientRecordService();
                  await patientService.savePatientProfile(PatientProfile(
                    age: 35, // You'd normally get this from your age controller
                    height: 175.0, // get this from height controller
                    weight: 70.0, // get this from weight controller
                    gender: _gender,
                    isSmoker: _isSmoker,
                    consumesAlcohol: _consumesAlcohol,
                    isPhysicallyActive: _isPhysicallyActive,
                  ));
                } catch (e) {
                  debugPrint('Saving profile failed: $e');
                }
                Navigator.pushNamed(context, '/clinical-measurements');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderOption(String gender) {
    bool isSelected = _gender == gender;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _gender = gender),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.r12),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade300,
            ),
          ),
          child: Center(
            child: Text(
              gender,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.r12),
      ),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
