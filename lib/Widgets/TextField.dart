import 'package:flutter/material.dart';

class CustomerTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool obscureText;

  const CustomerTextField({
    required this.label,
    required this.icon,
    this.obscureText = false,
  }) ;


  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        suffixIcon: Icon(icon, color: Colors.grey),
        label: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff452C63),
          ),
        ),
      ),
    );
  }
}
