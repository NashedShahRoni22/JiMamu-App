import 'package:flutter/material.dart';
import '../feature/view/account/view/screens/update_rider_profile_screen.dart';
import '../feature/view/auth/otp_screen.dart';
import '../feature/view/auth/update_profile_screen.dart';
import '../feature/view/home/view/home_screen.dart';
import '../feature/view/home/view/screens/delivery_requests/view/delivery_requests_screen.dart';
import '../feature/view/home/view/screens/my_orders/view/my_orders.dart';
import '../feature/view/home/view/screens/my_orders/view/screens/order_details/view/order_details_screen.dart';
import '../feature/view/home/view/screens/place_order/view/place_order_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case OtpScreen.id:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) =>  OtpScreen(),
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
