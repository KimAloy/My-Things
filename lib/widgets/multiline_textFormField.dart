import 'package:flutter/material.dart';
import 'package:mythings/my_constants/my_constants.dart';

class MultiLineTextField extends StatelessWidget {
  final Function? onChanged;
  final TextEditingController? controller;
  final String hintText;
  final double? height;
  final keyboardType;
  final int? maxLines;
  final fontWeight;
  final validator;

  const MultiLineTextField({
    Key? key,
    required this.hintText,
    required this.height,
    this.onChanged,
    this.keyboardType,
    this.maxLines,
    this.fontWeight,
    this.controller,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        onChanged: onChanged as void Function(String)?,
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: TextStyle(
            fontSize: 16, color: Colors.black87, fontWeight: fontWeight),
        cursorColor: kAppGreen,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white, fontSize: 13.5),
          border: OutlineInputBorder(borderSide: BorderSide(width: 0.5)),
          contentPadding: EdgeInsets.fromLTRB(5, 11, 5, 11),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              width: 0.5,
              color: Colors.black38,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: kAppGreen,
            ),
          ),
        ),
        validator: validator as String? Function(String?)?,
      ),
    );
  }
}
