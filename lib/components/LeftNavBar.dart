import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Add this for toast messages
import 'package:shipgo/screens/LoginScreen.dart'; // Correctly import LoginScreen

class LeftNavBar extends StatelessWidget {
  final String userId;
  final VoidCallback onClose; // Add this parameter

  LeftNavBar({
    required this.userId,
    required this.onClose,
  }); // Update constructor

  Future<Map<String, dynamic>> _fetchUserData() async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return doc.data() ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 250,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          FutureBuilder<Map<String, dynamic>>(
            future: _fetchUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error loading data'));
              }
              final userData = snapshot.data;
              if (userData == null || userData.isEmpty) {
                return Center(child: Text('No user data available'));
              }
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (userData['profileImage'] != null)
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(userData['profileImage']),
                      ),
                    SizedBox(height: 10),
                    if (userData['name'] != null)
                      Text(
                        userData['name'],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    if (userData['email'] != null)
                      Text(
                        userData['email'],
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    _buildNavItem(Icons.list, 'My Orders'),
                    _buildNavItem(Icons.person, 'My Profile'),
                    _buildNavItem(Icons.location_on, 'Delivery Address'),
                    _buildNavItem(Icons.contact_mail, 'Contact Us'),
                    _buildNavItem(Icons.help, 'Help & FAQs'),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF25424D),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      width: 135, // Reduced width
                      child: Center(
                        child: ListTile(
                          leading: Image.asset('images/logout.png',
                              width: 24, height: 24), // Use your image path
                          title: Text('Logout',
                              style: TextStyle(color: Colors.white)),
                          onTap: () async {
                            try {
                              await FirebaseAuth.instance.signOut();
                              Fluttertoast.showToast(
                                msg: "Logged out successfully",
                                toastLength: Toast.LENGTH_SHORT,
                              );
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/login', (route) => false);
                            } catch (e) {
                              Fluttertoast.showToast(
                                msg: "Error logging out",
                                toastLength: Toast.LENGTH_SHORT,
                              );
                            }
                          },
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String text,
      {VoidCallback? onLogoutTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onLogoutTap ?? () {},
      contentPadding:
          EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0), // Reduced gap
    );
  }
}
