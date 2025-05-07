import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:jimamu/constant/api_path.dart';
import 'package:jimamu/constant/local_string.dart';
import 'package:jimamu/feature/model/token.dart';
import 'package:jimamu/feature/view/home/model/my_order.dart';

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

  static Future<List<MyOrder>> fetchMyOngoingOrders() async {
    final Box<Token> tokenBox = Hive.box<Token>(LocalString.TOKEN_BOX);
    Token? token = tokenBox.get('token');

    final response = await http.get(
      Uri.parse('${ApiPath.baseUrl}${ApiPath.fetchMyOngoingOrders}'),
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
        return OrderDetails.fromJson(body['data']);
      }
    }
    return null;
  }

  static Future<List<DeliveryRequest>> fetchDeliveryRequests() async {
    final Box<Token> tokenBox = Hive.box<Token>(LocalString.TOKEN_BOX);
    final Token? token = tokenBox.get('token');

    final response = await http.get(
      Uri.parse('${ApiPath.baseUrl}${ApiPath.riderNewOrderRequest}'),
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
}
