import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jimamu/constant/color_path.dart';
import 'package:jimamu/constant/global_typography.dart';
import 'package:jimamu/feature/view/home/view/screens/my_orders/view/my_orders.dart';

class ChooseOrderTypeScreenMyOrders extends StatefulWidget {
  const ChooseOrderTypeScreenMyOrders({super.key});

  @override
  State<ChooseOrderTypeScreenMyOrders> createState() =>
      _ChooseOrderTypeScreenMyOrdersState();
}

class _ChooseOrderTypeScreenMyOrdersState
    extends State<ChooseOrderTypeScreenMyOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Order Type'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Get.to(() => const MyOrders(orderType: 'national'));
              },
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: ColorPath.secondary,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 4,
                          offset: Offset(0, 4),
                          color: ColorPath.black.withOpacity(0.25))
                    ]),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/home/map2.png',
                      height: 64,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nationwide Delivery',
                          style: GlobalTypography.bodySemiBold,
                        ),
                        Text(
                          'Delivering anywhere across Canada with ease.',
                          style: GlobalTypography.p2Regular,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            InkWell(
              onTap: () {
                Get.to(() => const MyOrders(orderType: 'international'));
              },
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: ColorPath.secondary,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 4,
                          offset: Offset(0, 4),
                          color: ColorPath.black.withOpacity(0.25))
                    ]),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/home/map1.png',
                      height: 64,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Global Delivery',
                          style: GlobalTypography.bodySemiBold,
                        ),
                        Text(
                          'Ship your items anywhere across the world.',
                          style: GlobalTypography.p2Regular,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
