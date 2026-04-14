import 'package:flutter/material.dart';
import '../../core/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _shareWithResearch = true;
  bool _shareWithProviders = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings & Privacy'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.p24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Data Privacy'),
            _buildToggleCard(
              'Share with Research',
              'Help improve heart disease detection',
              _shareWithResearch,
              (val) => setState(() => _shareWithResearch = val),
            ),
            _buildToggleCard(
              'Share with Providers',
              'Directly sync data to your cardiologist',
              _shareWithProviders,
              (val) => setState(() => _shareWithProviders = val),
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('Model Transparency'),
            _buildInfoCard(
              'AI Core Version',
              'v2.4.1 (Stable Build)',
              Icons.check_circle_outline,
            ),
            _buildInfoCard(
              'Clinical Validation Report',
              'Peer-reviewed performance metrics.',
              Icons.open_in_new,
              isLink: true,
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('Manage Data'),
            _buildActionTile('Export ECG History', Icons.download_rounded, Colors.black),
            _buildActionTile('Delete All ECG History', Icons.delete_outline_rounded, Colors.red),
            const SizedBox(height: 40),
            _buildPrivacyPolicyCard(),
            const SizedBox(height: 40),
            const Center(
              child: Text(
                'CardioTwin Healthcare\nSecure Build 8820-A',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildToggleCard(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  Widget _buildInfoCard(String title, String subtitle, IconData icon, {bool isLink = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: Icon(icon, color: isLink ? AppColors.primary : Colors.grey, size: 20),
      ),
    );
  }

  Widget _buildActionTile(String title, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: color)),
        trailing: const Icon(Icons.chevron_right, size: 20),
        onTap: () {},
      ),
    );
  }

  Widget _buildPrivacyPolicyCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.verified_user_outlined, color: AppColors.primary),
              SizedBox(width: 12),
              Text('Patient Data Protection', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'CardioTwin uses AES-256 end-to-end encryption for all heart rate and ECG telemetry data. Your sensitive medical information is processed locally on-device whenever possible and is fully compliant with HIPAA and GDPR regulations. Only you and authorized healthcare providers can access your full reports.',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton(onPressed: () {}, child: const Text('PRIVACY POLICY', style: TextStyle(fontSize: 12))),
              TextButton(onPressed: () {}, child: const Text('TERMS OF SERVICE', style: TextStyle(fontSize: 12))),
            ],
          ),
        ],
      ),
    );
  }
}
