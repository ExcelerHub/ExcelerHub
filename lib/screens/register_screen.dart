import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/app_logo.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;

      final success = await AuthService.instance.register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful! Please login.'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An account with this email already exists.'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(child: AppLogo(size: 56, showTagline: true)),
                const SizedBox(height: 28),
                CustomTextField(
                  labelText: 'Full Name',
                  hintText: 'John Doe',
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Full name is required';
                    }
                    if (value.trim().length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  labelText: 'Email',
                  hintText: 'name@example.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    final emailRegExp =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegExp.hasMatch(value.trim())) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  labelText: 'Password',
                  hintText: 'Minimum 6 characters',
                  controller: _passwordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  labelText: 'Confirm Password',
                  hintText: 'Re-enter your password',
                  controller: _confirmPasswordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                CustomButton(
                  text: 'Register',
                  isLoading: _isLoading,
                  onPressed: _handleRegister,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Login'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  AppConstants.appDescription,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
