import 'package:flutter/material.dart';

class Onboarding3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            // Thanh trạng thái
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.056, // 45/800
                child: Stack(
                  children: [
                    Positioned(
                      left: screenWidth * 0.069, // 25/360
                      top: screenHeight * 0.015, // 12/800
                      child: Container(
                        width: screenWidth * 0.861, // 310/360
                        height: screenHeight * 0.026, // 21/800
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                width: screenWidth * 0.083, // 30/360
                                height: screenHeight * 0.026, // 21/800
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      child: SizedBox(
                                        width: screenWidth * 0.083, // 30/360
                                        child: Text(
                                          '9:40',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color(0xFF221E1E),
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              right: screenWidth * 0.192, // 69/360
                              top: screenHeight * 0.006, // 5/800
                              child: Opacity(
                                opacity: 0.35,
                                child: Container(
                                  width: screenWidth * 0.048, // 17.18/360
                                  height: screenHeight * 0.014, // 11/800
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 1,
                                        color: const Color(0xFF221F1F),
                                      ),
                                      borderRadius: BorderRadius.circular(2.67),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: screenWidth * 0.187, // 67.44/360
                              top: screenHeight * 0.009, // 6.94/800
                              child: Container(
                                width: screenWidth * 0.039, // 14.06/360
                                height: screenHeight * 0.009, // 7.12/800
                                decoration: ShapeDecoration(
                                  color: const Color(0xFF221F1F),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(1.33),
                                  ),
                                ),
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
            // Tiêu đề chính
            Positioned(
              left: screenWidth * 0.244, // 88/360
              top: screenHeight * 0.39, // 312/800
              child: SizedBox(
                width: screenWidth * 0.511, // 184/360
                child: Text(
                  'Healthcare',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF223A6A),
                    fontSize: 25,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            // Phụ đề
            Positioned(
              left: screenWidth * 0.083, // 30/360
              top: screenHeight * 0.469, // 375/800
              child: SizedBox(
                width: screenWidth * 0.833, // 300/360
                child: Text(
                  'Let\'s get started!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF221F1F),
                    fontSize: 22,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
              ),
            ),
            // Mô tả
            Positioned(
              left: screenWidth * 0.083, // 30/360
              top: screenHeight * 0.509, // 407/800
              child: SizedBox(
                width: screenWidth * 0.833, // 300/360
                child: Text(
                  'Login to Stay healthy and fit',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0x99221F1F),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                    letterSpacing: 0.50,
                  ),
                ),
              ),
            ),
            // Nút "Login"
            Positioned(
              left: screenWidth * 0.153, // 55/360
              top: screenHeight * 0.591, // 473/800
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF407CE2),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.278, // 100/360
                    vertical: screenHeight * 0.019, // 15/800
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            // Nút "Sign Up"
            Positioned(
              left: screenWidth * 0.153, // 55/360
              top: screenHeight * 0.681, // 545/800
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/signup');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.25, // 90/360
                    vertical: screenHeight * 0.019, // 15/800
                  ),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: const Color(0xFF407CE2)),
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: const Color(0xFF407CE2),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
