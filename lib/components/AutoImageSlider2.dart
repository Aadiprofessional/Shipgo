import 'dart:async';
import 'package:flutter/material.dart';

class AutoImageSlider2 extends StatefulWidget {
  @override
  _AutoImageSliderState createState() => _AutoImageSliderState();
}

class _AutoImageSliderState extends State<AutoImageSlider2> {
  final List<String> images = [
    'images/banner3.png',
    'images/banner3.png',
    'images/banner3.png',
  ];

  final PageController _pageController = PageController(
    viewportFraction: 0.8, // Adjust this value to make images smaller
  );
  int _currentIndex = 1; // Start at 1 to ensure proper wrapping

  @override
  void initState() {
    super.initState();
    // Initialize the PageView to the first image
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.jumpToPage(_currentIndex);
    });

    Timer.periodic(Duration(seconds: 7), (Timer timer) {
      _currentIndex++;
      if (_currentIndex >= images.length + 1) {
        _currentIndex = 1;
        _pageController.jumpToPage(_currentIndex);
      } else {
        _pageController.animateToPage(
          _currentIndex,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      // color: Color(0xFF25424D), // Removed background color
      child: PageView.builder(
        controller: _pageController,
        itemCount: images.length + 2, // Add two for looping effect
        itemBuilder: (context, index) {
          int imageIndex = index;
          if (index == 0) {
            imageIndex = images.length - 1;
          } else if (index == images.length + 1) {
            imageIndex = 0;
          } else {
            imageIndex = index - 1;
          }
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10), // Margin to show parts of neighboring images
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(images[imageIndex]),
                fit: BoxFit.fitWidth,
              ),
            ),
          );
        },
        onPageChanged: (index) {
          setState(() {
            if (index == 0) {
              _currentIndex = images.length;
            } else if (index == images.length + 1) {
              _currentIndex = 1;
            } else {
              _currentIndex = index;
            }
          });
        },
      ),
    );
  }
}
