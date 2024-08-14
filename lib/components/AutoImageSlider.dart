import 'dart:async';
import 'package:flutter/material.dart';

class AutoImageSlider extends StatefulWidget {
  @override
  _AutoImageSliderState createState() => _AutoImageSliderState();
}

class _AutoImageSliderState extends State<AutoImageSlider> {
  final List<String> images = [
    'images/banner.png',
    'images/banner.png',
    'images/banner.png',
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
      color: Color(0xFF25424D),
      child: Stack(
        children: [
          PageView.builder(
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
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  width: _currentIndex == index + 1 ? 16 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index + 1
                        ? Color.fromARGB(255, 205, 243, 105)
                        : Color.fromARGB(128, 145, 145, 145),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose of the controller when the widget is removed
    super.dispose();
  }
}
