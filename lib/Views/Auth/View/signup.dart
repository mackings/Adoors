import 'package:adorss/Views/Auth/Api/Signupservice.dart';
import 'package:adorss/Views/Auth/View/signin.dart';
import 'package:adorss/Views/Auth/widgets/colors.dart';
import 'package:adorss/Views/Auth/widgets/custombtn.dart';
import 'package:adorss/Views/Auth/widgets/formfields.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';




class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _signupService = SignupService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isLoading = false;

void _signUp() async {
  if (_formKey.currentState?.validate() ?? false) {
    setState(() {
      _isLoading = true;
    });

    final result = await _signupService.signUpStudent(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      school: _schoolController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    // ✅ Fix: Change from `success` to `status`
    bool isSuccess = result['status'] == "success";
    String message = result['messages'] ?? "Something went wrong";

    // Remove HTML tags from the message (if needed)
    message = message.replaceAll(RegExp(r'<[^>]*>'), '');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );

    if (isSuccess) {

          ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Check your mail for Logins."),
        backgroundColor:  Colors.grey
      ),
    );
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
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
                  "Create an Account",
                  style: GoogleFonts.montserrat(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Get started on Adorss for a seamless learning journey.",
                  style: GoogleFonts.montserrat(),
                ),
                const SizedBox(height: 30),
                CustomTextFormField(
                  labelText: "Full Name",
                  controller: _nameController,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your full name" : null,
                ),
                CustomTextFormField(
                  labelText: "Email",
                  controller: _emailController,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your email" : null,
                ),
                CustomTextFormField(
                  labelText: "Phone",
                  controller: _phoneController,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your phone number" : null,
                ),
                CustomTextFormField(
                  labelText: "School",
                  controller: _schoolController,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your school" : null,
                ),
                const SizedBox(height: 30),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        text: 'Sign Up',
                        onPressed: _signUp,
                        borderRadius: 20.0,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                      ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignIn()),
                        );
                      },
                      child: Text(
                        "Sign in",
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