import 'dart:async';
import 'package:flutter/material.dart';

class AutoImageSlider2 extends StatefulWidget {
  @override
  _AutoImageSliderState2 createState() => _AutoImageSliderState2();
}

class _AutoImageSliderState2 extends State<AutoImageSlider2> {
  final List<String> images = [
    'images/banner3.png',
    'images/banner3.png',
    'images/banner3.png',
  ];

  final PageController _pageController = PageController(
    viewportFraction: 0.8,
  );
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.jumpToPage(_currentIndex);
    });

    Timer.periodic(Duration(seconds: 7), (Timer timer) {
      if (_pageController.hasClients) {
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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: PageView.builder(
        controller: _pageController,
        itemCount: images.length + 2,
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
            margin: EdgeInsets.symmetric(horizontal: 10),
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

  @override
  void dispose() {
    _pageController.dispose(); // Dispose of the controller when the widget is removed
    super.dispose();
  }
}
