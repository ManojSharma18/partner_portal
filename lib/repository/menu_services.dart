import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/models/live_menu_model.dart';
import 'package:partner_admin_portal/models/restaurant_menu.dart';

class MenuService {

  Future<List<Mymenu>> fetchData() async {
    final response = await http.get(Uri.parse('$apiUrl/mymenu'));

    print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print(data);
      return data.map((item) => Mymenu.fromJson(item)).toList();

    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<LiveMenuModel>> fetchLiveMenuData() async {
    final response = await http.get(Uri.parse('$apiUrl/mymenu/liveMenu'));

    print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print(data);
      return data.map((item) => LiveMenuModel.fromJson(item)).toList();

    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> updateLiveMenu(String id,Map<String,dynamic> requestBody) async {
    String url = "$apiUrl/mymenu/$id";

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print("LiveMenu updated successfully");

        // Handle success as needed, e.g., show a success message
      } else {
        print("Failed to update LiveMenu. Error: ${response.statusCode}");
        // Handle failure as needed, e.g., show an error message
      }
    } catch (error) {
      print("Error updating LiveMenu: $error");
      // Handle error as needed, e.g., show an error message
    }
  }

  Future<List<String>> fetchTags() async {
    final response = await http.get(Uri.parse('$apiUrl/menuEditor/tag'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<String> tags = List<String>.from(data);
      return tags;
    } else {
      throw Exception('Failed to load tags');
    }
  }

  Future<List<String>> fetchDisplayNamesByTag(BuildContext context,String tagName) async {
    final response = await http.get(Uri.parse('$apiUrl/menuEditor/tag/$tagName'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<String> displayNames = List<String>.from(data);
      return displayNames;
    } else {
      throw Exception('Failed to load display names');
    }
  }

  Future<Map<String, dynamic>> addSection(Map<String, dynamic> sectionData) async {
    final response = await http.post(
      Uri.parse('$apiUrl/mymenu/addSection'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(sectionData),
    );

    print(response.statusCode);

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add section');
    }
  }

  Future<Map<String, dynamic>> updateSection(Map<String, dynamic> sectionData,String id) async {
    final response = await http.put(
      Uri.parse('$apiUrl/mymenu/updateSection/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(sectionData),
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add section');
    }
  }

  Future<void> deleteMenuItem(String id) async {

    print(id);
    try {
      final response = await http.delete(
        Uri.parse("$apiUrl/mymenu/$id"),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        print("Item deleted successfully.");
        final Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData);
      } else if (response.statusCode == 404) {
        print("Item not found.");
      } else {
        print("Failed to delete the item. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  Future<void> deleteMenuItemsByTag(String tag) async {
    try {
      final response = await http.delete(
        Uri.parse("$apiUrl/mymenu/tag/$tag"),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print("Items deleted successfully. Deleted count: ${responseData['deletedCount']}");
      } else if (response.statusCode == 404) {
        print("No items found with the given tag.");
      } else {
        print("Failed to delete items. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  Future<void> updateItemsByTag(String oldTag, String newTag) async {

    final response = await http.put(
      Uri.parse('$apiUrl/mymenu/updateByTag/$oldTag'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'std_itm_tag': newTag,
      }),
    );

    if (response.statusCode == 200) {
      print('Items updated successfully');
      print('Response: ${response.body}');
    } else {
      print('Failed to update items');
      print('Response: ${response.body}');
    }
  }

  Future<void> updateByTag(String stdItmTag, bool stdItmAvailability) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/mymenu/updateByTag/availability/$stdItmTag'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, bool>{'std_itm_availability': stdItmAvailability}),
      );

      if (response.statusCode == 200) {
        print('Items updated successfully');
      } else if (response.statusCode == 404) {
        print('No items found with the given tag');
      } else {
        print('Failed to update items. Server returned status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating items: $error');
    }
  }

}