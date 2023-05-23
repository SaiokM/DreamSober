import 'package:flutter/material.dart';

class PswTextField extends StatefulWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const PswTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  }) : super(key: key);

  @override
  _PswTextFieldState createState() => _PswTextFieldState();
}

class _PswTextFieldState extends State<PswTextField> {
  bool _passwordVisible = false;

  void _showPassword() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscureText && !_passwordVisible,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.brown),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: _showPassword,
          ),
        ),
      ),
    );
  }
}
