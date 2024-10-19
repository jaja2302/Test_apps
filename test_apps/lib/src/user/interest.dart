import 'package:flutter/material.dart';

class InterestSection extends StatelessWidget {
  final String token;

  const InterestSection({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
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
              const Text(
                'Interest',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                onPressed: () {
                  // TODO: Implement edit functionality for Interest
                },
              ),
            ],
          ),
          Text(
            'Add in your interest to find a better match',
            style: TextStyle(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}
