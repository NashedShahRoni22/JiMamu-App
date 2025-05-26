import 'package:flutter/material.dart';
import '../feature/view/auth/otp_screen.dart';
import '../feature/view/account/view/screens/update_user_profile_screen.dart';
import '../feature/view/home/view/home_screen.dart';
import '../feature/view/home/view/screens/delivery_requests/view/delivery_requests_screen.dart';
import '../feature/view/home/view/screens/my_orders/view/my_orders.dart';
import '../feature/view/home/view/screens/place_order/view/place_order_screen.dart';

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
    case MyOrders.id:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const MyOrders(),
      );

    // case UpdateProfileScreenAccountsTab.id:
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (_) => const UpdateProfileScreenAccountsTab(),
    //   );
    case DeliveryRequestsScreen.id:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const DeliveryRequestsScreen(),
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
