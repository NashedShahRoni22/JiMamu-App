class UserProfileDataModel {
  final String name;
  final String email;
  final String phoneNumber;
  final String profileImage;
  final String dob;
  final String gender;
  final String status;
  final List<String> roles;
  final List<RiderBankInformation> bankInfo;

  UserProfileDataModel({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.profileImage,
    required this.dob,
    required this.gender,
    required this.status,
    required this.roles,
    required this.bankInfo,
  });

  factory UserProfileDataModel.fromJson(Map<String, dynamic> json) {
    return UserProfileDataModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      profileImage: json['profile_image'] ?? '',
      dob: json['dob'] ?? '',
      gender: json['gender'] ?? '',
      status: json['status'] ?? '',
      roles: List<String>.from(json['role'] ?? []),
      bankInfo: (json['rider_bank_information'] as List)
          .map((e) => RiderBankInformation.fromJson(e))
          .toList(),
    );
  }
}

class RiderBankInformation {
  final int id;
  final String name;
  final String accountNumber;
  final String cvcCode;
  final String expiryDate;
  final bool isDefaultPayment;
  final String reviewStatus;

  RiderBankInformation({
    required this.id,
    required this.name,
    required this.accountNumber,
    required this.cvcCode,
    required this.expiryDate,
    required this.isDefaultPayment,
    required this.reviewStatus,
  });

  factory RiderBankInformation.fromJson(Map<String, dynamic> json) {
    return RiderBankInformation(
      id: json['id'],
      name: json['name'] ?? '',
      accountNumber: json['account_number'] ?? '',
      cvcCode: json['cvc_code'] ?? '',
      expiryDate: json['expiry_date'] ?? '',
      isDefaultPayment: json['is_default_payment'] == 1,
      reviewStatus: json['review_status'] ?? '',
    );
  }
}
