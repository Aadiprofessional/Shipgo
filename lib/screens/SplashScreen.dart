import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Navigate to the next screen after a delay
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 4), () {
        Navigator.pushReplacementNamed(context, '/login');
      });
    });

    return Scaffold(
      backgroundColor: Color(0xFFFCCC51), // Use a color from your color palette
      body: Center(
        child: Image.asset('images/logo.png', width: MediaQuery.of(context).size.width * 0.6),
      ),
    );
  }
}
