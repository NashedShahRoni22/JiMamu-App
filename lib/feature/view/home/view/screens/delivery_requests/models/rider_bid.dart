// rider_bid.dart
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
