import 'package:flutter/material.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const EmailTextField({
    super.key,
    this.controller,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email',
        prefixIcon: const Icon(Icons.email),
        border: const OutlineInputBorder(),
        errorText: errorText,
      ),
      onChanged: onChanged,
    );
  }
}
