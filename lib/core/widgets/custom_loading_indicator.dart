import 'package:flutter/material.dart';
import '../constants/colors.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final double strokeWidth;

  const CustomLoadingIndicator({
    Key? key,
    this.size = 24.0,
    this.color,
    this.strokeWidth = 2.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: color ?? AppColors.primary,
        strokeWidth: strokeWidth,
      ),
    );
  }
}
