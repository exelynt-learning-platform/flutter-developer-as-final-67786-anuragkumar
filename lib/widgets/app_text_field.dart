import 'package:flutter/material.dart';

class TextControl extends StatelessWidget {
  final TextEditingController controller;
  final InputDecoration decoration;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;

  final int? maxLength;
  final bool obscureText;

  final ValueChanged<String>? onChanged;

  const TextControl({
    super.key,
    required this.controller,
    required this.decoration,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.maxLength,
    this.obscureText = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLength: maxLength,
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: decoration,
      validator: validator,
      onChanged: onChanged,
    );
  }
}