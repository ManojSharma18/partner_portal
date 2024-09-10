import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:partner_admin_portal/constants/global_variables.dart';
import 'package:partner_admin_portal/models/live_menu_model.dart';
import 'package:partner_admin_portal/models/restaurant_menu.dart';

import '../models/standard_menu_model.dart';

class MenuService {

  Future<List<Mymenu>> fetchData() async {
    final response = await http.get(Uri.parse('$apiUrl/mymenu'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      // print("Menu data is ${data}");
      return data.map((item) => Mymenu.fromJson(item)).toList();

    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<LiveMenuModel>> fetchLiveMenuData() async {
    final response = await http.get(Uri.parse('$apiUrl/mymenu/liveMenu'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
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

  Future<List<String>> fetchDisplayNames() async {
    final response = await http.get(Uri.parse('$apiUrl/menuEditor/displayName'));

    if (response.statusCode == 200) {
      // Decode the JSON response into a List<String>
      List<dynamic> data = json.decode(response.body);
      List<String> tags = List<String>.from(data);
      return tags;
    } else {
      // Throw an exception if the status code is not 200
      throw Exception('Failed to load tags');
    }
  }

  Future<StandardItem?> fetchItemByDisplayName(String displayName) async {
    final url = Uri.parse('$apiUrl/menuEditor/item/$displayName');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return StandardItem.fromJson(json);
      } else if (response.statusCode == 404) {
        print('Item not found');
      } else {
        print('Error fetching item: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error fetching item: $error');
    }

    return null;
  }

  Future<List<String>> fetchDisplayNamesByTag(BuildContext context, String tagName, {int limit = 5}) async {
    final response = await http.get(Uri.parse('$apiUrl/menuEditor/tag/$tagName'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<String> displayNames = List<String>.from(data);

      // Take only the first `limit` display names
      List<String> firstLimitDisplayNames = displayNames.take(limit).toList();

      return firstLimitDisplayNames;
    } else {
      throw Exception('Failed to load display names');
    }
  }

  Future<List<String>> fetchDisplayNamesByTagSearch(String tagName, String searchedString) async {
    try {
      final apiUrl1 = '$apiUrl/menuEditor/tag/$tagName?searchTerm=$searchedString';
      final response = await http.get(Uri.parse(apiUrl1));

      if (response.statusCode == 200) {
        // Successfully fetched data
        List<String> displayNames = List<String>.from(json.decode(response.body));
        // Use the displayNames as needed
        print('Display Names: $displayNames');
        return displayNames;
      } else {
        // Handle HTTP error
        print('Failed to fetch data: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      // Handle other errors
      print('Error: $e');
    }
    return [];
  }


  Future<Mymenu> addSection(Map<String, dynamic> sectionData) async {
    final response = await http.post(
      Uri.parse('$apiUrl/mymenu/addSection'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(sectionData),
    );

    print(response.statusCode);

    if (response.statusCode == 201) {
      return Mymenu.fromJson(json.decode(response.body));
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
        // print("Items deleted successfully. Deleted count: ${responseData['deletedCount']}");
      } else if (response.statusCode == 404) {
        print("No items found with the given tag.");
      } else {
        print("Failed to delete items. Status code:");
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
        'ritem_tag': newTag,
      }),
    );

    if (response.statusCode == 200) {
      print('Items updated successfully');

    } else {
      print('Failed to update items');
      // print('Response: ${response.body}');
    }
  }

  Future<void> updateByTag(String stdItmTag, bool stdItmAvailability) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/mymenu/updateByTag/availability/$stdItmTag'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, bool>{'ritem_availability': stdItmAvailability}),
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

  Future<List<String>> fetchRegional() async {
    final response = await http.get(Uri.parse('$apiUrl/menuEditor/regional'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.cast<String>();
    } else {
      throw Exception('Failed to load regional data');
    }
  }

  Future<List<String>> fetchSubCategory(String category) async {
    final response = await http.get(Uri.parse('$apiUrl/menuEditor/subCategory/$category'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.cast<String>();
    } else {
      throw Exception('Failed to load subcategory data');
    }
  }

  Future<List<String>>   fetchCuisine() async {
    final response = await http.get(Uri.parse('$apiUrl/menuEditor/cuisine'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.cast<String>();
    } else {
      throw Exception('Failed to load cuisine data');
    }
  }

}