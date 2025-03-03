import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts package

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFormField extends StatefulWidget {
  final String? labelText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool isPassword; // New property for password fields
  final double borderRadius;
  final Color? borderColor;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    Key? key,
    this.labelText,
    this.controller,
    this.keyboardType,
    this.isPassword = false, // Default to false
    this.borderRadius = 12.0,
    this.borderColor = Colors.grey,
    this.validator,
  }) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true; // Controls password visibility

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword; // Initialize based on isPassword value
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(color: widget.borderColor ?? Colors.grey),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword ? _obscureText : false,
          style: GoogleFonts.montserrat(fontSize: 14.0),
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: GoogleFonts.montserrat(fontSize: 14.0),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null, // Show visibility icon only if it's a password field
          ),
          validator: widget.validator,
        ),
      ),
    );
  }
}

