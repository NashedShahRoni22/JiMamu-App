import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class BannerSlider extends StatelessWidget {
  final List<String> bannerImages;
  final int currentIndex;
  final Function(int) onPageChanged;
  final double height;

  const BannerSlider({
    super.key,
    required this.bannerImages,
    required this.currentIndex,
    required this.onPageChanged,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: bannerImages.length,
      itemBuilder: (context, index, realIndex) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Image.asset(bannerImages[index], fit: BoxFit.cover),
        );
      },
      options: CarouselOptions(
        height: height,
        autoPlay: true,
        viewportFraction: 1.0,
        onPageChanged: (index, reason) => onPageChanged(index),
      ),
    );
  }
}
