import 'package:flutter/material.dart';
import 'package:jimamu/home/view/screens/my_orders/view/my_orders.dart';
import 'package:jimamu/home/view/screens/place_order/view/place_order_screen.dart';

import '../../../global_consts/global_colors.dart';
import '../../../global_consts/global_typography.dart';

class ServicesGrid extends StatelessWidget {
  final List<Map<String, String>> services;

  const ServicesGrid({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 18,
      runSpacing: 18,
      children: services.map((service) {
        return InkWell(
          onTap: () {
            if (service['title']! == 'My Orders') {
              Navigator.pushNamed(context, MyOrders.id);
            } else if (service['title']! == 'Place Order') {
              Navigator.pushNamed(context, PlaceOrderScreen.id);
            }
          },
          child: SizedBox(
            width: (MediaQuery.of(context).size.width - 52) / 2,
            child: Ink(
              decoration: BoxDecoration(
                color: GlobalColors.secondary,
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
                  Image.asset(service['icon']!),
                  Padding(
                    padding: const EdgeInsets.all(11),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            service['title']!,
                            style: GlobalTypography.pMedium,
                          ),
                        ),
                        const Icon(Icons.arrow_forward),
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
