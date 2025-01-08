import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const PasswordTextField({
    super.key,
    this.controller,
    this.errorText,
    this.onChanged,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
        border: const OutlineInputBorder(),
        errorText: widget.errorText,
      ),
      onChanged: widget.onChanged,
    );
  }
}
