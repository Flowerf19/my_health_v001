import 'package:flutter/material.dart';
import '../constants/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final Function(String)? onChanged;
  final Widget? suffixIcon;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.validator,
    required this.prefixIcon,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.onChanged,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon, color: const Color(0x66221F1F)),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(width: 1, color: Color(0x19221F1F)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(width: 1, color: Color(0x19221F1F)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(width: 1, color: Color(0x19221F1F)),
        ),
        filled: true,
        fillColor: const Color(0xFFF9F9FB),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
        labelStyle: const TextStyle(
          color: Color(0x66221F1F),
          fontSize: 14,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          height: 1.50,
        ),
        errorStyle: const TextStyle(
          color: AppColors.error,
          fontSize: 12,
          fontFamily: 'Poppins',
        ),
      ),
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      enabled: enabled,
      onChanged: onChanged,
      style: const TextStyle(
        color: Color(0xFF221F1F),
        fontSize: 14,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        height: 1.50,
      ),
    );
  }
}
