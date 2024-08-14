import 'package:flutter/material.dart';

import '../../components/Categories.dart';

import '../../styles/colors.dart';

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
         
           
            Categories(),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Only For App Deals',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
            ),
           
           
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              child: Text(
                "India's best delivery app ❤️",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack.withOpacity(0.1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
