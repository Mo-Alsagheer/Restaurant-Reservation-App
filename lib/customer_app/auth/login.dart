import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_reservation_app/customer_app/custom-widgets/button.dart';
import 'package:restaurant_reservation_app/customer_app/custom-widgets/text_field.dart';
import 'package:restaurant_reservation_app/customer_app/custom-widgets/title.dart';


class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> loginState = GlobalKey();

  // Show SnackBar message
  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // Firebase Login Function
  void loginUser() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Success login
      print("LOGIN SUCCESS ✔️");
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showMessage('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        _showMessage('Wrong password provided.');
      } else {
        _showMessage('Login failed. Try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: loginState,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTitle(title: 'Login'),
                const SizedBox(height: 24),

                // Email
                CustomTextField(
                  label: 'Email',
                  icon: Icons.person,
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    if (!value.contains('@')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Password
                CustomTextField(
                  isPssword: true,
                  label: 'Password',
                  icon: Icons.lock,
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Login Button
                CustomButton(
                  buttonName: 'Login',
                  formKey: loginState,
                  onPressed: loginUser,
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: GoogleFonts.lato(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Color(0xffF83B01),
                          fontSize: 18,
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
