class OrderDetails {
  final String orderId;
  final String date;
  final String status;
  final double pickupLat;
  final double pickupLng;
  final double dropLat;
  final double dropLng;
  final ReceiverInfo receiver;
  final List<OrderAttempt> orderAttempts;

  OrderDetails({
    required this.orderId,
    required this.date,
    required this.status,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropLat,
    required this.dropLng,
    required this.receiver,
    required this.orderAttempts,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      orderId: json['order_id'],
      date: json['date'],
      status: json['status'],
      pickupLat: double.tryParse(json['pickup_latitude']) ?? 0.0,
      pickupLng: double.tryParse(json['pickup_longitude']) ?? 0.0,
      dropLat: double.tryParse(json['drop_latitude']) ?? 0.0,
      dropLng: double.tryParse(json['drop_longitude']) ?? 0.0,
      receiver: ReceiverInfo.fromJson(json['receiver_information']),
      orderAttempts: (json['order_attempts'] as List)
          .map((e) => OrderAttempt.fromJson(e))
          .toList(),
    );
  }
}

class ReceiverInfo {
  final String name;
  final String phone;

  ReceiverInfo({required this.name, required this.phone});

  factory ReceiverInfo.fromJson(Map<String, dynamic> json) {
    return ReceiverInfo(
      name: json['name'] ?? '',
      phone: json['receiver_phone'] ?? '',
    );
  }
}

class OrderAttempt {
  final String status;
  final String trackingNumber;
  final int paymentStatus;
  final int fare;
  final String orderDate;
  final List<RiderBid> riderBids;

  OrderAttempt({
    required this.status,
    required this.trackingNumber,
    required this.paymentStatus,
    required this.fare,
    required this.orderDate,
    required this.riderBids,
  });

  factory OrderAttempt.fromJson(Map<String, dynamic> json) {
    return OrderAttempt(
      status: json['status'],
      trackingNumber: json['order_tracking_number'],
      paymentStatus: json['payment_status'],
      fare: json['fare'],
      orderDate: json['order_date'],
      riderBids: (json['rider_bids'] as List)
          .map((e) => RiderBid.fromJson(e))
          .toList(),
    );
  }
}

class RiderBid {
  final int riderId;
  final String name;
  final String? profileImage;
  final int bidAmount;

  RiderBid({
    required this.riderId,
    required this.name,
    required this.profileImage,
    required this.bidAmount,
  });

  factory RiderBid.fromJson(Map<String, dynamic> json) {
    return RiderBid(
      riderId: json['rider_id'],
      name: json['name'],
      profileImage: json['profile_image'],
      bidAmount: json['bid_amount'],
    );
  }
}
