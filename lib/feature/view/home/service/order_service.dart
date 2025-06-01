import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:jimamu/constant/api_path.dart';
import 'package:jimamu/constant/local_string.dart';
import 'package:jimamu/feature/model/token.dart';
import 'package:jimamu/feature/view/home/model/my_order.dart';

import '../model/my_deliveries.dart';
import '../model/order_details.dart';
import '../model/place_order_request.dart';
import '../view/screens/delivery_requests/models/delivery_request.dart';

class OrderService {
  static Future<http.Response> placeOrder(PlaceOrderRequest request) async {
    final Box<Token> tokenBox = Hive.box<Token>(LocalString.TOKEN_BOX);
    Token? token = tokenBox.get('token');

    final headers = {
      'Authorization': 'Bearer ${token?.data?.token}',
      'Content-Type': 'application/json',
    };

    final url = Uri.parse('${ApiPath.baseUrl}${ApiPath.placeOrder}');

    return await http.post(url,
        headers: headers, body: jsonEncode(request.toJson()));
  }

  static Future<List<MyOrder>> fetchMyOngoingOrders(String orderType) async {
    final Box<Token> tokenBox = Hive.box<Token>(LocalString.TOKEN_BOX);
    Token? token = tokenBox.get('token');

    final response = await http.get(
      Uri.parse('${ApiPath.baseUrl}${ApiPath.fetchMyOngoingOrders}$orderType'),
      headers: {
        'Authorization': 'Bearer ${token?.data?.token}',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List<dynamic> orders = body['data'];
      print(token?.data?.token);
      print(orders);
      return orders.map((json) => MyOrder.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  static Future<List<MyOrder>> fetchMyCompletedOrders() async {
    final Box<Token> tokenBox = Hive.box<Token>(LocalString.TOKEN_BOX);
    Token? token = tokenBox.get('token');

    final response = await http.get(
      Uri.parse('${ApiPath.baseUrl}${ApiPath.fetchMyCompletedOrders}'),
      headers: {
        'Authorization': 'Bearer ${token?.data?.token}',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List<dynamic> orders = body['data'];
      print(token?.data?.token);
      print(orders);
      return orders.map((json) => MyOrder.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  static Future<OrderDetails?> fetchOrderDetails(String orderId) async {
    final Box<Token> tokenBox = Hive.box<Token>(LocalString.TOKEN_BOX);
    Token? token = tokenBox.get('token');

    final response = await http.get(
      Uri.parse('${ApiPath.baseUrl}${ApiPath.orderDetails}$orderId'),
      headers: {'Authorization': 'Bearer ${token?.data?.token}'},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['success'] == true) {
        final List<dynamic> orderList = body['data'];
        if (orderList.isNotEmpty) {
          return OrderDetails.fromJson(orderList[0]);
        }
      }
    }
    return null;
  }

  static Future<List<DeliveryRequest>> fetchDeliveryRequests(
      String orderType) async {
    final Box<Token> tokenBox = Hive.box<Token>(LocalString.TOKEN_BOX);
    final Token? token = tokenBox.get('token');

    final response = await http.get(
      Uri.parse('${ApiPath.baseUrl}${ApiPath.riderNewOrderRequest}$orderType'),
      headers: {
        'Authorization': 'Bearer ${token?.data?.token}',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];
      return data.map((e) => DeliveryRequest.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load delivery requests');
    }
  }

  static Future<bool> submitRiderBid({
    required String orderId,
    required int bidAmount,
    required BuildContext context,
  }) async {
    final Box<Token> tokenBox = Hive.box<Token>(LocalString.TOKEN_BOX);
    Token? token = tokenBox.get('token');

    final response = await http.post(
      Uri.parse('${ApiPath.baseUrl}${ApiPath.bidPlacement}$orderId'),
      headers: {
        'Authorization': 'Bearer ${token?.data?.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "bid_amount": bidAmount,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Expanded(child: Text("Bid placed successfully!")),
            ],
          ),
        ),
      );
    } else if (response.statusCode == 409) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                  child:
                      Text("You have already submitted a bid for this order.")),
            ],
          ),
        ),
      );
    } else if (response.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.blueGrey,
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(
                      "${jsonDecode(response.body)['message'] ?? 'Invalid request'}")),
            ],
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(child: Text("Something went wrong. Please try again.")),
            ],
          ),
        ),
      );
    }

    print('Submit Bid Response: ${response.body}');
    return (response.statusCode == 200 || response.statusCode == 201) &&
        jsonDecode(response.body)['success'] == true;
  }

  static Future<bool> confirmRider(
      String orderId, String subOrderId, int riderId) async {
    final Box<Token> tokenBox = Hive.box<Token>(LocalString.TOKEN_BOX);
    Token? token = tokenBox.get('token');

    final response = await http.get(
      Uri.parse(
          '${ApiPath.baseUrl}${ApiPath.confirmRider}$orderId/$subOrderId/$riderId'),
      headers: {'Authorization': 'Bearer ${token?.data?.token}'},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['success'] == true;
    }

    return false;
  }

  static Future<List<MyDeliveriesModel>> fetchMyOngoingDelivery(
      String orderType) async {
    final Box<Token> tokenBox = Hive.box<Token>(LocalString.TOKEN_BOX);
    Token? token = tokenBox.get('token');

    final response = await http.get(
      Uri.parse(
          '${ApiPath.baseUrl}${ApiPath.fetchMyOngoingDelivery}$orderType'),
      headers: {
        'Authorization': 'Bearer ${token?.data?.token}',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final dynamic data = body['data'];

      print(token?.data?.token);
      print(data);
      if (data is List) {
        return data.map((e) => MyDeliveriesModel.fromJson(e)).toList();
      } else if (data is Map) {
        return [MyDeliveriesModel.fromJson(data)];
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load orders');
    }
  }

  static Future<List<MyDeliveriesModel>> fetchMyCompletedDelivery() async {
    final Box<Token> tokenBox = Hive.box<Token>(LocalString.TOKEN_BOX);
    Token? token = tokenBox.get('token');

    final response = await http.get(
      Uri.parse('${ApiPath.baseUrl}${ApiPath.fetchMyCompletedDelivery}'),
      headers: {
        'Authorization': 'Bearer ${token?.data?.token}',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final dynamic data = body['data'];

      print(token?.data?.token);
      print(data);
      if (data is List) {
        return data.map((e) => MyDeliveriesModel.fromJson(e)).toList();
      } else if (data is Map) {
        return [MyDeliveriesModel.fromJson(data)];
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load orders');
    }
  }

  static Future<void> sendOtp(
      String orderId, String otpType, BuildContext context) async {
    final Box<Token> tokenBox = Hive.box<Token>(LocalString.TOKEN_BOX);
    Token? token = tokenBox.get('token');

    final response = await http.get(
      Uri.parse('${ApiPath.baseUrl}rider/order/send/otp/$orderId/$otpType'),
      headers: {'Authorization': 'Bearer ${token?.data?.token}'},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("OTP sent to email")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to send OTP")));
    }
  }

  static Future<bool> verifyOtp(
      String orderId, String otpType, String otp, BuildContext context) async {
    final Box<Token> tokenBox = Hive.box<Token>(LocalString.TOKEN_BOX);
    Token? token = tokenBox.get('token');

    final response = await http.get(
      Uri.parse('${ApiPath.baseUrl}rider/order/verify/$orderId/$otpType/$otp'),
      headers: {'Authorization': 'Bearer ${token?.data?.token}'},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("OTP verified successfully")));
      return true;
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invalid OTP")));
      return false;
    }
  }
}
