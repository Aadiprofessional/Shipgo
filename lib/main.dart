import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:shipgo/screens/MapScreen.dart';
import 'package:shipgo/screens/LoginScreen.dart';
import 'package:shipgo/screens/SignupScreen.dart';
import 'package:shipgo/components/cartContext.dart';
import 'package:shipgo/screens/homeScreen.dart';
import 'package:shipgo/screens/SplashScreen.dart';
import 'package:shipgo/screens/searchScreen.dart';
import 'package:shipgo/screens/cartScreen.dart';
import 'package:shipgo/screens/profileScreen.dart';
import 'package:shipgo/components/LeftNavBar.dart'; // Import the LeftNavBar component

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shipgo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthWrapper(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
      },
      debugShowCheckedModeBanner: false, // Remove the debug banner
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return MainScreen(user: snapshot.data!); // Pass the current user
          } else {
            return LoginScreen();
          }
        }
        return SplashScreen(); // Show a splash screen while checking auth status
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({super.key, required this.user});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool isNavBarVisible = false;
  late String userId;
  String? userProfileImage;
  String _address = 'Address'; // Address text in the header

  final List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    userId = widget.user.uid; // Initialize userId from the Firebase user

    // Listen to Firestore changes
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .listen((doc) {
      if (doc.exists) {
        setState(() {
          userProfileImage = doc.data()?['profileImage'];
        });
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void toggleNavBar() {
    setState(() {
      isNavBarVisible = !isNavBarVisible;
    });
  }

  void _updateAddress(String newAddress) {
    setState(() {
      _address = newAddress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _screens[_selectedIndex],
          if (isNavBarVisible)
            GestureDetector(
              onTap: toggleNavBar,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: LeftNavBar(
                        userId: userId,
                        onClose: toggleNavBar,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF25424D),
        title: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapScreen(
                    userId: userId,
                    onAddressSaved: _updateAddress,
                  ),
                ),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Deliver to ',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),

                      // Space between text and icon
                        Icon(
                          Icons
                              .keyboard_arrow_down, // Built-in chevron-down icon
                          color: Colors.white,
                        ),
                      ],
                    ),
                    Text(
                      _address,
                      style: const TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 205, 243, 105),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          userProfileImage != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(userProfileImage!),
                  radius: 25,
                )
              : Image.asset('images/profile.png', width: 60, height: 60),
          const SizedBox(width: 16.0),
        ],
        leading: IconButton(
          icon: Image.asset('images/nav.png', width: 30, height: 30),
          onPressed: toggleNavBar,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF25424D),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
