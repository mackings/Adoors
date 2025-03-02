import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts package

class CustomTextFormField extends StatelessWidget {
  final String? labelText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final double borderRadius;
  final Color? borderColor;
  final String? Function(String?)? validator; // Add validator parameter

  const CustomTextFormField({
    Key? key,
    this.labelText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.borderRadius = 12.0,
    this.borderColor = Colors.grey,
    this.validator, // Accept validator
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor ?? Colors.grey),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: GoogleFonts.montserrat(fontSize: 14.0),
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: GoogleFonts.montserrat(fontSize: 14.0),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
          ),
          validator: validator, // Use the validator
        ),
      ),
    );
  }
}
