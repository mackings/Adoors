import 'dart:convert';

import 'package:adorss/Views/Auth/Api/signinservice.dart';
import 'package:adorss/Views/Auth/model/signinres.dart';
import 'package:adorss/Views/Auth/widgets/colors.dart';
import 'package:adorss/Views/Auth/widgets/custombtn.dart';
import 'package:adorss/Views/Auth/widgets/formfields.dart';
import 'package:adorss/Views/Dashboard/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';



class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _signInService = SignInService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  void _signIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final result = await _signInService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      setState(() {
        _isLoading = false;
      });

      if (result['success'] == true) {
        final responseModel = SignInResponse.fromJson(result);

        // Save the serialized model to shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userData', jsonEncode(responseModel.toJson()));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sign-in successful!")),
        );

        // Example: Accessing specific fields
        print("User Token: ${responseModel.token}");
         print("User: ${responseModel}");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${result['message']}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 90),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sign In",
                  style: GoogleFonts.montserrat(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Access your Adorss account for a seamless learning journey.",
                  style: GoogleFonts.montserrat(),
                ),
                const SizedBox(height: 30),
                CustomTextFormField(
                  labelText: "Email",
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
                        .hasMatch(value)) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),
                CustomTextFormField(
                  labelText: "Password",
                  controller: _passwordController,
                  isPassword: true,
                  //obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : CustomButton(
                        text: 'Sign In',
                        onPressed: _signIn,
                        borderRadius: 20.0,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                      ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Forgotten password?",
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        // Add navigation to reset page if required
                      },
                      child: Text(
                        "Reset",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
