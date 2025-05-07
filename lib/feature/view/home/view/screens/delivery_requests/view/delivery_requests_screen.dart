import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jimamu/feature/view/home/view/screens/delivery_requests/view/widgets/request_card.dart';
import 'package:jimamu/feature/view/home/view/screens/my_orders/view/screens/order_details/order_details_screen.dart';
import '../../../../../../../service/order_service.dart';

class DeliveryRequestsScreen extends StatefulWidget {
  static const String id = 'DeliveryRequestsScreen';
  const DeliveryRequestsScreen({super.key});

  @override
  State<DeliveryRequestsScreen> createState() => _DeliveryRequestsScreenState();
}

class _DeliveryRequestsScreenState extends State<DeliveryRequestsScreen> {
  int type = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Requests'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 1, // replace with your actual list
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      RequestCard(
                        orderId: '#8T9G88P',
                        date: '14 May 2023',
                        from: '1234 Elm Street Springfield, IL 62701',
                        to: '5678 Maple Avenue Seattle, WA 98101',
                        bid: 180,
                        onPressed: () async {
                          final details =
                              await OrderService.fetchOrderDetails('123456');
                          if (details != null) {
                            Get.to(() =>
                                OrderDetailsScreen(orderDetails: details));
                          } else {
                            Get.snackbar(
                                "Error", "Failed to load order details");
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
