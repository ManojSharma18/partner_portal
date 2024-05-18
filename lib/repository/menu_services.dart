import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:partner_admin_portal/models/live_menu_model.dart';
import 'package:partner_admin_portal/models/restaurant_menu.dart';

class MenuService {

  final String apiUrl = 'http://slys.in:4000/';

  Future<List<Mymenu>> fetchData() async {
    final response = await http.get(Uri.parse('http://localhost:4000/mymenu'));

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
    final response = await http.get(Uri.parse('http://localhost:4000/mymenu/liveMenu'));

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
    String apiUrl = "http://localhost:4000/mymenu/$id";

   

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
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
}