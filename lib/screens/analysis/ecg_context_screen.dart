import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/app_router.dart';
import '../../widgets/custom_button.dart';

class ECGContextScreen extends StatefulWidget {
  const ECGContextScreen({super.key});

  @override
  State<ECGContextScreen> createState() => _ECGContextScreenState();
}

class _ECGContextScreenState extends State<ECGContextScreen> {
  String _chestPainType = 'Typical Angina';
  String _restingECG = 'Normal';
  bool _exerciseAngina = false;
  String _stSlope = 'Upsloping';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('ECG Context'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.p24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Chest Pain Type'),
            const SizedBox(height: 8),
            _buildDropdown(
              value: _chestPainType,
              items: ['Typical Angina', 'Atypical Angina', 'Non-anginal Pain', 'Asymptomatic'],
              onChanged: (val) => setState(() => _chestPainType = val!),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Resting ECG Results'),
            const SizedBox(height: 8),
            _buildDropdown(
              value: _restingECG,
              items: ['Normal', 'ST-T Wave Abnormality', 'Left Ventricular Hypertrophy'],
              onChanged: (val) => setState(() => _restingECG = val!),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.r12),
              ),
              child: SwitchListTile(
                title: const Text('Exercise Induced Angina',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                value: _exerciseAngina,
                onChanged: (val) => setState(() => _exerciseAngina = val),
                activeColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Peak Exercise ST Slope'),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildOptionChip('Upsloping', _stSlope == 'Upsloping'),
                const SizedBox(width: 8),
                _buildOptionChip('Flat', _stSlope == 'Flat'),
                const SizedBox(width: 8),
                _buildOptionChip('Downsloping', _stSlope == 'Downsloping'),
              ],
            ),
            const SizedBox(height: 40),
            CustomButton(
              text: 'Upload ECG & Analyze',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.analysisECGUpload),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.r12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          onChanged: onChanged,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildOptionChip(String label, bool isSelected) {
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _stSlope = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.r12),
            border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
