import 'package:flutter/material.dart';
import './src/main/login.dart'; // Import the login page
// Import the register page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(), // Set the LoginPage as the home
    );
  }
}
