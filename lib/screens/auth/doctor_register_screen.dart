import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/app_router.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/input_field.dart';
import '../../services/auth_service.dart';

class DoctorRegisterScreen extends StatefulWidget {
  const DoctorRegisterScreen({super.key});

  @override
  State<DoctorRegisterScreen> createState() => _DoctorRegisterScreenState();
}

class _DoctorRegisterScreenState extends State<DoctorRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _regNumberController = TextEditingController();
  final _specializationController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  String? _selectedState;

  final List<String> _states = [
    'California',
    'New York',
    'Texas',
    'Florida',
    'Illinois'
  ];

  void _register() async {
    if (_formKey.currentState!.validate() && _selectedState != null) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }

      setState(() => _isLoading = true);
      try {
        final user = await _authService.registerWithEmail(
          email: _emailController.text,
          password: _passwordController.text,
          fullName: _nameController.text,
          role: 'doctor',
          additionalData: {
            'age': int.tryParse(_ageController.text) ?? 0,
            'medicalRegistrationNumber': _regNumberController.text,
            'specialization': _specializationController.text,
            'state': _selectedState,
            'licenseVerified': false,
          },
        );

        if (user != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful!')),
          );
          Navigator.pushReplacementNamed(context, AppRoutes.doctorDashboard);
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration failed. Please try again.')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

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
              CustomInputField(
                labelText: 'Full Name',
                hintText: 'Dr. Enter your full name',
                controller: _nameController,
                validator: (value) => value == null || value.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 20),
              CustomInputField(
                labelText: 'Age',
                hintText: 'Enter your age',
                controller: _ageController,
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Age is required' : null,
              ),
              const SizedBox(height: 20),
              CustomInputField(
                labelText: 'Email Address',
                hintText: 'Enter your email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value != null && value.contains('@') ? null : 'Enter a valid email',
              ),
              const SizedBox(height: 20),
              CustomInputField(
                labelText: 'Medical Registration Number',
                hintText: 'Enter your registration number',
                controller: _regNumberController,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Registration number is required' : null,
              ),
              const SizedBox(height: 20),
              CustomInputField(
                labelText: 'Specialization',
                hintText: 'e.g., Cardiology, General Practice',
                controller: _specializationController,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Specialization is required' : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'State',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                initialValue: _selectedState,
                items: _states.map((state) {
                  return DropdownMenuItem(
                    value: state,
                    child: Text(state),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedState = value),
                validator: (value) => value == null ? 'State is required' : null,
              ),
              const SizedBox(height: 20),
              CustomInputField(
                labelText: 'Password',
                hintText: 'Create a password',
                isPassword: true,
                controller: _passwordController,
                validator: (value) =>
                    value != null && value.length >= 6 ? null : 'Min 6 characters required',
              ),
              const SizedBox(height: 20),
              CustomInputField(
                labelText: 'Confirm Password',
                hintText: 'Confirm your password',
                isPassword: true,
                controller: _confirmPasswordController,
                validator: (value) =>
                    value != null && value.length >= 6 ? null : 'Min 6 characters required',
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Create Account',
                isLoading: _isLoading,
                onPressed: _register,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _regNumberController.dispose();
    _specializationController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
