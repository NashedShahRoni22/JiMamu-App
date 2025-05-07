import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:jimamu/constant/api_path.dart';
import 'package:jimamu/constant/local_string.dart';
import 'package:jimamu/feature/model/token.dart';
import 'package:jimamu/feature/view/home/model/my_order.dart';

import '../feature/view/home/model/order_details.dart';
import '../feature/view/home/model/place_order_request.dart';

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

  static Future<List<MyOrder>> fetchMyOrders() async {
    final Box<Token> tokenBox = Hive.box<Token>(LocalString.TOKEN_BOX);
    Token? token = tokenBox.get('token');

    final response = await http.get(
      Uri.parse('${ApiPath.baseUrl}${ApiPath.fetchMyOrders}'),
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
}
