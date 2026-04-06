import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/input_field.dart';

class PatientRegisterScreen extends StatefulWidget {
  const PatientRegisterScreen({super.key});

  @override
  State<PatientRegisterScreen> createState() => _PatientRegisterScreenState();
}

class _PatientRegisterScreenState extends State<PatientRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Patient Registration'),
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
                hintText: 'Enter your full name',
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
                labelText: 'Address',
                hintText: 'Enter your address',
                keyboardType: TextInputType.streetAddress,
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Create Profile',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushReplacementNamed(context, '/patient-dashboard');
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
