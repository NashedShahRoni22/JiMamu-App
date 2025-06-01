import 'package:flutter/material.dart';
import '../feature/view/auth/otp_screen.dart';
import '../feature/view/account/view/screens/update_user_profile_screen.dart';
import '../feature/view/home/view/home_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case OtpScreen.id:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OtpScreen(),
      );
    case UpdateUserProfileScreen.id:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const UpdateUserProfileScreen(),
      );
    case HomeScreen.id:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );

    // case UpdateProfileScreenAccountsTab.id:
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (_) => const UpdateProfileScreenAccountsTab(),
    //   );

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
