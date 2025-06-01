import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jimamu/constant/color_path.dart';
import 'package:jimamu/feature/view/home/view/screens/delivery_requests/view/widgets/request_card.dart';
import '../../../../service/order_service.dart';
import '../models/delivery_request.dart';

class DeliveryRequestsScreen extends StatefulWidget {
  static const String id = 'DeliveryRequestsScreen';
  final String orderType;
  const DeliveryRequestsScreen({super.key, required this.orderType});

  @override
  State<DeliveryRequestsScreen> createState() => _DeliveryRequestsScreenState();
}

class _DeliveryRequestsScreenState extends State<DeliveryRequestsScreen> {
  int type = 0;

  List<DeliveryRequest> deliveryRequests = [];
  bool isLoading = true;

  void _fetchRequests() async {
    try {
      setState(() {
        isLoading = true;
      });
      final data = await OrderService.fetchDeliveryRequests(widget.orderType);
      setState(() {
        deliveryRequests = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar('Error', 'Failed to fetch delivery requests');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Requests')),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: ColorPath.flushMahogany,
            ))
          : deliveryRequests.isEmpty
              ? const Center(
                  child: Text("There are no available order requests now. "),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: deliveryRequests.length,
                  itemBuilder: (context, index) {
                    final request = deliveryRequests[index];
                    final attempt = request.orderAttempts[0];
                    return RequestCard(
                      orderId: request.orderId,
                      date: request.date,
                      fromLat: request.pickupLatitude,
                      fromLong: request.pickupLongitude,
                      toLat: request.dropLatitude,
                      toLong: request.dropLongitude,
                      bid: attempt.fare,
                    );
                  },
                ),
    );
  }
}
