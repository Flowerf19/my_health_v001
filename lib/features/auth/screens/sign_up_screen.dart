import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_error_widget.dart';
import '../providers/auth_provider.dart';

class SignupScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 73),
                  const Text(
                    'Sign Up',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF221F1F),
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 62),
                  CustomTextField(
                    controller: _emailController,
                    label: 'Enter your email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'Invalid email format';
                      }
                      return null;
                    },
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 25),
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Enter your password',
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.visibility_outlined),
                      onPressed: () {},
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 25),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm your password',
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.visibility_outlined),
                      onPressed: () {},
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 39),
                  if (authProvider.errorMessage != null)
                    CustomErrorWidget(
                      message: authProvider.errorMessage!,
                      onRetry: null,
                    ),
                  CustomButton(
                    text: 'Sign Up',
                    onPressed: () => _handleSignup(authProvider, context),
                    isLoading: authProvider.isLoading,
                  ),
                  const SizedBox(height: 25),
                  _buildDivider(),
                  const SizedBox(height: 25),
                  CustomButton(
                    text: 'Sign up with Google',
                    onPressed: () => _handleGoogleSignup(authProvider, context),
                    isOutlined: true,
                    isSocialButton: true,
                    icon: Icons.g_mobiledata,
                  ),
                  const SizedBox(height: 15),
                  CustomButton(
                    text: 'Sign up with Facebook',
                    onPressed: () => _handleFacebookSignup(context),
                    isOutlined: true,
                    isSocialButton: true,
                    icon: Icons.facebook,
                  ),
                  const SizedBox(height: 25),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: const TextStyle(
                          color: Color(0xFF221F1F),
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                          letterSpacing: 0.50,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign in',
                            style: const TextStyle(
                              color: Color(0xFF407CE2),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              height: 1.50,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Divider(color: Color(0x19221F1F), thickness: 1),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          color: Colors.white,
          child: const Text(
            'OR',
            style: TextStyle(
              color: Color(0xFFA0A7B0),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ),
      ],
    );
  }

  void _handleSignup(AuthProvider authProvider, BuildContext context) {
    if (_formKey.currentState!.validate()) {
      authProvider.signUpWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }

  Future<void> _handleGoogleSignup(
    AuthProvider authProvider,
    BuildContext context,
  ) async {
    try {
      await authProvider.signInWithGoogle(context);
    } catch (e) {
      _showErrorSnackbar(context, 'Google sign up error: ${e.toString()}');
    }
  }

  void _handleFacebookSignup(BuildContext context) {
    _showErrorSnackbar(context, 'Feature under development');
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }
}
