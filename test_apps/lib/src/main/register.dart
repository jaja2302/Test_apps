import '../../utils/background_container.dart'; // Import the background container
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart'; // Import the LoginPage for navigation
import '../user/profile.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isButtonEnabled = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  String? _emailError;
  String? _usernameError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_updateButtonState);
    usernameController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
    confirmPasswordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    emailController.removeListener(_updateButtonState);
    usernameController.removeListener(_updateButtonState);
    passwordController.removeListener(_updateButtonState);
    confirmPasswordController.removeListener(_updateButtonState);
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = emailController.text.isNotEmpty &&
          usernameController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty &&
          _emailError == null &&
          _usernameError == null &&
          _passwordError == null &&
          _confirmPasswordError == null;
    });
  }

  bool _validateInputs() {
    bool isValid = true;

    // Validate email
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(emailController.text)) {
      setState(() {
        _emailError = 'Enter a valid email address';
        isValid = false;
      });
    } else {
      setState(() {
        _emailError = null;
      });
    }

    // Validate username
    if (usernameController.text.length > 10) {
      setState(() {
        _usernameError = 'Username must be 4 characters or less';
        isValid = false;
      });
    } else {
      setState(() {
        _usernameError = null;
      });
    }

    // Validate password
    if (!RegExp(r'^(?=.*[A-Z]).{8,}$').hasMatch(passwordController.text)) {
      setState(() {
        _passwordError =
            'Password must have at least 8 characters and 1 uppercase letter';
        isValid = false;
      });
    } else {
      setState(() {
        _passwordError = null;
      });
    }

    // Validate confirm password
    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        _confirmPasswordError = 'Passwords do not match';
        isValid = false;
      });
    } else {
      setState(() {
        _confirmPasswordError = null;
      });
    }

    return isValid;
  }

  Future<void> register() async {
    if (!_validateInputs()) {
      return;
    }

    final url = Uri.parse('https://techtest.youapp.ai/api/register');

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

      if (response.statusCode == 201) {
        json.decode(response.body);

        await _showDialog(
          'Registration Successful',
          'Your account has been created successfully!',
          true,
        );

        // Since the response doesn't provide a token, we'll navigate to the login page instead
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else if (response.statusCode == 301 || response.statusCode == 302) {
        // Handle redirect manually
        final redirectUrl = response.headers['location'];
        if (redirectUrl != null) {
          final redirectResponse = await http.post(
            Uri.parse(redirectUrl),
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'email': emailController.text,
              'username': usernameController.text,
              'password': passwordController.text,
            }),
          );

          print('Redirect response status: ${redirectResponse.statusCode}');
          print('Redirect response body: ${redirectResponse.body}');

          // Process the redirect response here
          // ... (similar to the original response handling)
        } else {
          await _showDialog(
            'Registration Failed',
            'Error: Unable to process redirect',
            false,
          );
        }
      } else {
        await _showDialog(
          'Registration Failed',
          'Error: ${response.body}',
          false,
        );
      }
    } catch (e) {
      print('Exception occurred: $e');
      await _showDialog(
        'Registration Failed',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: Column(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                alignment: Alignment.centerLeft,
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(emailController, 'Enter Email',
                        errorText: _emailError),
                    const SizedBox(height: 20),
                    _buildTextField(usernameController, 'Create Username',
                        errorText: _usernameError),
                    const SizedBox(height: 20),
                    _buildTextField(
                      passwordController,
                      'Create Password',
                      isPassword: true,
                      showPassword: _showPassword,
                      onTogglePassword: () =>
                          setState(() => _showPassword = !_showPassword),
                      errorText: _passwordError,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      confirmPasswordController,
                      'Confirm Password',
                      isPassword: true,
                      showPassword: _showConfirmPassword,
                      onTogglePassword: () => setState(
                          () => _showConfirmPassword = !_showConfirmPassword),
                      errorText: _confirmPasswordError,
                    ),
                    const SizedBox(height: 20),
                    _buildRegisterButton(),
                    const SizedBox(height: 20),
                    _buildLoginLink(),
                  ],
                ),
              ),
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
    bool showPassword = false,
    VoidCallback? onTogglePassword,
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !showPassword,
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
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white70,
                ),
                onPressed: onTogglePassword,
              )
            : null,
        errorText: errorText,
        errorStyle: const TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _buildRegisterButton() {
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
        onPressed: _isButtonEnabled ? register : null,
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
          child: const Text('Register'),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
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
              const TextSpan(text: 'Have an account? '),
              TextSpan(
                text: 'Login Here',
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
