import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'register.dart'; // Import the RegisterPage for navigation
import '../user/profile.dart';
import '../../utils/background_container.dart'; // Import the background container

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_updateButtonState);
    usernameController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    emailController.removeListener(_updateButtonState);
    usernameController.removeListener(_updateButtonState);
    passwordController.removeListener(_updateButtonState);
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = emailController.text.isNotEmpty &&
          usernameController.text.isNotEmpty &&
          passwordController.text.isNotEmpty;
    });
  }

  Future<void> login() async {
    final url = Uri.parse('https://techtest.youapp.ai/api/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': emailController.text,
          'username': usernameController.text,
          'password': passwordController.text,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];

        await _showDialog(
          'Login Successful',
          'You have been logged in successfully!',
          true,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage(token: token)),
        );
      } else {
        await _showDialog(
          'Login Failed',
          'Error: ${response.body}',
          false,
        );
      }
    } catch (e) {
      print('Exception occurred: $e');
      await _showDialog(
        'Login Failed',
        'Error: Unable to connect to the server. Please try again later.',
        false,
      );
    }
  }

  Future<void> _showDialog(String title, String message, bool isSuccess) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          backgroundColor: Colors.grey[900],
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
          contentTextStyle: const TextStyle(color: Colors.white70),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        );
      },
    );
  }

  void _bypassLogin() {
    // Generate a dummy token for testing
    const dummyToken = 'dummy_token_for_testing';

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const ProfilePage(token: dummyToken)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              const SizedBox(height: 40),
              const Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildTextField(emailController, 'Enter Email'),
              const SizedBox(height: 20),
              _buildTextField(usernameController, 'Enter Username'),
              const SizedBox(height: 20),
              _buildTextField(passwordController, 'Enter Password',
                  isPassword: true),
              const SizedBox(height: 20),
              _buildLoginButton(),
              const SizedBox(height: 20),
              _buildBypassButton(),
              const SizedBox(height: 20),
              _buildRegisterLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hintText, {
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.black12,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }

  Widget _buildLoginButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-0.9, 0),
          end: Alignment(0.9, 0),
          colors: [
            Color(0xFF62CDCB),
            Color(0xFF4599DB),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: _isButtonEnabled
            ? [
                BoxShadow(
                  color: const Color(0xFF62CDCB).withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: const Color(0xFF4599DB).withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: ElevatedButton(
        onPressed: _isButtonEnabled ? login : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          minimumSize: const Size(331, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            color: _isButtonEnabled ? Colors.white : Colors.white60,
            fontSize: _isButtonEnabled ? 18 : 16,
            fontWeight: FontWeight.bold,
          ),
          child: const Text('Login'),
        ),
      ),
    );
  }

  Widget _buildBypassButton() {
    return ElevatedButton(
      onPressed: _bypassLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'Bypass Login (For Testing)',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterPage()),
          );
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(color: Colors.white30, width: 1),
          ),
        ),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            children: [
              const TextSpan(text: 'No account? '),
              TextSpan(
                text: 'Register Here',
                style: TextStyle(
                  color: Colors.amber[600],
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
