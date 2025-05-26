class PlaceOrderRequest {
  final String packageId;
  final String orderType; // "national" or "international"
  final double pickupLatitude;
  final double pickupLongitude;
  final double dropLatitude;
  final double dropLongitude;
  final double weight;
  final double parcelEstimatePrice;
  final double totalFare;
  final double pickupRadius;
  final PersonInfo senderInformation;
  final PersonInfo receiverInformation;
  final OrderDestination orderDestination;

  PlaceOrderRequest({
    required this.packageId,
    required this.orderType,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.dropLatitude,
    required this.dropLongitude,
    required this.weight,
    required this.parcelEstimatePrice,
    required this.totalFare,
    required this.pickupRadius,
    required this.senderInformation,
    required this.receiverInformation,
    required this.orderDestination,
  });

  Map<String, dynamic> toJson() {
    return {
      "package_id": packageId,
      "order_type": orderType,
      "pickup_latitude": pickupLatitude,
      "pickup_longitude": pickupLongitude,
      "drop_latitude": dropLatitude,
      "drop_longitude": dropLongitude,
      "weight": weight,
      "parcel_estimate_price": parcelEstimatePrice,
      "total_fare": totalFare,
      "pickup_radius": pickupRadius,
      "sender_information": senderInformation.toJson(),
      "receiver_information": receiverInformation.toJson(),
      "order_destination": orderDestination.toJson(),
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

class OrderDestination {
  final String country;
  final String state;
  final String city;
  final String area;
  final String address;

  OrderDestination({
    required this.country,
    required this.state,
    required this.city,
    required this.area,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      "country": country,
      "state": state,
      "city": city,
      "area": area,
      "address": address,
    };
  }
}
