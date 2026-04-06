import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/input_field.dart';

class DoctorRegisterScreen extends StatefulWidget {
  const DoctorRegisterScreen({super.key});

  @override
  State<DoctorRegisterScreen> createState() => _DoctorRegisterScreenState();
}

class _DoctorRegisterScreenState extends State<DoctorRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedState;

  final List<String> _states = [
    'California',
    'New York',
    'Texas',
    'Florida',
    'Illinois'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Doctor Registration'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppPadding.p24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomInputField(
                labelText: 'Full Name',
                hintText: 'Dr. Enter your full name',
              ),
              const SizedBox(height: 20),
              const CustomInputField(
                labelText: 'Age',
                hintText: 'Enter your age',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              const CustomInputField(
                labelText: 'Email Address',
                hintText: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              const CustomInputField(
                labelText: 'Medical Registration Number',
                hintText: 'Enter your registration number',
              ),
              const SizedBox(height: 20),
              CustomDropdownField<String>(
                labelText: 'State',
                value: _selectedState,
                items: _states.map((state) {
                  return DropdownMenuItem(
                    value: state,
                    child: Text(state),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedState = value),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Create Account',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushReplacementNamed(context, '/doctor-dashboard');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
