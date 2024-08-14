// ignore: file_names
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this for URL handling

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  void _handleWhatsApp() {
    const phoneNumber = '9289881135';
    _launchUrl('https://wa.me/$phoneNumber');
  }

  void _handleCall() {
    const phoneNumber = '9289881135';
    _launchUrl('tel:$phoneNumber');
  }

  void _handleMail() {
    const email = 'support@example.com';
    _launchUrl('mailto:$email');
  }

  Future<void> _launchUrl(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        foregroundColor: const Color.fromARGB(255, 252, 252, 252),
        backgroundColor: const Color(0xFF25424D),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          _buildContactOption(
            context,
            'WhatsApp',
            'Click to chat with our staff',
            'images/whatsapp.png',
            _handleWhatsApp,
          ),
          _buildContactOption(
            context,
            'Call',
            'Click to call our staff',
            'images/call.png',
            _handleCall,
          ),
          _buildContactOption(
            context,
            'Mail',
            'Click to email our staff',
            'images/mail.png',
            _handleMail,
          ),
        ],
      ),
    );
  }

  Widget _buildContactOption(
    BuildContext context,
    String title,
    String subtitle,
    String assetPath,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.black.withOpacity(0.2)),
      ),
      leading: Image.asset(assetPath, width: 40, height: 40),
      title: Text(
        title,
        style: const TextStyle(color: Color(0xFF25424D), fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.black)),
      onTap: onTap,
    );
  }
}
