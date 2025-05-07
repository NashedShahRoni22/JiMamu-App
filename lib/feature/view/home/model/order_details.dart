class OrderDetails {
  final String orderId;
  final String status;
  final double fare;
  final String orderDate;
  final List<dynamic> riderBids;

  OrderDetails({
    required this.orderId,
    required this.status,
    required this.fare,
    required this.orderDate,
    required this.riderBids,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    final attempt = json['order_attempts'][0];
    return OrderDetails(
      orderId: json['order_id'],
      status: json['status'],
      fare: (attempt['fare'] as num).toDouble(),
      orderDate: attempt['order_date'],
      riderBids: attempt['rider_bids'],
    );
  }
}
