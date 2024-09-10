import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/models/live_menu_model.dart';
import 'package:partner_admin_portal/models/restaurant_menu.dart';


class LiveMenuService {

  Future<LiveMenuModel> addItemDetails(Map<String, dynamic> itemData) async {
    final response = await http.post(
      Uri.parse('$apiUrl/liveMenu/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(itemData),
    );

    print(response.statusCode);

    print(json.decode(response.body));

    if (response.statusCode == 201) {
      return LiveMenuModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add section');
    }
  }

  Future<LiveMenuModel> addItemDetailsToLiveMenu(Map<String, dynamic> itemData) async {
    final response = await http.post(
      Uri.parse('$apiUrl/liveMenu/moveToLiveMenu/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(itemData),
    );

    print(response.statusCode);

    if (response.statusCode == 201) {
      return LiveMenuModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add section');
    }
  }

  Future<List<LiveMenuModel>> fetchData() async {
    final response = await http.get(Uri.parse('$apiUrl/liveMenu'));
    print("Status code ${response.statusCode}");
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => LiveMenuModel.fromJson(item)).toList();

    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> deleteItem(Map<String, dynamic> itemData) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/liveMenu'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(itemData),
      );

      print("Status code ${response.statusCode}");

      if (response.statusCode == 200) {
        print("Response data ${response.body}");
      } else if (response.statusCode == 404) {
        throw Exception('Item not found');
      } else if (response.statusCode == 400) {
        throw Exception('Invalid request: uId is required');
      } else {
        throw Exception('Failed to delete item');
      }
    } catch (error) {
      print('Error occurred: $error');
      throw Exception('Failed to delete item');
    }
  }



}