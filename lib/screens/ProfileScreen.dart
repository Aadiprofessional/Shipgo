import 'package:flutter/material.dart';
import 'package:shipgo/styles/colors.dart';


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String phoneNumber = '';
  String userName = 'Your Name';
  String? profileImage;
  final int rewardPoints = 100;

  @override
  void initState() {
    super.initState();

  }

 
  @override
  Widget build(BuildContext context) {
    final options = [
      {'iconName': 'office-building-outline', 'text': 'Manage Companies', 'screen': '/UserCompaniesScreen'},
      {'iconName': 'file-document-outline', 'text': 'Terms and Conditions', 'screen': '/TermsConditionsScreen'},
      {'iconName': 'shield-lock-outline', 'text': 'Privacy and Policy', 'screen': '/PrivacyPolicyScreen'},
      {'iconName': 'email-outline', 'text': 'Contact us', 'screen': '/NeedHelp'},
      {'iconName': 'logout', 'text': 'Log out', 'screen': ''},
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
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: profileImage != null ? NetworkImage(profileImage!) : AssetImage('images/profile.png') as ImageProvider,
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textBlack),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Mobile: ${phoneNumber != 'N/A' ? '+91 $phoneNumber' : 'N/A'}',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textBlack),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Reward Points: $rewardPoints',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textBlack),
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
                
                
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
