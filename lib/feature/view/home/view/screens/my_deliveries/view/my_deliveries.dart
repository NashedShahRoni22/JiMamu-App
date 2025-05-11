import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jimamu/constant/color_path.dart';
import 'package:jimamu/feature/view/home/model/my_deliveries.dart';
import 'package:jimamu/feature/view/home/view/screens/my_deliveries/view/screens/delivery_details.dart';
import 'package:jimamu/feature/view/home/view/screens/my_orders/view/widgets/order_card.dart';
import 'package:jimamu/feature/view/home/service/order_service.dart';

import '../../../../../../../constant/global_typography.dart';

class MyDeliveries extends StatefulWidget {
  static const String id = 'MyDeliveries';
  const MyDeliveries({super.key});

  @override
  State<MyDeliveries> createState() => _MyDeliveriesState();
}

class _MyDeliveriesState extends State<MyDeliveries> {
  int type = 0;

  List<MyDeliveriesModel> myOngoingOrders = [];
  List<MyDeliveriesModel> myCompletedOrders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final ongoingFuture = OrderService.fetchMyOngoingDelivery();
      final completedFuture = OrderService.fetchMyCompletedDelivery();

      final results = await Future.wait([
        ongoingFuture,
        completedFuture,
      ]);

      setState(() {
        myOngoingOrders = results[0] as List<MyDeliveriesModel>;
        myCompletedOrders = results[1] as List<MyDeliveriesModel>;
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
        title: const Text('My Deliveries'),
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
                                                date: order
                                                    .date, // Add if available
                                                from:
                                                    'Lat: ${order.pickupLatitude}, Long: ${order.pickupLongitude}',
                                                to:
                                                    'Lat: ${order.dropLatitude}, Long: ${order.dropLongitude}',
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
                                                        DeliveryDetailsScreen(
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
                                                    'Lat: ${order.pickupLatitude}, Long: ${order.pickupLongitude}',
                                                to:
                                                    'Lat: ${order.dropLatitude}, Long: ${order.dropLongitude}',
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
                                                        DeliveryDetailsScreen(
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
        _buildTab('Live Orders', 0),
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
