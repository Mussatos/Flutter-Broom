import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FieldForm extends StatelessWidget {
  String label;
  bool isPassoword;
  TextEditingController controller;

  FieldForm(
    {
    required this.label,
    required this.isPassoword,
    required this.controller,
    super.key
    }
    );

  @override
  Widget build(BuildContext context) {
    return TextFormField( 
      obscureText: isPassoword,
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label
      ),
    );
  }
}
