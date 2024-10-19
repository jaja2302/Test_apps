import 'package:flutter/material.dart';
import '../../utils/background_container.dart';
import 'about.dart';
import 'interest.dart';

class ProfilePage extends StatefulWidget {
  final String token;

  const ProfilePage({super.key, required this.token});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isAboutExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(context),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildProfileImage(),
                    const SizedBox(height: 20),
                    _buildAboutSection(),
                    const SizedBox(height: 20),
                    InterestSection(token: widget.token),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            '@johndoe123',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Icon(Icons.more_vert, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[800],
            child: const Icon(Icons.person, size: 80, color: Colors.white54),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 20,
              child: IconButton(
                icon: const Icon(Icons.add_a_photo,
                    color: Colors.white, size: 20),
                onPressed: () {
                  // TODO: Implement image upload functionality
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return AboutSection(
      token: widget.token,
      isExpanded: isAboutExpanded,
      onToggle: () {
        setState(() {
          isAboutExpanded = !isAboutExpanded;
        });
      },
    );
  }
}
