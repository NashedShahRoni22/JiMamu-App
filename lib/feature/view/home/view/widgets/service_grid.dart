import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jimamu/feature/controller/user_controller.dart';
import 'package:jimamu/feature/view/account/view/screens/update_rider_profile_screen.dart';
import 'package:jimamu/feature/view/home/view/screens/my_deliveries/view/my_deliveries.dart';
import 'package:jimamu/feature/view/home/view/screens/place_order/view/choose_order_type_screen.dart';

import '../../../../../constant/color_path.dart';
import '../../../../../constant/global_typography.dart';
import '../screens/delivery_requests/view/delivery_requests_screen.dart';
import '../screens/my_orders/view/my_orders.dart';
import '../screens/place_order/view/place_order_screen.dart';

class ServicesGrid extends StatefulWidget {
  final List<Map<String, String>> services;

  const ServicesGrid({super.key, required this.services});

  @override
  State<ServicesGrid> createState() => _ServicesGridState();
}

class _ServicesGridState extends State<ServicesGrid> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 18,
      runSpacing: 18,
      children: widget.services.map((service) {
        return InkWell(
          onTap: () {
            if (service['title']! == 'My Orders') {
              Get.to(const MyOrders());
            } else if (service['title']! == 'Place Order') {
              Get.to(const ChooseOrderTypeScreen());
            } else if (service['title']! == 'Delivery Requests') {
              final UserController userController = Get.put(UserController());
              final roles = userController.riderProfile.data?.role ?? [];

              if (!roles.contains('rider')) {
                // Wait for frame to finish building
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Get.to(UpdateRiderProfileAccount());

                  // Optionally show a snackbar or dialog briefly
                  Get.snackbar(
                    "Access Denied",
                    "You must complete your rider profile to access delivery requests.",
                    backgroundColor: Colors.red.shade100,
                    colorText: Colors.red.shade900,
                    duration: const Duration(seconds: 3),
                  );
                });
                return;
              }
              Get.to(const DeliveryRequestsScreen());
            } else if (service['title']! == 'My Deliveries') {
              final UserController userController = Get.put(UserController());
              final roles = userController.riderProfile.data?.role ?? [];

              if (!roles.contains('rider')) {
                // Wait for frame to finish building
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Get.to(UpdateRiderProfileAccount());

                  // Optionally show a snackbar or dialog briefly
                  Get.snackbar(
                    "Access Denied",
                    "You must complete your rider profile to access delivery requests.",
                    backgroundColor: Colors.red.shade100,
                    colorText: Colors.red.shade900,
                    duration: const Duration(seconds: 3),
                  );
                });
                return;
              }
              Get.to(const MyDeliveries());
            }
          },
          child: SizedBox(
            width: (MediaQuery.of(context).size.width - 52) / 2,
            child: Ink(
              decoration: BoxDecoration(
                color: ColorPath.secondary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    service['icon']!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(11),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            service['title']!,
                            style: GlobalTypography.pMedium.copyWith(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? ColorPath.black
                                  : ColorPath
                                      .black, // or any other color for light mode
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? ColorPath.black
                              : ColorPath.black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
