import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/app_router.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/input_field.dart';

class ClinicalMeasurementsScreen extends StatefulWidget {
  const ClinicalMeasurementsScreen({super.key});

  @override
  State<ClinicalMeasurementsScreen> createState() => _ClinicalMeasurementsScreenState();
}

class _ClinicalMeasurementsScreenState extends State<ClinicalMeasurementsScreen> {
  bool _fastingBS = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Clinical Measurements'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.p24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Blood Pressure (mmHg)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Expanded(
                  child: CustomInputField(
                    labelText: 'Systolic',
                    hintText: '120',
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: CustomInputField(
                    labelText: 'Diastolic',
                    hintText: '80',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Laboratory Results',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const CustomInputField(
              labelText: 'Cholesterol Level',
              hintText: 'Select status',
              suffixIcon: Icon(Icons.arrow_drop_down),
            ),
            const SizedBox(height: 20),
            const CustomInputField(
              labelText: 'Glucose Level',
              hintText: 'Select status',
              suffixIcon: Icon(Icons.arrow_drop_down),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.r12),
              ),
              child: SwitchListTile(
                title: const Text('Fasting Blood Sugar > 120 mg/dL',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                value: _fastingBS,
                onChanged: (val) => setState(() => _fastingBS = val),
                activeColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Cardiac Metrics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const CustomInputField(
              labelText: 'Maximum Heart Rate (bpm)',
              hintText: '150',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            const CustomInputField(
              labelText: 'ST Depression (Oldpeak)',
              hintText: '1.5',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 40),
            CustomButton(
              text: 'Continue to ECG',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.analysisECGContext),
            ),
          ],
        ),
      ),
    );
  }
}
