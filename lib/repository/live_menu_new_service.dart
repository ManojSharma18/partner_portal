import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:partner_admin_portal/constants/global_variables.dart';

import '../models/live_menu_new_model.dart';

class LiveMenuNewService {

  Future<void> postLiveMenuData(List<LiveMenuNew> liveMenuDataList) async {
    final url = Uri.parse('$apiUrl/liveMenuNew/'); //
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(liveMenuDataList.map((item) => item.toJson()).toList());

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 201) {
        print('Data successfully posted: ${response.body}');
      } else {
        print('Failed to post data: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> postLiveMenuDataFromLiveMenu(List<LiveMenuNew> liveMenuDataList) async {
    final url = Uri.parse('$apiUrl/liveMenuNew/fromLiveMenu/'); //
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(liveMenuDataList.map((item) => item.toJson()).toList());

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 201) {
        print('Data successfully posted: ${response.body}');
      } else {
        print('Failed to post data: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<List<LiveMenuNew>> fetchData() async {
    final response = await http.get(Uri.parse('$apiUrl/liveMenuNew'));
    print("Status code ${response.statusCode}");
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => LiveMenuNew.fromJson(item)).toList();

    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> deleteItems(Map<String, dynamic> itemData) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/liveMenuNew/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(itemData),
      );

      print("Status code ${response.statusCode}");

      if (response.statusCode == 200) {
        print("Response data ${response.body}");
      }
      else if (response.statusCode == 404) {
        throw Exception('Item not found');
      }
      else if (response.statusCode == 400) {
        throw Exception('Invalid request: uId is required');
      } else {
        throw Exception('Failed to delete item');
      }
    } catch (error) {
      print('Error occurred: $error');
      throw Exception('Failed to delete item');
    }
  }

  Future<void> updateItems(List<LiveMenuNewSample> itemData) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/liveMenuNew/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(itemData.map((item) => item.toJson()).toList()),
      );

      if (response.statusCode == 200) {
        print("Response data ${response.body}");
      }
      else if (response.statusCode == 400) {
        throw Exception('Invalid request: uId is required');
      }
      else {
        throw Exception('Failed to delete item');
      }
    } catch (error) {
      print('Error occurred: $error');
      throw Exception('Failed to delete item');
    }
  }

  Future<void> deleteItem(Map<String,dynamic> data) async {
    try {
      final response = await http.delete(
          Uri.parse('$apiUrl/liveMenuNew/fromLiveMenu/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data)
      );

      if (response.statusCode == 200) {
        print("Response data ${response.body}");
      }
      else if (response.statusCode == 400) {
        throw Exception('Invalid request: uId is required');
      }
      else {
        throw Exception('Failed to delete item');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to delete item');
    }
  }

  Future<void> updateItem(Map<String,dynamic> data) async {
    try {
      final response = await http.put(
          Uri.parse('$apiUrl/liveMenuNew/fromLiveMenu/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data)
      );

      if (response.statusCode == 200) {
        print("Response data ${response.body}");
      }
      else if (response.statusCode == 400) {
        throw Exception('Invalid request: uId is required');
      }
      else {
        throw Exception('Failed to delete item');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to delete item');
    }
  }

}

class LiveMenuNewSample {
  String ritemUId;
  String date;
  MealSessionCount updateData;

  LiveMenuNewSample({required this.ritemUId, required this.date, required this.updateData});

  // Convert LiveMenuNewSample to JSON
  Map<String, dynamic> toJson() {
    return {
      'ritem_UId': ritemUId,
      'date': date,
      'updateData': {
        'meals_session_count': updateData.toJson(),
      },
    };
  }
}
