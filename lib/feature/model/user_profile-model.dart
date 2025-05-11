import 'package:hive/hive.dart';

part 'user_profile-model.g.dart';

@HiveType(typeId: 3)
class UserProfileDataModel {
  @HiveField(0)
  bool? success;
  @HiveField(1)
  String? message;
  @HiveField(2)
  Data? data;
  @HiveField(3)
  String? error;

  UserProfileDataModel({this.success, this.message, this.data, this.error});

  UserProfileDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['error'] = this.error;
    return data;
  }
}

@HiveType(typeId: 4)
class Data {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? email;
  @HiveField(3)
  String? phoneNumber;
  @HiveField(4)
  int? emailVerifiedAt;
  @HiveField(5)
  String? profileImage;
  @HiveField(6)
  String? dob;
  @HiveField(7)
  String? gender;
  @HiveField(8)
  int? verificationCode;
  @HiveField(9)
  int? userType;
  @HiveField(10)
  var status;
  @HiveField(11)
  String? createdAt;
  @HiveField(12)
  String? updatedAt;
  @HiveField(13)
  int? deletedAt;

  Data(
      {this.id,
      this.name,
      this.email,
      this.phoneNumber,
      this.emailVerifiedAt,
      this.profileImage,
      this.dob,
      this.gender,
      this.verificationCode,
      this.userType,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    emailVerifiedAt = json['email_verified_at'];
    profileImage = json['profile_image'];
    dob = json['dob'];
    gender = json['gender'];
    verificationCode = json['verification_code'];
    userType = json['user_type'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['profile_image'] = this.profileImage;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['verification_code'] = this.verificationCode;
    data['user_type'] = this.userType;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
