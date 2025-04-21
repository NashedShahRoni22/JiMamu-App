class UserProfileDataModel {
  var success;
  String? message;
  Data? data;
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

class Data {
  String? name;
  String? email;
  String? phoneNumber;
  String? profileImage;
  String? dod;
  String? status;

  Data(
      {this.name,
        this.email,
        this.phoneNumber,
        this.profileImage,
        this.dod,
        this.status});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    profileImage = json['profile_image'];
    dod = json['dod'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['profile_image'] = this.profileImage;
    data['dod'] = this.dod;
    data['status'] = this.status;
    return data;
  }
}