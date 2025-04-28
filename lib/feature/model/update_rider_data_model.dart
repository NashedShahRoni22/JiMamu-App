import 'package:hive/hive.dart';
part 'update_rider_data_model.g.dart';
@HiveType(typeId: 5)
class UpdateRiderDataModel {
  @HiveField(0)
  bool? success;
  @HiveField(1)
  String? message;
  @HiveField(2)
  Data? data;
  @HiveField(3)
  String? error;

  UpdateRiderDataModel({this.success, this.message, this.data, this.error});

  UpdateRiderDataModel.fromJson(Map<String, dynamic> json) {
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
@HiveType(typeId: 6)
class Data {
  @HiveField(0)
  String? status;
  @HiveField(1)
  List<String>? role;
  @HiveField(2)
  List<RiderDocument>? riderDocument;
  @HiveField(3)
  List<RiderBankInformation>? riderBankInformation;

  Data({this.status, this.role, this.riderDocument, this.riderBankInformation});

  Data.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    role = json['role'].cast<String>();
    if (json['rider_document'] != null) {
      riderDocument = <RiderDocument>[];
      json['rider_document'].forEach((v) {
        riderDocument!.add(new RiderDocument.fromJson(v));
      });
    }
    if (json['rider_bank_information'] != null) {
      riderBankInformation = <RiderBankInformation>[];
      json['rider_bank_information'].forEach((v) {
        riderBankInformation!.add(new RiderBankInformation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['role'] = this.role;
    if (this.riderDocument != null) {
      data['rider_document'] =
          this.riderDocument!.map((v) => v.toJson()).toList();
    }
    if (this.riderBankInformation != null) {
      data['rider_bank_information'] =
          this.riderBankInformation!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

@HiveType(typeId: 7)
class RiderDocument {
  @HiveField(0)
  String? documentType;
  @HiveField(1)
  String? documentNumber;
  @HiveField(2)
  List<String>? document;
  @HiveField(3)
  String? reviewStatus;

  RiderDocument(
      {this.documentType,
        this.documentNumber,
        this.document,
        this.reviewStatus});

  RiderDocument.fromJson(Map<String, dynamic> json) {
    documentType = json['document_type'];
    documentNumber = json['document_number'];
    document = json['document'].cast<String>();
    reviewStatus = json['review_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['document_type'] = this.documentType;
    data['document_number'] = this.documentNumber;
    data['document'] = this.document;
    data['review_status'] = this.reviewStatus;
    return data;
  }
}
@HiveType(typeId: 8)
class RiderBankInformation {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? accountNumber;
  @HiveField(3)
  String? cvcCode;
  @HiveField(4)
  String? expiryDate;
  @HiveField(5)
  int? isDefaultPayment;
  @HiveField(6)
  String? reviewStatus;

  RiderBankInformation(
      {this.id,
        this.name,
        this.accountNumber,
        this.cvcCode,
        this.expiryDate,
        this.isDefaultPayment,
        this.reviewStatus});

  RiderBankInformation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    accountNumber = json['account_number'];
    cvcCode = json['cvc_code'];
    expiryDate = json['expiry_date'];
    isDefaultPayment = json['is_default_payment'];
    reviewStatus = json['review_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['account_number'] = this.accountNumber;
    data['cvc_code'] = this.cvcCode;
    data['expiry_date'] = this.expiryDate;
    data['is_default_payment'] = this.isDefaultPayment;
    data['review_status'] = this.reviewStatus;
    return data;
  }
}