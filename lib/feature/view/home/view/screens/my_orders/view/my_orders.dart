import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jimamu/constant/color_path.dart';
import 'package:jimamu/feature/view/home/view/screens/my_orders/view/screens/order_details/order_details_screen.dart';
import 'package:jimamu/feature/view/home/view/screens/my_orders/view/widgets/order_card.dart';
import 'package:jimamu/feature/view/home/service/order_service.dart';

import '../../../../../../../constant/global_typography.dart';
import '../../../../model/my_order.dart';

class MyOrders extends StatefulWidget {
  static const String id = 'MyOrders';
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  int type = 0;

  List<MyOrder> myOngoingOrders = [];
  List<MyOrder> myCompletedOrders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final ongoing = OrderService.fetchMyOngoingOrders();
      final completed = OrderService.fetchMyCompletedOrders();

      final results = await Future.wait([ongoing, completed]);

      setState(() {
        myOngoingOrders = results[0];
        myCompletedOrders = results[1];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Get.snackbar("Error", "Failed to load orders");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                color: ColorPath.flushMahogany,
              ))
            : Column(
                children: [
                  _buildTabBar(),
                  const SizedBox(height: 24),
                  type == 0
                      ? myOngoingOrders.isEmpty
                          ? Column(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                ),
                                const Center(
                                    child: Text('No ongoing orders to show')),
                              ],
                            )
                          : Expanded(
                              child: isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : ListView.builder(
                                      itemCount: myOngoingOrders.length,
                                      itemBuilder: (context, index) {
                                        final order = myOngoingOrders[index];
                                        return Column(
                                          children: [
                                            OrderCard(
                                                orderId: order.orderId,
                                                date:
                                                    '7 May 2025', // Add if available
                                                from:
                                                    'Lat: ${double.parse(order.pickupLatitude).toStringAsFixed(5)}, Long: ${double.parse(order.pickupLongitude).toStringAsFixed(5)}',
                                                to:
                                                    'Lat: ${double.parse(order.dropLatitude).toStringAsFixed(5)}, Long: ${double.parse(order.dropLongitude).toStringAsFixed(5)}',
                                                status: order.status
                                                    .replaceFirst(
                                                        order.status[0],
                                                        order.status[0]
                                                            .toUpperCase()),
                                                onPressed: () async {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  final details =
                                                      await OrderService
                                                          .fetchOrderDetails(
                                                              order.orderId);
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                  if (details != null) {
                                                    Get.to(() =>
                                                        OrderDetailsScreen(
                                                            orderDetails:
                                                                details));
                                                  } else {
                                                    Get.snackbar("Error",
                                                        "Failed to load order details");
                                                  }
                                                }),
                                            const SizedBox(height: 12),
                                          ],
                                        );
                                      },
                                    ),
                            )
                      : myCompletedOrders.isEmpty
                          ? Column(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                ),
                                const Center(
                                    child: Text('No completed orders to show')),
                              ],
                            )
                          : Expanded(
                              child: isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : ListView.builder(
                                      itemCount: myCompletedOrders.length,
                                      itemBuilder: (context, index) {
                                        final order = myCompletedOrders[index];
                                        return Column(
                                          children: [
                                            OrderCard(
                                                orderId: order.orderId,
                                                date:
                                                    '7 May 2025', // Add if available
                                                from:
                                                    'Lat: ${double.parse(order.pickupLatitude).toStringAsFixed(5)}, Long: ${double.parse(order.pickupLongitude).toStringAsFixed(5)}',
                                                to:
                                                    'Lat: ${double.parse(order.dropLatitude).toStringAsFixed(5)}, Long: ${double.parse(order.dropLongitude).toStringAsFixed(5)}',
                                                status: order.status
                                                    .replaceFirst(
                                                        order.status[0],
                                                        order.status[0]
                                                            .toUpperCase()),
                                                onPressed: () async {
                                                  final details =
                                                      await OrderService
                                                          .fetchOrderDetails(
                                                              order.orderId);
                                                  if (details != null) {
                                                    Get.to(() =>
                                                        OrderDetailsScreen(
                                                            orderDetails:
                                                                details));
                                                  } else {
                                                    Get.snackbar("Error",
                                                        "Failed to load order details");
                                                  }
                                                }),
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

  Widget _buildTabBar() {
    return Row(
      children: [
        _buildTab('Ongoing Orders', 0),
        const SizedBox(width: 8),
        _buildTab('History', 1),
      ],
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = type == index;
    return InkWell(
      onTap: () => setState(() => type = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? ColorPath.flushMahogany : ColorPath.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: GlobalTypography.pMedium.copyWith(
            color: isSelected ? ColorPath.white : ColorPath.black,
          ),
        ),
      ),
    );
  }
}
