import 'package:flutter/material.dart';
import 'package:mythings/my_constants/my_constants.dart';

class LoginSignUpTextFormField extends StatelessWidget {
  final validator;
  final controller;
  final labelText;
  final inputFormatters;
  final TextInputType? keyboardType;
  final String? initialValue;
  final IconData? prefixIcon;
  final bool obscureText;

  const LoginSignUpTextFormField({
    Key? key,
    this.validator,
    this.controller,
    this.labelText,
    this.inputFormatters,
    this.keyboardType,
    this.initialValue,
    this.prefixIcon,
    required this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      controller: controller,
      cursorColor: kAppGreen,
      style: TextStyle(fontSize: 15),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: labelText,
        contentPadding: EdgeInsets.fromLTRB(5, 11, 5, 11),
        isDense: true,
        labelStyle: TextStyle(color: Colors.black54),
        border: OutlineInputBorder(borderSide: BorderSide(width: 0.5)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: Colors.black38,
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kAppGreen),
        ),
      ),
      inputFormatters: inputFormatters,
    );
  }
}
