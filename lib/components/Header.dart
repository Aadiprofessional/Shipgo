import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;
  final Widget? trailing;

  Header({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF25424D), // Header background color
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 10,
            child: Container(
              width: 30.0,
              height: 30.0,
              child: GestureDetector(
                onTap: () {
                  // Handle left icon tap if needed
                },
                child: Image.asset('images/nav.png'),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Deliver to ',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 205, 243, 105)),
                ),
              ],
            ),
          ),
          if (trailing != null)
            Positioned(
              right: 0,
              top: 0,
              child: trailing!,
            ),
        ],
      ),
    );
  }
}
