import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final bool isLoading;
  final IconData? icon;
  final bool isOutlined;
  final bool isSocialButton;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius = 32.0,
    this.isLoading = false,
    this.icon,
    this.isOutlined = false,
    this.isSocialButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 56.0,
      child:
          isOutlined
              ? OutlinedButton(
                onPressed: isLoading ? null : onPressed,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    width: 1,
                    color:
                        isSocialButton
                            ? const Color(0xFF407CE2)
                            : const Color(0xFFE5E7EB),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  backgroundColor: Colors.white,
                ),
                child: _buildButtonContent(),
              )
              : ElevatedButton(
                onPressed: isLoading ? null : onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColor ?? const Color(0xFF407CE2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
                child: _buildButtonContent(),
              ),
    );
  }

  Widget _buildButtonContent() {
    return isLoading
        ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        )
        : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color:
                    isSocialButton
                        ? const Color(0xFF407CE2)
                        : (textColor ?? Colors.white),
                size: 20,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                color:
                    isSocialButton
                        ? const Color(0xFF407CE2)
                        : (textColor ?? Colors.white),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 1.50,
              ),
            ),
          ],
        );
  }
}
