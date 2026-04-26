import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../models/user_model.dart';
import '../../providers/app_provider.dart';

import '../patient/patient_dashboard.dart';
import '../patient/stats_screen.dart';
import '../patient/profile_screen.dart';

import '../doctor/doctor_dashboard.dart';
import '../doctor/reports_database_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final userRole = context.watch<AppProvider>().userRole;
    final isDoctor = userRole == UserRole.doctor;

    final List<Widget> patientScreens = const [
      PatientDashboard(),
      StatsScreen(),
      ProfileScreen(),
    ];

    final List<Widget> doctorScreens = const [
      DoctorDashboard(),
      ReportsDatabaseScreen(),
      Scaffold(body: Center(child: Text('Patients List Screen'))),
    ];

    final currentScreens = isDoctor ? doctorScreens : patientScreens;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex < currentScreens.length ? _currentIndex : 0,
        children: currentScreens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex < currentScreens.length ? _currentIndex : 0,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: isDoctor
            ? const [
                BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.description_outlined), label: 'Reports'),
                BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Patients'),
              ]
            : const [
                BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Stats'),
                BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
              ],
      ),
    );
  }
}
