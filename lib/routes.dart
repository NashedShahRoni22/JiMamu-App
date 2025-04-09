import 'package:flutter/material.dart';
import 'package:jimamu/auth/otp_screen.dart';
import 'package:jimamu/auth/update_profile_screen.dart';
import 'package:jimamu/home/view/home_screen.dart';
import 'package:jimamu/home/view/screens/my_orders/view/my_orders.dart';
import 'package:jimamu/home/view/screens/my_orders/view/screens/order_details/view/order_details_screen.dart';
import 'package:jimamu/home/view/screens/place_order/view/place_order_screen.dart';

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
    case MyOrders.id:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const MyOrders(),
      );
    case OrderDetailsScreen.id:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const OrderDetailsScreen(),
      );
    case PlaceOrderScreen.id:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const PlaceOrderScreen(),
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
