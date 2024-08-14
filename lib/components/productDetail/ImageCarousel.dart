import 'package:flutter/material.dart';

class ImageCarousel extends StatelessWidget {
  final List<String> images;
  final int imageIndex;
  final bool loading;
  final int colorDeliveryTime;
  final Function onPrevious;
  final Function onNext;

  ImageCarousel({
    required this.images,
    required this.imageIndex,
    required this.loading,
    required this.colorDeliveryTime,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Color(0xFFB3B3B3)),
      ),
      margin: EdgeInsets.only(bottom: 20),
      child: Stack(
        children: [
          if (images.isNotEmpty)
            Image.network(
              images[imageIndex],
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.contain,
            ),
          if (loading)
            Center(
              child: CircularProgressIndicator(
                color: Color(0xFF007AFF),
              ),
            ),
          Positioned(
            left: 10,
            top: MediaQuery.of(context).size.height * 0.4,
            child: GestureDetector(
              onTap: () => onPrevious(),
              child: CircleAvatar(
                backgroundColor: Color(0xFF007AFF),
                child: Text(
                  '<',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: MediaQuery.of(context).size.height * 0.4,
            child: GestureDetector(
              onTap: () => onNext(),
              child: CircleAvatar(
                backgroundColor: Color(0xFF007AFF),
                child: Text(
                  '>',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (index) {
                return Container(
                  width: index == imageIndex ? 16 : 8,
                  height: 8,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: index == imageIndex
                        ? Color(0xFF316487)
                        : Color(0xFFA7A7A7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
          Positioned(
            top: 15,
            left: 50,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$colorDeliveryTime Days',
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: CircleAvatar(
              backgroundColor: Color(0xFFB3B3B3),
              child: Image.asset(
                'assets/truck.png',
                width: 24,
                height: 24,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
