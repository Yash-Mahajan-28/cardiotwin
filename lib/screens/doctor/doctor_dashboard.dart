import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/app_router.dart';

class DoctorDashboard extends StatelessWidget {
  const DoctorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Doctor Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.p20),
        child: Column(
          children: [
            _buildStatsRow(),
            const SizedBox(height: 24),
            _buildActionCard(
            context,
            title: 'New Patient Analysis',
            subtitle: 'Perform a new cardiac risk assessment for a patient.',
            icon: Icons.person_add_alt_1_rounded,
            color: AppColors.primary,
            onTap: () => Navigator.pushNamed(context, AppRoutes.analysisPatientInfo),
          ),
          const SizedBox(height: 16),
          _buildActionCard(
            context,
            title: 'Patient Reports Database',
            subtitle: 'View, verify, and manage all patient reports.',
            icon: Icons.folder_shared_rounded,
            color: Colors.indigo,
            onTap: () => Navigator.pushNamed(context, AppRoutes.reportsDatabase),
          ),
          const SizedBox(height: 32),
          _buildSectionHeader('Recent Pending Reports'),
          const SizedBox(height: 16),
          _buildPendingReportCard(context, 'John Doe', '54Y, Male', 'High Risk'),
          const SizedBox(height: 12),
          _buildPendingReportCard(context, 'Emily White', '31Y, Female', 'Moderate Risk'),
        ],
      ),
    ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatItem('Pending', '12', Colors.orange),
        const SizedBox(width: 16),
        _buildStatItem('Verified', '145', Colors.green),
        const SizedBox(width: 16),
        _buildStatItem('Alerts', '03', Colors.red),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.r12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.r16),
      child: Container(
        padding: const EdgeInsets.all(AppPadding.p24),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppRadius.r16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: Colors.white, size: 32),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildPendingReportCard(BuildContext context, String name, String info, String risk) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(backgroundColor: AppColors.background, child: Icon(Icons.person, color: AppColors.primary)),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(info),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(risk, style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        onTap: () => Navigator.pushNamed(context, AppRoutes.riskResult),
      ),
    );
  }
}
