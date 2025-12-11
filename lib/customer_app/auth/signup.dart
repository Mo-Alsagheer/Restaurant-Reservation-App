import 'package:restaurant_reservation_app/customer_app/custom-widgets/button.dart';
import 'package:restaurant_reservation_app/customer_app/custom-widgets/text_field.dart';
import 'package:restaurant_reservation_app/customer_app/custom-widgets/title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  GlobalKey<FormState> registerState = GlobalKey();

  // Show message
  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // Firebase Register function
  Future<void> registerUser() async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      // Save username in Firestore (optional)
      await FirebaseFirestore.instance
          .collection("users")
          .doc(credential.user!.uid)
          .set({
            "username": usernameController.text.trim(),
            "email": emailController.text.trim(),
            "createdAt": DateTime.now(),
          });

      _showMessage("Account created successfully!");

      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showMessage("Password is too weak.");
      } else if (e.code == 'email-already-in-use') {
        _showMessage("This email is already used.");
      }
    } catch (e) {
      _showMessage("Something went wrong.");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: registerState,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomTitle(title: 'Sign Up'),
                  const SizedBox(height: 24),

                  // Username
                  CustomTextField(
                    label: 'User Name',
                    icon: Icons.person,
                    controller: usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Username is required";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Email
                  CustomTextField(
                    label: 'Email',
                    icon: Icons.email,
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
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  // Confirm Password
                  CustomTextField(
                    isPssword: true,
                    label: 'Confirm Password',
                    icon: Icons.lock_outline,
                    controller: confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm your password';
                      }
                      if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Sign Up Button
                  CustomButton(
                    buttonName: 'Sign Up',
                    formKey: registerState,
                    onPressed: registerUser,
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: GoogleFonts.lato(fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: const Text(
                          "Sign In",
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
      ),
    );
  }
}
