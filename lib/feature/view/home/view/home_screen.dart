import 'package:flutter/material.dart';
import 'package:jimamu/constant/color_path.dart';
import 'package:jimamu/feature/view/home/view/widgets/banner_indicator.dart';
import 'package:jimamu/feature/view/home/view/widgets/banner_slider.dart';
import 'package:jimamu/feature/view/home/view/widgets/search_bar.dart';
import 'package:jimamu/feature/view/home/view/widgets/service_grid.dart';
import 'package:jimamu/feature/view/home/view/widgets/user_info_header.dart';

import '../../../../constant/global_typography.dart';
import '../../account/view/account_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'HomeScreen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;
  int _currentBannerIndex = 0;

  final List<String> _bannerImages = [
    'assets/home/banner.png',
    'assets/home/banner.png',
    'assets/home/banner.png',
  ];

  final List<Map<String, String>> _services = [
    {
      'icon': 'assets/home/service_icon1.png',
      'title': 'Delivery Requests',
    },
    {
      'icon': 'assets/home/service_icon2.png',
      'title': 'Place Order',
    },
    {
      'icon': 'assets/home/service_icon3.png',
      'title': 'My Deliveries',
    },
    {
      'icon': 'assets/home/service_icon4.png',
      'title': 'My Orders',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: ColorPath.flushMahogany,
        backgroundColor:  Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.surface
            : Colors.grey.shade100,
        elevation: 0,
        currentIndex: _selectedTabIndex,
        onTap: (index) => setState(() => _selectedTabIndex = index),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt), label: 'Activity'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Account'),
        ],
      ),
      body: SafeArea(
        child: _selectedTabIndex == 0
            ? SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const UserInfoHeader(),
                    const SizedBox(height: 16),
                    const CustomSearchBar(),
                    const SizedBox(height: 24),
                    BannerSlider(
                      bannerImages: _bannerImages,
                      currentIndex: _currentBannerIndex,
                      onPageChanged: (index) => setState(() {
                        _currentBannerIndex = index;
                      }),
                      height: screenHeight * 0.2,
                    ),
                    const SizedBox(height: 12),
                    BannerIndicator(
                      itemCount: _bannerImages.length,
                      currentIndex: _currentBannerIndex,
                    ),
                    const SizedBox(height: 24),
                    Text('Services', style: GlobalTypography.h1Medium),
                    const SizedBox(height: 24),
                    ServicesGrid(services: _services),
                    const SizedBox(height: 30),
                  ],
                ),
              )
            : _selectedTabIndex == 2
                ? const ProfileOverviewScreen()
                : const Center(
                    child: Text('Build on process..'),
                  ),
      ),
    );
  }
}
