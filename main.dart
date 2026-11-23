import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'РЕСТОРАН РАБОТАЕТ!',
          style: TextStyle(fontSize: 30, color: Colors.red),
        ),
      ),
    ),
  ));
}