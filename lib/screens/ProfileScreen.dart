import 'dart:io'; // Import this for File
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart'; // Import for basename

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String phoneNumber = '';
  String userName = 'Your Name';
  String? profileImage;
  final int rewardPoints = 100;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();
      if (data != null) {
        setState(() {
          phoneNumber = data['phone'] ?? '';
          userName = data['name'] ?? 'Your Name';
          profileImage = data['profileImage'] ?? '';
        });
      }
    }
  }

  Future<void> _uploadImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileName = basename(pickedFile.path);
      final storageRef = FirebaseStorage.instance.ref().child('profile_images/$fileName');
      await storageRef.putFile(file);
      final newImageUrl = await storageRef.getDownloadURL();
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final uid = user.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).update({'profileImage': newImageUrl});
        setState(() {
          profileImage = newImageUrl;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = [
     
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _uploadImage,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: profileImage != null
                          ? NetworkImage(profileImage!)
                          : AssetImage('images/profile.png') as ImageProvider,
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Mobile: ${phoneNumber != 'N/A' ? '+91 $phoneNumber' : 'N/A'}',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Reward Points: $rewardPoints',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 15),
                  Image.asset('images/profile2.png', width: 80, height: 80),
                ],
              ),
            ),
            SizedBox(height: 20),
            ...options.map((option) {
              return ListTile(
                leading: Icon(Icons.ac_unit), // Replace with actual icon if available
                title: Text(option['text']!),
                onTap: () {
                  Navigator.pushNamed(context, option['screen']!);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
