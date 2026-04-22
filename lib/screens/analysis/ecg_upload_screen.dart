import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/constants.dart';
import '../../core/app_router.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/ecg_chart.dart';

class ECGUploadScreen extends StatefulWidget {
  const ECGUploadScreen({super.key});

  @override
  State<ECGUploadScreen> createState() => _ECGUploadScreenState();
}

class _ECGUploadScreenState extends State<ECGUploadScreen> {
  bool _isFileUploaded = false;
  String _uploadedFileName = '';

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _isFileUploaded = true;
          _uploadedFileName = result.files.single.name;
        });
      }
    } catch (e) {
      debugPrint("Error picking file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('ECG Signal Upload'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppPadding.p24),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildUploadArea(),
                  const SizedBox(height: 32),
                  if (_isFileUploaded) ...[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Waveform Preview',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ECGChart(
                      spots: ECGChart.mockSpots,
                      height: 120,
                      color: AppColors.primary,
                    ),
                  ],
                ],
              ),
            ),
            CustomButton(
              text: 'Run AI Analysis',
              onPressed: _isFileUploaded
                  ? () => Navigator.pushNamed(context, AppRoutes.loading)
                  : () {},
              backgroundColor: _isFileUploaded ? AppColors.primary : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadArea() {
    return InkWell(
      onTap: _pickFile,
      borderRadius: BorderRadius.circular(AppRadius.r16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.r16),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.5),
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              _isFileUploaded ? Icons.check_circle_rounded : Icons.cloud_upload_outlined,
              size: 64,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              _isFileUploaded ? 'ECG Signal Ready' : 'Upload ECG Signal',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _isFileUploaded ? _uploadedFileName : 'CSV, EDF or JSON format for high-precision CardioTwin AI analysis.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 24),
            if (!_isFileUploaded)
              CustomOutlineButton(
                text: 'Select File from Device',
                onPressed: _pickFile,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}
