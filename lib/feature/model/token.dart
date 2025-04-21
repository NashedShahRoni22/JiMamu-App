import 'package:hive/hive.dart';

part 'token.g.dart';

@HiveType(typeId: 1)
class Token {
  @HiveField(0)
  bool? success;
  @HiveField(1)
  String? message;
  @HiveField(2)
  Data? data;
  @HiveField(3)
  String? error;

  Token({this.success, this.message, this.data, this.error});

  Token.fromJson(Map<String, dynamic> json) {
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

@HiveType(typeId: 2)
class Data {
  @HiveField(0)
  String? token;
  @HiveField(1)
  String? status;

  Data({this.token, this.status});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['status'] = this.status;
    return data;
  }
}