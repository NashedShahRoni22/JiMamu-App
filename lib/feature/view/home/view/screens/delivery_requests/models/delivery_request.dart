// delivery_request.dart
import 'order_attempt.dart';
import 'receiver_info.dart';

class DeliveryRequest {
  final String orderId;
  final String pickupLatitude;
  final String pickupLongitude;
  final String dropLatitude;
  final String dropLongitude;
  final String status;
  final String date;
  final List<OrderAttempt> orderAttempts;
  final ReceiverInformation receiverInformation;

  DeliveryRequest({
    required this.orderId,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.dropLatitude,
    required this.dropLongitude,
    required this.status,
    required this.date,
    required this.orderAttempts,
    required this.receiverInformation,
  });

  factory DeliveryRequest.fromJson(Map<String, dynamic> json) {
    return DeliveryRequest(
      orderId: json['order_id'],
      pickupLatitude: json['pickup_latitude'],
      pickupLongitude: json['pickup_longitude'],
      dropLatitude: json['drop_latitude'],
      dropLongitude: json['drop_longitude'],
      status: json['status'],
      date: json['date'],
      orderAttempts: (json['order_attempts'] as List)
          .map((e) => OrderAttempt.fromJson(e))
          .toList(),
      receiverInformation:
          ReceiverInformation.fromJson(json['receiver_information']),
    );
  }
}
