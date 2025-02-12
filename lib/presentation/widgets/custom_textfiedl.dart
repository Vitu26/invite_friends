import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final bool isPassword;
  final TextInputType keyboardType;
  final bool showToggleVisibility;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hint,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.showToggleVisibility = false,
    this.inputFormatters,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword && _isObscured,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(
        hintText: widget.hint,
        filled: true,
        fillColor: Colors.white,
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        suffixIcon: widget.isPassword && widget.showToggleVisibility
            ? IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              )
            : null,
      ),
    );
  }
}
