import 'package:flutter/material.dart';
import 'package:jimamu/auth/otp_screen.dart';
import 'package:jimamu/auth/update_profile_screen.dart';
import 'package:jimamu/home/view/home_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case OtpScreen.id:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const OtpScreen(),
      );
    case UpdateProfileScreen.id:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const UpdateProfileScreen(),
      );
    case HomeScreen.id:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist..'),
          ),
        ),
      );
  }
}
