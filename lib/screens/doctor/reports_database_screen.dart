import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/app_router.dart';
import '../../widgets/input_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportsDatabaseScreen extends StatefulWidget {
  const ReportsDatabaseScreen({super.key});

  @override
  State<ReportsDatabaseScreen> createState() => _ReportsDatabaseScreenState();
}

class _ReportsDatabaseScreenState extends State<ReportsDatabaseScreen> {
  String _selectedFilter = 'All';
  String _searchQuery = '';

  final List<String> _filters = [
    'All',
    'Risk: High',
    'Risk: Moderate',
    'Recent',
    'Pending',
  ];

  final List<Map<String, dynamic>> _allReports = [
    {
      'id': 'ID-100',
      'name': 'John Doe',
      'age': 54,
      'gender': 'Male',
      'date': 'Oct 24, 2023',
      'status': 'PENDING VERIFICATION',
      'acuteRisk': Colors.red,
      'chronicRisk': Colors.orange,
    },
    {
      'id': 'ID-101',
      'name': 'Sarah Jenkins',
      'age': 62,
      'gender': 'Female',
      'date': 'Oct 24, 2023',
      'status': 'VERIFIED',
      'acuteRisk': Colors.orange,
      'chronicRisk': Colors.green,
    },
    {
      'id': 'ID-102',
      'name': 'Michael Smith',
      'age': 45,
      'gender': 'Male',
      'date': 'Oct 25, 2023',
      'status': 'PENDING VERIFICATION',
      'acuteRisk': Colors.red,
      'chronicRisk': Colors.red,
    },
    {
      'id': 'ID-103',
      'name': 'Emily Davis',
      'age': 38,
      'gender': 'Female',
      'date': 'Oct 26, 2023',
      'status': 'VERIFIED',
      'acuteRisk': Colors.green,
      'chronicRisk': Colors.green,
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchPatientsFromFirestore();
  }

  Future<void> _fetchPatientsFromFirestore() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'patient')
          .get();

      final List<Map<String, dynamic>> firestoreReports = snapshot.docs.map((
        doc,
      ) {
        final data = doc.data();
        final profile = data['profile'] as Map<String, dynamic>?;

        final name = data['fullName'] ?? 'Unknown Patient';
        final age = profile != null ? profile['age'] ?? 0 : 0;
        final gender = profile != null
            ? profile['gender'] ?? 'Unknown'
            : 'Unknown';

        return {
          'id': doc.id.length > 6
              ? doc.id.substring(0, 6).toUpperCase()
              : doc.id,
          'name': name,
          'age': age,
          'gender': gender,
          'date': 'Today',
          'status': 'PENDING VERIFICATION',
          'acuteRisk': Colors.orange,
          'chronicRisk': Colors.orange,
        };
      }).toList();

      if (mounted) {
        setState(() {
          _allReports.addAll(firestoreReports);
        });
      }
    } catch (e) {
      debugPrint('Error fetching patients: $e');
    }
  }

  List<Map<String, dynamic>> get _filteredReports {
    return _allReports.where((report) {
      final matchesSearch =
          report['name'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          report['id'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );

      if (!matchesSearch) return false;

      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Risk: High') {
        return report['acuteRisk'] == Colors.red ||
            report['chronicRisk'] == Colors.red;
      }
      if (_selectedFilter == 'Risk: Moderate') {
        return report['acuteRisk'] == Colors.orange ||
            report['chronicRisk'] == Colors.orange;
      }
      if (_selectedFilter == 'Pending') {
        return report['status'] == 'PENDING VERIFICATION';
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Patient Reports Database')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppPadding.p16),
            child: Column(
              children: [
                CustomInputField(
                  labelText: '',
                  hintText: 'Search by name or ID...',
                  prefixIcon: const Icon(Icons.search),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
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
                          onSelected: (val) =>
                              setState(() => _selectedFilter = filter),
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
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
              itemCount: _filteredReports.length,
              itemBuilder: (context, index) {
                final report = _filteredReports[index];
                return _buildReportCard(
                  id: report['id'],
                  name: report['name'],
                  age: report['age'],
                  gender: report['gender'],
                  date: report['date'],
                  status: report['status'],
                  acuteRisk: report['acuteRisk'],
                  chronicRisk: report['chronicRisk'],
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
                    const Text(
                      'ACUTE',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    CircleAvatar(radius: 4, backgroundColor: acuteRisk),
                    const SizedBox(width: 8),
                    const Text(
                      'CHRONIC',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
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
            Text(
              'Report Date: $date',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.reportDetail,
                      arguments: id,
                    ),
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
                    child: const Text(
                      'Edit Notes',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
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
