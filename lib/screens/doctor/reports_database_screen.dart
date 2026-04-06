import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/app_router.dart';
import '../../widgets/input_field.dart';

class ReportsDatabaseScreen extends StatefulWidget {
  const ReportsDatabaseScreen({super.key});

  @override
  State<ReportsDatabaseScreen> createState() => _ReportsDatabaseScreenState();
}

class _ReportsDatabaseScreenState extends State<ReportsDatabaseScreen> {
  String _selectedFilter = 'Risk: High';

  final List<String> _filters = ['Risk: High', 'Risk: Moderate', 'Recent', 'Pending'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Patient Reports Database'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppPadding.p16),
            child: Column(
              children: [
                const CustomInputField(
                  labelText: '',
                  hintText: 'Search by name or ID...',
                  prefixIcon: Icon(Icons.search),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.map((filter) {
                      bool isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (val) => setState(() => _selectedFilter = filter),
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
              itemCount: 4,
              itemBuilder: (context, index) {
                return _buildReportCard(
                  id: 'ID-${100 + index}',
                  name: index % 2 == 0 ? 'John Doe' : 'Sarah Jenkins',
                  age: index % 2 == 0 ? 54 : 62,
                  gender: index % 2 == 0 ? 'Male' : 'Female',
                  date: 'Oct 24, 2023',
                  status: index % 2 == 0 ? 'PENDING VERIFICATION' : 'VERIFIED',
                  acuteRisk: index % 2 == 0 ? Colors.red : Colors.orange,
                  chronicRisk: index % 2 == 0 ? Colors.orange : Colors.green,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard({
    required String id,
    required String name,
    required int age,
    required String gender,
    required String date,
    required String status,
    required Color acuteRisk,
    required Color chronicRisk,
  }) {
    bool isPending = status == 'PENDING VERIFICATION';
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isPending ? Colors.orange : Colors.green,
                  ),
                ),
                Row(
                  children: [
                    const Text('ACUTE', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                    const SizedBox(width: 4),
                    CircleAvatar(radius: 4, backgroundColor: acuteRisk),
                    const SizedBox(width: 8),
                    const Text('CHRONIC', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                    const SizedBox(width: 4),
                    CircleAvatar(radius: 4, backgroundColor: chronicRisk),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '$name, ${age}Y, $gender',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('Report Date: $date', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.reportDetail, arguments: id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      foregroundColor: AppColors.primary,
                      minimumSize: const Size(0, 44),
                    ),
                    child: const Text('View Details'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 44),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: const Text('Edit Notes', style: TextStyle(color: AppColors.textPrimary)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
