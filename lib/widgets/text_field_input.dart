import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;

  const CustomTextField(
      {Key? key,
      required this.textEditingController,
      this.isPass = false,
      required this.hintText,
      required this.textInputType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return TextField(

      style: TextStyle(
        color: Colors.white
      ),
      cursorColor: Colors.white54,
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 13,
          color: Colors.white54
        ),
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        fillColor: Colors.white10,
        filled: true,
        contentPadding: EdgeInsets.all(8),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
