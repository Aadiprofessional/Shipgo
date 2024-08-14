// ignore: file_names
import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & FAQs'),
        backgroundColor: const Color(0xFF25424D),
        foregroundColor: const Color.fromARGB(255, 252, 252, 252),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('How to Use the App'),
              onTap: () {
                // Navigate to How to Use section or show information
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Contact Support'),
              onTap: () {
                // Navigate to Contact Us screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.report_problem),
              title: const Text('Report a Problem'),
              onTap: () {
                // Navigate to Report Problem section or show a form
              },
            ),
            // Add more items as needed
          ],
        ),
      ),
    );
  }
}
