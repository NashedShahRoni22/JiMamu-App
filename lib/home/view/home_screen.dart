import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:jimamu/global_consts/global_colors.dart';
import 'package:jimamu/global_consts/global_typography.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'HomeScreen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<String> _bannerImages = [
    'assets/home/banner.png',
    'assets/home/banner.png',
    'assets/home/banner.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt), label: 'Activity'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Account'),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(radius: 24),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nashed Shah',
                              style: GlobalTypography.sub1Medium),
                          Text('Mohammadpur, Dhaka',
                              style: GlobalTypography.pMedium),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_outlined),
                  )
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Search Parcel',
                      style: GlobalTypography.sub1Medium
                          .copyWith(color: GlobalColors.balck700)),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Your parcel code..',
                      hintStyle: GlobalTypography.pRegular,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      fillColor: GlobalColors.balck50,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CarouselSlider(
              options: CarouselOptions(
                height: 160.0,
                autoPlay: true,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              items: _bannerImages.map((imagePath) {
                return Builder(
                  builder: (BuildContext context) {
                    return Image.asset(imagePath, fit: BoxFit.cover);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _bannerImages.map((imagePath) {
                int index = _bannerImages.indexOf(imagePath);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? GlobalColors.balck700
                        : GlobalColors.balck500,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Text('Services', style: GlobalTypography.h1Medium),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 26, vertical: 12),
                    decoration: BoxDecoration(
                      color: GlobalColors.secondary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(0, 2))
                      ],
                    ),
                    child: Column(
                      children: [
                        Image.asset('assets/home/service_icon1.png'),
                        const SizedBox(height: 8),
                        Text('Delivery\nRequests',
                            style: GlobalTypography.pMedium,
                            textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
