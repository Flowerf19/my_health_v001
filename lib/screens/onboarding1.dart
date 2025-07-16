import 'package:flutter/material.dart';

class Onboarding1 extends StatelessWidget {
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
            // Hình ảnh minh họa
            Positioned(
              left: 0,
              top: screenHeight * 0.125, // 100/800
              child: Image.asset(
                'assets/images/onboarding1.png',
                width: screenWidth,
                height: screenHeight * 0.5, // 400/800
                fit: BoxFit.cover,
              ),
            ),
            // Nút "Skip"
            Positioned(
              right: screenWidth * 0.164, // 59/360
              top: screenHeight * 0.081, // 65/800
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text(
                  'Skip',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFFA0A7B0),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 1.40,
                  ),
                ),
              ),
            ),
            // Tiêu đề
            Positioned(
              left: screenWidth * 0.083, // 30/360
              top: screenHeight * 0.65, // 520/800
              child: SizedBox(
                width: screenWidth * 0.833, // 300/360
                child: Text(
                  'Find a lot of specialist doctors in one place',
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
            // Nút điều hướng tiếp theo
            Positioned(
              right: screenWidth * 0.239, // 86/360
              top: screenHeight * 0.725, // 580/800
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/onboarding2');
                },
                child: Container(
                  width: screenWidth * 0.156, // 56/360
                  height: screenWidth * 0.156, // 56/360
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: screenWidth * 0.156, // 56/360
                          height: screenWidth * 0.156, // 56/360
                          decoration: ShapeDecoration(
                            color: const Color(0xFF407CE2),
                            shape: OvalBorder(),
                            shadows: [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 70,
                                offset: Offset(0, 4),
                                spreadRadius: -13,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.044, // 16/360
                        top: screenWidth * 0.044, // 16/360
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: screenWidth * 0.067, // 24/360
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Thanh tiến trình
            Positioned(
              left: screenWidth * 0.083, // 30/360
              top: screenHeight * 0.775, // 620/800
              child: Container(
                width: screenWidth * 0.081, // 29/360
                height: screenHeight * 0.005, // 4/800
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: screenWidth * 0.037, // 13.17/360
                        height: screenHeight * 0.005, // 4/800
                        decoration: ShapeDecoration(
                          color: const Color(0xFF407CE2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(56),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: screenWidth * 0.044, // 15.83/360
                      top: 0,
                      child: Opacity(
                        opacity: 0.30,
                        child: Container(
                          width: screenWidth * 0.037, // 13.17/360
                          height: screenHeight * 0.005, // 4/800
                          decoration: ShapeDecoration(
                            color: const Color(0xFF407CE2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(56),
                            ),
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
    );
  }
}
