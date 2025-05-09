class MyDeliveriesModel {
  final String orderId;
  final String pickupLatitude;
  final String pickupLongitude;
  final String dropLatitude;
  final String dropLongitude;
  final String date;
  final String status;
  final List<OrderAttempt> orderAttempts;
  final ReceiverInfo receiver;

  MyDeliveriesModel({
    required this.orderId,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.dropLatitude,
    required this.dropLongitude,
    required this.date,
    required this.status,
    required this.orderAttempts,
    required this.receiver,
  });

  factory MyDeliveriesModel.fromJson(Map<dynamic, dynamic> json) {
    return MyDeliveriesModel(
      orderId: json['order_id'],
      pickupLatitude: json['pickup_latitude'],
      pickupLongitude: json['pickup_longitude'],
      dropLatitude: json['drop_latitude'],
      dropLongitude: json['drop_longitude'],
      date: json['date'],
      status: json['status'],
      orderAttempts: (json['order_attempts'] as List)
          .map((e) => OrderAttempt.fromJson(e))
          .toList(),
      receiver: ReceiverInfo.fromJson(json['receiver_information']),
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
    this.profileImage,
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
