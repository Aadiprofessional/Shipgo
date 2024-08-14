import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'Loading...',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
    );
  }
}
