import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/app_router.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/input_field.dart';
import '../../providers/app_provider.dart';
import '../../models/user_model.dart';

class PatientInfoScreen extends StatefulWidget {
  const PatientInfoScreen({super.key});

  @override
  State<PatientInfoScreen> createState() => _PatientInfoScreenState();
}

class _PatientInfoScreenState extends State<PatientInfoScreen> {
  String _gender = 'Male';
  bool _isSmoker = false;
  bool _consumesAlcohol = false;
  bool _isPhysicallyActive = true;
  final TextEditingController _ageCtrl = TextEditingController(text: '45');
  final TextEditingController _heightCtrl = TextEditingController(text: '175');
  final TextEditingController _weightCtrl = TextEditingController(text: '70');

  @override
  Widget build(BuildContext context) {
    final userRole = context.read<AppProvider>().userRole;
    final isDoctor = userRole == UserRole.doctor;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isDoctor ? 'Patient Information' : 'Personal Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.p24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isDoctor) ...[
              const Text(
                'Enter the patient\'s personal details to start the cardiac health risk monitoring.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 24),
            ],
            CustomInputField(
              controller: _ageCtrl,
              labelText: 'Age',
              hintText: 'e.g. 35',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomInputField(
                    controller: _heightCtrl,
                    labelText: 'Height (cm)',
                    hintText: '175',
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: CustomInputField(
                    controller: _weightCtrl,
                    labelText: 'Weight (kg)',
                    hintText: '70',
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
              'Physically Active',
              'Regular exercise (3+ times a week)',
              _isPhysicallyActive,
              (val) => setState(() => _isPhysicallyActive = val),
            ),
            _buildSwitchTile(
              'Smoker',
              'Current or frequent smoker',
              _isSmoker,
              (val) => setState(() => _isSmoker = val),
            ),
            _buildSwitchTile(
              'Alcohol Consumption',
              'Regular alcohol consumption',
              _consumesAlcohol,
              (val) => setState(() => _consumesAlcohol = val),
            ),
            const SizedBox(height: 40),
            CustomButton(
              text: 'Next Step',
              onPressed: () {
                context.read<AppProvider>().updateAnalysisData({
                  'age': int.tryParse(_ageCtrl.text) ?? 45,
                  'height': double.tryParse(_heightCtrl.text) ?? 175.0,
                  'weight': double.tryParse(_weightCtrl.text) ?? 70.0,
                  'gender': _gender,
                  'physicallyActive': _isPhysicallyActive,
                  'smoker': _isSmoker,
                  'alcohol': _consumesAlcohol,
                });
                Navigator.pushNamed(context, AppRoutes.analysisClinical);
              }
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
