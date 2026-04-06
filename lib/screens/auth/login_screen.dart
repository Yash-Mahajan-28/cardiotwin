import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/app_router.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/input_field.dart';
import '../../services/api_service.dart';
import '../../providers/app_provider.dart';

class LoginScreen extends StatefulWidget {
  final String role; // 'patient' or 'doctor'

  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final user = await ApiService().login(
          _emailController.text,
          _passwordController.text,
        );
        if (mounted) {
          context.read<AppProvider>().setUser(user);
          if (user.role.name == 'doctor') {
            Navigator.pushReplacementNamed(context, AppRoutes.doctorDashboard);
          } else {
            Navigator.pushReplacementNamed(context, AppRoutes.patientDashboard);
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login failed. Please try again.')),
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
              Text(
                'Welcome Back',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Log in to your ${widget.role} account',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 40),
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
                labelText: 'Password',
                hintText: 'Enter your password',
                isPassword: true,
                controller: _passwordController,
                validator: (value) =>
                    value != null && value.length >= 6 ? null : 'Min 6 characters',
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Forgot Password?'),
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Login',
                isLoading: _isLoading,
                onPressed: _login,
              ),
              const SizedBox(height: 32),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OR', style: TextStyle(color: AppColors.textSecondary)),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 32),
              CustomOutlineButton(
                text: 'Continue with Google',
                onPressed: () {},
                color: Colors.grey.shade700,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      if (widget.role == 'patient') {
                        Navigator.pushNamed(context, AppRoutes.patientRegister);
                      } else {
                        Navigator.pushNamed(context, AppRoutes.doctorRegister);
                      }
                    },
                    child: const Text('Create Account'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
