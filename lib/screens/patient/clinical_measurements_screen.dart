import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/input_field.dart';
import '../../services/patient_record_service.dart';
import '../../models/user_model.dart';

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
        title: const Text('Clinical Data'),
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
                    hintText: 'e.g. 120',
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: CustomInputField(
                    labelText: 'Diastolic',
                    hintText: 'e.g. 80',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const CustomInputField(
              labelText: 'Cholesterol (mg/dL)',
              hintText: 'e.g. 200',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            const CustomInputField(
              labelText: 'Glucose (mg/dL)',
              hintText: 'e.g. 90',
              keyboardType: TextInputType.number,
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
            const SizedBox(height: 20),
            const CustomInputField(
              labelText: 'Max Heart Rate',
              hintText: 'e.g. 150',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            const CustomInputField(
              labelText: 'ST Depression',
              hintText: 'e.g. 1.5',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 40),
            CustomButton(
              text: 'Continue to ECG',
              onPressed: () async {
                try {
                  final patientService = PatientRecordService();
                  await patientService.saveClinicalMeasurement(ClinicalData(
                    systolicBP: 120, // get this from text controller
                    diastolicBP: 80, // get this from text controller
                    cholesterol: 200, // get this from text controller
                    glucose: 90, // get this from text controller
                    fastingBloodSugar: _fastingBS,
                    maxHeartRate: 150, // get this from text controller
                    stDepression: 1.5, // get this from text controller
                  ));
                } catch (e) {
                  debugPrint('Saving clinical data failed: $e');
                }
                Navigator.pushNamed(context, '/ecg-context');
              },
            ),
          ],
        ),
      ),
    );
  }
}
