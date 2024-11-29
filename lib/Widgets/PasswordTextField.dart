import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  const PasswordTextField({
    required this.controller,
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _isObscured,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xff452C63),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isObscured ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured;
            });
          },
        ),

      ),
    );
  }
}
