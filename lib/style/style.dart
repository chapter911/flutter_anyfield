import 'package:flutter/material.dart';

class Style {
  String hint = "";
  Icon? icon;
  InputDecoration dekorasiInput({hint, icon}) {
    return InputDecoration(
      hintText: hint,
      label: Text(hint),
      prefixIcon: icon,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.black12,
          width: .5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.black12,
          width: .5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.black12,
          width: .5,
        ),
      ),
    );
  }
}
