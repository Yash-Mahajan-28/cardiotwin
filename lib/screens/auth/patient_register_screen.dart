import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/app_router.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/input_field.dart';
import '../../services/auth_service.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../providers/app_provider.dart';

class PatientRegisterScreen extends StatefulWidget {
  const PatientRegisterScreen({super.key});

  @override
  State<PatientRegisterScreen> createState() => _PatientRegisterScreenState();
}

class _PatientRegisterScreenState extends State<PatientRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  void _register() async {
    if (_formKey.currentState!.validate()) {
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
          role: 'patient',
          additionalData: {
            'age': int.tryParse(_ageController.text) ?? 0,
            'address': _addressController.text,
          },
        );

        if (user != null && mounted) {
          final userModel = UserModel(
            id: user.uid,
            name: _nameController.text,
            email: _emailController.text,
            role: UserRole.patient,
          );
          context.read<AppProvider>().setUser(userModel);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful!')),
          );
          Navigator.pushReplacementNamed(context, AppRoutes.patientDashboard);
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
              CustomInputField(
                labelText: 'Full Name',
                hintText: 'Enter your full name',
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
                labelText: 'Address',
                hintText: 'Enter your address',
                controller: _addressController,
                keyboardType: TextInputType.streetAddress,
                validator: (value) => value == null || value.isEmpty ? 'Address is required' : null,
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
                text: 'Create Profile',
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
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
