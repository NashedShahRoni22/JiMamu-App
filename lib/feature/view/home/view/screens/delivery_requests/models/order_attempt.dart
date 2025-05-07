// order_attempt.dart
import 'rider_bid.dart';

class OrderAttempt {
  final String status;
  final String orderTrackingNumber;
  final int paymentStatus;
  final int fare;
  final String orderDate;
  final List<RiderBid> riderBids;

  OrderAttempt({
    required this.status,
    required this.orderTrackingNumber,
    required this.paymentStatus,
    required this.fare,
    required this.orderDate,
    required this.riderBids,
  });

  factory OrderAttempt.fromJson(Map<String, dynamic> json) {
    return OrderAttempt(
      status: json['status'],
      orderTrackingNumber: json['order_tracking_number'],
      paymentStatus: json['payment_status'],
      fare: json['fare'],
      orderDate: json['order_date'],
      riderBids: (json['rider_bids'] as List)
          .map((e) => RiderBid.fromJson(e))
          .toList(),
    );
  }
}
