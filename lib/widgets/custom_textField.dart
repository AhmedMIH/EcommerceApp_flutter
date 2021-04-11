import 'package:buy_it/constants.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  String initialValue = '';
  final IconData icon;
  final bool obscureText;
  final Function onClick;

  CustomTextField(
      {@required this.hint,
      this.initialValue,
      this.icon,
      this.obscureText = false,
      this.onClick});

  String fieldType() {
    switch (hint) {
      case 'Enter your email':
        return 'email';
      case 'Enter your username':
        return 'username';
      case 'Enter your password':
        return 'password';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        initialValue: initialValue,
        validator: (value) {
          if (value.isEmpty) {
            return 'value is empty';
          }

          return null;
        },
        onSaved: onClick,
        obscureText: obscureText,
        cursorColor: KMainColor,
        decoration: InputDecoration(
          labelText: initialValue == '' ? null : hint,
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: KMainColor,
          ),
          filled: true,
          fillColor: KSecondaryColor,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(20),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
