class MyOrder {
  final String orderId;
  final String pickupLatitude;
  final String pickupLongitude;
  final String dropLatitude;
  final String dropLongitude;
  final String date;
  final String status;

  MyOrder(
      {required this.orderId,
      required this.pickupLatitude,
      required this.pickupLongitude,
      required this.dropLatitude,
      required this.dropLongitude,
      required this.date,
      required this.status});

  factory MyOrder.fromJson(Map<String, dynamic> json) {
    return MyOrder(
        orderId: json['order_id'],
        pickupLatitude: json['pickup_latitude'],
        pickupLongitude: json['pickup_longitude'],
        dropLatitude: json['drop_latitude'],
        dropLongitude: json['drop_longitude'],
        date: json['date'],
        status: json['status']);
  }
}
