/// Main risk assessment screen with tabs for different models

import 'package:flutter/material.dart';
import '../models/model_config.dart';
import '../models/cardiac_risk_calculator.dart';
import 'acute_risk_input_screen.dart';
import 'chronic_risk_input_screen.dart';

class RiskAssessmentScreen extends StatefulWidget {
  const RiskAssessmentScreen({Key? key}) : super(key: key);

  @override
  State<RiskAssessmentScreen> createState() => _RiskAssessmentScreenState();
}

class _RiskAssessmentScreenState extends State<RiskAssessmentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CardiacRiskCalculator _calculator = CardiacRiskCalculator();
  bool _isInitialized = false;
  String? _initError;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeModels();
  }

  Future<void> _initializeModels() async {
    try {
      await _calculator.initialize();
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      setState(() {
        _initError = e.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load models: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _calculator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Cardiac Risk Assessment'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_initError != null)
                Column(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'Error Loading Models',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        _initError!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isInitialized = false;
                          _initError = null;
                        });
                        _initializeModels();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'Loading AI Models...',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please wait while we prepare the assessment tools',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cardiac Risk Assessment'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.favorite),
              text: 'Heart Disease',
            ),
            Tab(
              icon: Icon(Icons.favorite_outline),
              text: 'Cardiac Failure',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Acute Risk Assessment Tab
          AcuteRiskInputScreen(calculator: _calculator),

          // Chronic Risk Assessment Tab
          ChronicRiskInputScreen(calculator: _calculator),
        ],
      ),
    );
  }
}

