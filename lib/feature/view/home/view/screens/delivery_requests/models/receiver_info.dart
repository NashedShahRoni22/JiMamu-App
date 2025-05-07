// receiver_info.dart
class ReceiverInformation {
  final String name;
  final String receiverPhone;

  ReceiverInformation({
    required this.name,
    required this.receiverPhone,
  });

  factory ReceiverInformation.fromJson(Map<String, dynamic> json) {
    return ReceiverInformation(
      name: json['name'],
      receiverPhone: json['receiver_phone'],
    );
  }
}
