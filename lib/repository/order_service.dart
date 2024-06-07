import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:partner_admin_portal/models/subscription_order_model.dart';

import '../constants/global_variables.dart';
import '../models/order_model.dart';

class OrderService {

  Future<List<OrderModel>> fetchOrders() async {
    try {
      final response = await http.get(
          Uri.parse('$apiUrl/orders/order/'));

      if (response.statusCode == 200) {
        // If the request is successful, parse the JSON response into a list of OrderModel
        List<dynamic> jsonOrders = json.decode(response.body);
        List<OrderModel> orders = jsonOrders.map((json) =>
            OrderModel.fromMap(json)).toList();
        return orders;
      } else {
        // If the server returns an error response, throw an exception
        throw Exception('Failed to fetch orders');
      }
    } catch (e) {
      // If an exception occurs during the HTTP request, throw an exception
      throw Exception('Failed to connect to the server');
    }
  }

  Future<List<SubscriptionOrderModel>> fetchSubscriptionOrders() async {
    try {
      final response = await http.get(
          Uri.parse('$apiUrl/subscriptionOrders/subscriptionOrder/'));

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        // If the request is successful, parse the JSON response into a list of OrderModel
        List<dynamic> jsonOrders = json.decode(response.body);
        List<SubscriptionOrderModel> orders = jsonOrders.map((json) =>
            SubscriptionOrderModel.fromMap(json)).toList();
        return orders;
      } else {
        // If the server returns an error response, throw an exception
        throw Exception('Failed to fetch orders');
      }
    } catch (e) {
      // If an exception occurs during the HTTP request, throw an exception
      throw Exception('Failed to connect to the server');
    }
  }

  Future<void> updateOrder(String id,Map<String,dynamic> requestBody) async {
    String url = "$apiUrl/orders/order/$id";

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print("status updated successfully");

        // Handle success as needed, e.g., show a success message
      } else {
        print("Failed to update order status. Error: ${response.statusCode}");
        // Handle failure as needed, e.g., show an error message
      }
    } catch (error) {
      print("Error updating Order status: $error");
      // Handle error as needed, e.g., show an error message
    }
  }

}