import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HeroSlider extends StatelessWidget {
  HeroSlider({super.key});

  final List<String> images = [
    'assets/images/slide1.jpg',
    'assets/images/slide2.jpg',
    'assets/images/slide3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: double.infinity,
        viewportFraction: 1,
        autoPlay: true,
      ),
      items: images.map((image) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
            ),
          ),
        );
      }).toList(),
    );
  }
}
