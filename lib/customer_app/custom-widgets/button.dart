import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String buttonName;
  final VoidCallback onPressed;
  final GlobalKey<FormState> formKey;

  const CustomButton({
    super.key,
    required this.buttonName,
    required this.onPressed,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffF83B01),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            onPressed(); // run loginUser()
          } else {
            print("NOT VALID ❌");
          }
        },
        child: Text(
          buttonName,
          style: GoogleFonts.lato(
            textStyle: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
