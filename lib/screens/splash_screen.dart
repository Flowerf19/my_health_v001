import 'package:flutter/material.dart';
import 'onboarding1.dart';
import '../core/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Chuyển hướng sau 3 giây
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png', // Thay bằng đường dẫn hình ảnh logo của bạn
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              'Healthcare',
              style: TextStyle(
                color: Color(0xFF223A6A),
                fontSize: 32,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Medical App',
              style: TextStyle(
                color: Color(0xFF213359),
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
