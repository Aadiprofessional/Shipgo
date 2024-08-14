import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:shipgo/components/autoImageSlider.dart';

import '../components/Categories.dart';
import '../components/LeftNavBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isNavBarVisible = false;
  String? userName;
  String? userEmail;
  String? userProfileImage;
  late String userId;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      userId = user.uid;

      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(userId);
      final userSnapshot = await userDoc.get();

      if (userSnapshot.exists) {
        setState(() {
          userName = userSnapshot.data()?['name'];
          userEmail = userSnapshot.data()?['email'];
          userProfileImage = userSnapshot.data()?['profileImage'];
        });
      }
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  void toggleNavBar() {
    setState(() {
      isNavBarVisible = !isNavBarVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // White background for the whole screen
        child: Stack(
          children: [
            // Main Content
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoImageSlider(),
                  Categories(),
                 
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Center(
                      child: Image.asset('images/banner2.png',
                          width: 370, height: 200, fit: BoxFit.contain),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 10.0),
                    child: Text(
                      "India's best delivery app ❤️",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // LeftNavBar
            if (isNavBarVisible)
              GestureDetector(
                onTap: () {
                  toggleNavBar();
                },
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: LeftNavBar(
                          userId: userId,
                          onClose:
                              toggleNavBar, // Update to match the constructor
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
