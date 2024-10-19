import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utils/background_container.dart';

class ProfilePage extends StatefulWidget {
  final String token;

  const ProfilePage({Key? key, required this.token}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController interestsController = TextEditingController();

  Future<void> createProfile() async {
    final url = Uri.parse('http://techtest.youapp.ai/api/createProfile');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-access-token': widget.token,
      },
      body: json.encode({
        'name': nameController.text,
        'birthday': birthdayController.text,
        'height': int.parse(heightController.text),
        'weight': int.parse(weightController.text),
        'interests':
            interestsController.text.split(',').map((e) => e.trim()).toList(),
      }),
    );

    if (response.statusCode == 201) {
      print('Profile created successfully');
      // Navigate to the next page or show a success message
    } else {
      print('Profile creation failed: ${response.body}');
      // Show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    const Text(
                      '@johndoe123',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    _buildProfileSection('About'),
                    const SizedBox(height: 20),
                    _buildProfileSection('Interest'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: createProfile,
                      child: const Text('Save'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Icon(Icons.edit, color: Colors.blue[300], size: 20),
            ],
          ),
          const SizedBox(height: 10),
          if (title == 'About') ...[
            _buildTextField(nameController, 'Add in your name'),
            _buildTextField(birthdayController, 'Add in your birthday'),
            _buildTextField(heightController, 'Add in your height'),
            _buildTextField(weightController, 'Add in your weight'),
          ] else if (title == 'Interest') ...[
            _buildTextField(
                interestsController, 'Add in your interests (comma-separated)'),
          ],
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
