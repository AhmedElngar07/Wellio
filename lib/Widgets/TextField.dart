import 'package:flutter/material.dart';

class CustomerTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;

  const CustomerTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xff452C63),
        ),
        suffixIcon: Icon(icon, color: Colors.grey),

      ),
    );
  }
}
