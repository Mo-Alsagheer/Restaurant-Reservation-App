import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPssword;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  const CustomTextField({
    super.key,
    required this.label,
    required this.icon,
    this.isPssword = false,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.always,
      obscureText: isPssword,
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Your $label',
        prefixIcon: Icon(icon),
        hintStyle: TextStyle(color: Color(0xffA4A5B0)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffF83B01)),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffEEEDF0)),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
