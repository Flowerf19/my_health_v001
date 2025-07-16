import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_error_widget.dart';
import '../providers/auth_provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  ForgotPasswordScreen({super.key});

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
                    'Forgot Password',
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
                  const Text(
                    'Enter your email to receive a password reset link',
                    style: TextStyle(
                      color: Color(0xFF221F1F),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                  const SizedBox(height: 30),
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
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 39),
                  if (authProvider.errorMessage != null)
                    CustomErrorWidget(
                      message: authProvider.errorMessage!,
                      onRetry: null,
                    ),
                  CustomButton(
                    text: 'Send Request',
                    onPressed:
                        () => _handleResetPassword(authProvider, context),
                    isLoading: authProvider.isLoading,
                  ),
                  const SizedBox(height: 25),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Back to Sign In',
                      style: TextStyle(
                        color: Color(0xFF407CE2),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 1.50,
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

  void _handleResetPassword(AuthProvider authProvider, BuildContext context) {
    if (_formKey.currentState!.validate()) {
      authProvider.resetPassword(_emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset link has been sent to your email'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }
}
