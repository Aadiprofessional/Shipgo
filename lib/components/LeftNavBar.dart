import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shipgo/screens/ContactUsScreen.dart';
import 'package:shipgo/screens/DeliveryAddressScreen.dart';
import 'package:shipgo/screens/HelpFaqScreen.dart';
import 'package:shipgo/screens/MyOrdersScreen.dart';
import 'package:shipgo/screens/profileScreen.dart';

class LeftNavBar extends StatelessWidget {
  final String userId;
  final VoidCallback onClose;

  LeftNavBar({
    required this.userId,
    required this.onClose,
  });

  Future<Map<String, dynamic>> _fetchUserData() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
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
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    if (userData['email'] != null)
                      Text(
                        userData['email'],
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    _buildNavItem(
                      Icons.list,
                      'My Orders',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OrdersScreen()),
                        );
                      },
                    ),
                    _buildNavItem(
                      Icons.person,
                      'My Profile',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfileScreen()),
                        );
                      },
                    ),
                    _buildNavItem(
                      Icons.location_on,
                      'Delivery Address',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DeliveryAddressScreen()),
                        );
                      },
                    ),
                    _buildNavItem(
                      Icons.contact_mail,
                      'Contact Us',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ContactUsScreen()),
                        );
                      },
                    ),
                    _buildNavItem(
                      Icons.help,
                      'Help & FAQs',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HelpScreen()),
                        );
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF25424D),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      width: 135,
                      child: Center(
                        child: ListTile(
                          leading: Image.asset(
                              'images/logout.png',
                              width: 24, height: 24),
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

  Widget _buildNavItem(IconData icon, String text, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
    );
  }
}
