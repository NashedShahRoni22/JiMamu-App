import 'dart:async';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../../constant/api_path.dart';
import '../../constant/local_string.dart';
import '../../feature/model/token.dart';
import '../ui/custom_loading.dart';

class ApiRequest {
  final String url;
  final dynamic body;
  ApiRequest({required this.url, this.body});


  Box<Token> tokenBox = Hive.box<Token>(LocalString.TOKEN_BOX);

  Future<http.Response?> postRequest({isLoadingScreen = true}) async {
    isLoadingScreen ? CustomLoading.loadingDialog() : null;
    try {
      return await http.post(
          Uri.parse(ApiPath.baseUrl + url),
          body: body,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json'
          }).timeout(const Duration(minutes: 2));
    } on SocketException {
      Fluttertoast.showToast(msg: 'Connection problem.');
      Get.back();
      return null;
    } on TimeoutException {
      Fluttertoast.showToast(msg: 'Request timeout.');
      Get.back();
      return null;
    }
  }

  // Future<http.Response?> postRequestWithAuth({isLoadingScreen = true}) async {
  //   isLoadingScreen ? CustomLoading.loadingDialog() : null;
  //   Token? token = tokenBox.get('token');
  //
  //   try {
  //     return await http
  //         .post(Uri.parse(ApiPath.baseUrl + url), body: body, headers: {
  //       "Access-Control-Allow-Origin": "*",
  //       'Authorization': 'Bearer ${token!.data!.token}',
  //       HttpHeaders.contentTypeHeader: 'application/json'
  //     }).timeout(const Duration(minutes: 2));
  //   } on SocketException {
  //     Fluttertoast.showToast(msg: 'Check your internet connection.');
  //     Get.back();
  //     return null;
  //   } on TimeoutException {
  //     return null;
  //   }
  // }

  // Future<http.Response?> getRequest() async {
  //   try {
  //     return await http.get(
  //         Uri.parse(
  //           ApiPath.baseUrl + url,
  //         ),
  //         headers: {
  //           "Access-Control-Allow-Origin": "*",
  //           'Content-Type': 'application/json',
  //         }).timeout(const Duration(minutes: 2));
  //   } on SocketException {
  //     Fluttertoast.showToast(msg: 'Connection problem.');
  //     return null;
  //   } on TimeoutException {
  //     Fluttertoast.showToast(msg: 'Request timeout.');
  //     return null;
  //   }
  // }

  Future<http.Response?> getRequestWithAuth() async {
    Token? token = tokenBox.get('token');
    try {
      return await http.get(Uri.parse(ApiPath.baseUrl + url), headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token!.data!.token}',
      }).timeout(const Duration(minutes: 2));
    } on SocketException {
      Fluttertoast.showToast(msg: 'Connection problem.');
      return null;
    } on TimeoutException {
      Fluttertoast.showToast(msg: 'Request timeout.');
      return null;
    }
  }

  // Future<http.Response?> putRequest({isLoadingDialog = false}) async {
  //   isLoadingDialog ? CustomLoading.loadingDialog() : null;
  //   Token? token = tokenBox.get('token');
  //
  //   try {
  //     return await http.put(Uri.parse(ApiPath.baseUrl + url), body: body, headers: {
  //       HttpHeaders.contentTypeHeader: 'application/json',
  //       'Authorization': 'Bearer ${token!.data!.token}',
  //     }).timeout(const Duration(minutes: 2));
  //   } on SocketException {
  //     Fluttertoast.showToast(msg: 'Connection problem.');
  //     Get.back();
  //     return null;
  //   } on TimeoutException {
  //     Fluttertoast.showToast(msg: 'Request timeout.');
  //     Get.back();
  //     return null;
  //   }
  // }

  // Future<http.Response?> deleteRequest({isLoadingDialog = false}) async {
  //   isLoadingDialog ? CustomLoading.loadingDialog() : null;
  //   Token? token = tokenBox.get('token');
  //   try {
  //     return await http
  //         .delete(Uri.parse(ApiPath.baseUrl + url), body: body, headers: {
  //       HttpHeaders.contentTypeHeader: 'application/json',
  //       'Authorization': 'Bearer ${token!.data!.token}',
  //     }).timeout(const Duration(minutes: 2));
  //   } on SocketException {
  //     Fluttertoast.showToast(msg: 'Connection problem.');
  //     Get.back();
  //     return null;
  //   } on TimeoutException {
  //     Fluttertoast.showToast(msg: 'Request timeout.');
  //     Get.back();
  //     return null;
  //   }
  // }
}
