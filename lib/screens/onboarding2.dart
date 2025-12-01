import 'package:flutter/material.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            // Skip Button
            Positioned(
              right: screenWidth * 0.083, // 30/360
              top: screenHeight * 0.081, // 65/800
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: Color(0xFFA0A7B0),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              ),
            ),

            // Title Text
            Positioned(
              left: screenWidth * 0.083, // 30/360
              bottom: screenHeight * 0.175, // 140/800
              right: screenWidth * 0.083, // 30/360
              child: const Text(
                'Get advice only from a doctor you believe in.',
                style: TextStyle(
                  color: Color(0xFF221F1F),
                  fontSize: 22,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                ),
              ),
            ),

            // Next Button
            Positioned(
              right: screenWidth * 0.083, // 30/360
              bottom: screenHeight * 0.238, // 190/800
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/onboarding3');
                },
                child: Container(
                  width: screenWidth * 0.156, // 56/360
                  height: screenWidth * 0.156, // 56/360
                  decoration: const ShapeDecoration(
                    color: Color(0xFF407CE2),
                    shape: CircleBorder(),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 70,
                        offset: Offset(0, 4),
                        spreadRadius: -13,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: screenWidth * 0.067, // 24/360
                    ),
                  ),
                ),
              ),
            ),

            // Progress Indicator
            Positioned(
              left: screenWidth * 0.083, // 30/360
              bottom: screenHeight * 0.1, // 80/800
              child: Row(
                children: [
                  Container(
                    width: screenWidth * 0.037, // 13.17/360
                    height: screenHeight * 0.005, // 4/800
                    decoration: BoxDecoration(
                      color: const Color(0xFF407CE2).withAlpha(77),
                      borderRadius: BorderRadius.circular(56),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.008), // 3/360
                  Container(
                    width: screenWidth * 0.037, // 13.17/360
                    height: screenHeight * 0.005, // 4/800
                    decoration: BoxDecoration(
                      color: const Color(0xFF407CE2),
                      borderRadius: BorderRadius.circular(56),
                    ),
                  ),
                ],
              ),
            ),

            // Status Bar
            Positioned(
              top: screenHeight * 0.015, // 12/800
              left: screenWidth * 0.069, // 25/360
              right: screenWidth * 0.069, // 25/360
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '9:40',
                    style: TextStyle(
                      color: Color(0xFF221E1E),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: screenWidth * 0.048, // 17.18/360
                        height: screenHeight * 0.014, // 11/800
                        decoration: BoxDecoration(
                          border: Border.all(
                            // ignore: deprecated_member_use
                            color: const Color(0xFF221F1F).withAlpha(89),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(2.67),
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: screenWidth * 0.039, // 14.06/360
                            height: screenHeight * 0.009, // 7.12/800
                            margin: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: const Color(0xFF221F1F),
                              borderRadius: BorderRadius.circular(1.33),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
