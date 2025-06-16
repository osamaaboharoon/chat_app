import 'package:flutter/material.dart';

class CustomFormTextField extends StatefulWidget {
  final String hintText;
  final Function(String) onChanged;
  final bool isPassword;

  const CustomFormTextField({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.isPassword = false,
  });

  @override
  State<CustomFormTextField> createState() => _CustomFormTextFieldState();
}

class _CustomFormTextFieldState extends State<CustomFormTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.isPassword ? _obscureText : false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required.';
        }
        return null;
      },
      onChanged: widget.onChanged,
      style: const TextStyle(
        color: Colors.black87,
      ), // ← لون النص داخل الـ input
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.black45), // ← لون الـ hint
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey[700],
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
