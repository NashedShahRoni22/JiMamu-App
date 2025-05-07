class PlaceOrderRequest {
  final String packageId;
  final double pickupLatitude;
  final double pickupLongitude;
  final double dropLatitude;
  final double dropLongitude;
  final int weight;
  final double totalFare;
  final double pickupRadius;
  final PersonInfo senderInformation;
  final PersonInfo receiverInformation;

  PlaceOrderRequest({
    required this.packageId,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.dropLatitude,
    required this.dropLongitude,
    required this.weight,
    required this.totalFare,
    required this.pickupRadius,
    required this.senderInformation,
    required this.receiverInformation,
  });

  Map<String, dynamic> toJson() {
    return {
      "package_id": packageId,
      "pickup_latitude": pickupLatitude,
      "pickup_longitude": pickupLongitude,
      "drop_latitude": dropLatitude,
      "drop_longitude": dropLongitude,
      "weight": weight,
      "total_fare": totalFare,
      "pickup_radius": pickupRadius,
      "sender_information": senderInformation.toJson(),
      "receiver_information": receiverInformation.toJson(),
    };
  }
}

class PersonInfo {
  final String name;
  final String phoneNumber;
  final String remarks;

  PersonInfo({
    required this.name,
    required this.phoneNumber,
    required this.remarks,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phone_number": phoneNumber,
      "remarks": remarks,
    };
  }
}
