import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:jimamu/feature/model/user_profile-model.dart';

import '../../constant/api_path.dart';
import '../../constant/local_string.dart';
import '../../utils/service/api_request.dart';
import '../../utils/ui/custom_loading.dart';
import '../model/token.dart';
import 'package:http/http.dart' as http;

import '../model/update_rider_data_model.dart';

class UserController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController photoUrlController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController docTypeController = TextEditingController();
  TextEditingController cvcNumberController = TextEditingController();
  TextEditingController expireDateController = TextEditingController();
  TextEditingController docNumberController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();

  Rx<UpdateRiderDataModel> updateRiderDataModel = Rx(UpdateRiderDataModel());

  // Hive Box
  final Box<Token> tokenBox = Hive.box<Token>(LocalString.TOKEN_BOX);
  final Box<UserProfileDataModel> userBox =
      Hive.box<UserProfileDataModel>(LocalString.USER_PROFILE_BOX);
  final Box<UpdateRiderDataModel> riderBox =
      Hive.box<UpdateRiderDataModel>(LocalString.RIDER_PROFILE_BOX);

  UserProfileDataModel get userProfile =>
      userBox.get('user') ?? UserProfileDataModel();
  UpdateRiderDataModel get riderProfile =>
      riderBox.get('rider') ?? UpdateRiderDataModel();

  RxBool isDefault = RxBool(false);
  RxBool isLoadedUserData = RxBool(false);

  File? fontFile;
  File? backSideFile;
  File? otherFile;
  int index = 0;

  String? existingFrontImageUrl;
  String? existingBackImageUrl;
  String? existingOtherImageUrl;

  updateUserProfile(BuildContext context) async {
    Token? token = tokenBox.get('token');
    CustomLoading.loadingDialog();

    // DateTime expDate=DateTime.parse(expireDateController.text);

    try {
      var headers = {'Authorization': 'Bearer ${token!.data!.token}'};
      var request = http.MultipartRequest('POST',
          Uri.parse('https://jimamu.nsrdev.com/api/v1/rider/profile/update'));
      request.fields.addAll({
        '_method': 'put',
        'document_type': '${docTypeController.text}',
        'document_number': "${docNumberController.text}",
        'is_default_payment[]': '${isDefault.value.toString()}',
        'id[]': '',
        'name[]': 'paypal id 2,stripe',
        'card_number[]': '${cardNumberController.text}',
        'cvc_code[]': '${cvcNumberController.text}',
        'expire_date[]': '${expireDateController.text}',
        'type[]': 'card'
      });
      if (otherFile != null) {
        request.files.add(
            await http.MultipartFile.fromPath('document[]', otherFile!.path));
      }

      if (fontFile != null) {
        request.files.add(
            await http.MultipartFile.fromPath('document[]', fontFile!.path));
      }

      if (backSideFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'document[]', backSideFile!.path));
      }

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        riderBox.put('rider', updateRiderDataModel.value);
        Get.back();
        // print(await response.stream.bytesToString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(updateRiderDataModel.value.message ?? "Update success")),
        );
        Get.back();
      } else {
        Get.back();
        print(response.reasonPhrase);
      }
    } catch (e) {
      Get.back();
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  getRiderProfileData() {
    isLoadedUserData.value = true;
    ApiRequest apiRequest = ApiRequest(url: ApiPath.getRiderProfileDataUrl);
    final docs = updateRiderDataModel.value.data?.riderDocument;
    if (docs != null && docs.isNotEmpty) {
      if (docs.first.documentType == 'ID Card') {
        existingFrontImageUrl =
            docs.first.document?[0]; // adjust indexing if needed
        existingBackImageUrl =
            docs.first.document?.length == 2 ? docs.first.document![1] : null;
      } else {
        existingOtherImageUrl = docs.first.document?[0];
      }
    }

    apiRequest.getRequestWithAuth().then((res) {
      isLoadedUserData.value = false;
      if (res!.statusCode == 200) {
        log(res.body);
        updateRiderDataModel.value =
            UpdateRiderDataModel.fromJson(jsonDecode(res.body));
        riderBox.put('rider', updateRiderDataModel.value);
        if (updateRiderDataModel.value.data != null) {
          updateUserData();
        }
      }
    }).catchError((e) {
      isLoadedUserData.value = false;
      print(e.toString());
    });
  }

  updateUserData() {
    docTypeController.text =
        updateRiderDataModel.value.data?.riderDocument?.first.documentType ??
            "";
    docNumberController.text =
        updateRiderDataModel.value.data?.riderDocument?.first.documentNumber ??
            "";
    phoneController.text =
        updateRiderDataModel.value.data?.riderDocument?.first.documentType ??
            "";
    cardNumberController.text = updateRiderDataModel
            .value.data?.riderBankInformation?.first.accountNumber ??
        "";
    cvcNumberController.text =
        updateRiderDataModel.value.data?.riderBankInformation?.first.cvcCode ??
            "";
    expireDateController.text = updateRiderDataModel
            .value.data?.riderBankInformation?.first.expiryDate ??
        "";
    if (docTypeController.text == 'Driver License') {}
  }
}
