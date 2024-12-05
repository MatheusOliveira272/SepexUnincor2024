import 'package:flutter/material.dart';

InputDecoration getAuthenticationInputDecoration(String label, {Icon? icon}){
  return InputDecoration(
    hintText: label,
    fillColor: Colors.white,
    filled: true,
    icon: icon,
    contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8), 
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(64)
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(64),
      borderSide: const BorderSide(color: Colors.black, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(64),
      borderSide: const BorderSide(color: Colors.blue, width: 4),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(64),
      borderSide: const BorderSide(color: Colors.red, width: 2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(64),
      borderSide: const BorderSide(color: Colors.red, width: 4),
    ),
  );
}