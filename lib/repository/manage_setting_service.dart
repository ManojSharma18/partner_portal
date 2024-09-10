import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:partner_admin_portal/constants/global_variables.dart';
import '../models/manage_setting.dart';

class ManageSettingService {

  Future<void> createManageSetting(ManageSettingModel manageSetting) async {
    final String url = '$apiUrl/manageSetting/';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(manageSetting.toJson()),
      );

      if (response.statusCode == 201) {
        // Success
        print('ManageSetting created successfully');
        print(response.body);  // You can use this if you want to parse response data
      } else {
        // Error handling
        print('Failed to create ManageSetting. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> updateManageSetting(ManageSettingModel manageSetting,String id) async {
    final String url = '$apiUrl/manageSetting/${id}';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(manageSetting.toJson()),
      );

      if (response.statusCode == 200) {
        // Success
        print('ManageSetting updated successfully');
        print(response.body);  // Optional: print the updated object
      } else if (response.statusCode == 404) {
        print('ManageSetting not found');
      } else {
        // Handle other status codes
        print('Failed to update ManageSetting. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<ManageSettingModel?> fetchManageSetting(String fpUnitId) async {
    final String url = '$apiUrl/manageSetting/$fpUnitId';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse); // Log the JSON response for debugging
        return ManageSettingModel.fromJson(jsonResponse);
      }
      else if (response.statusCode == 404) {
        print('ManageSetting not found');
        return null;
      } else {
        print('Failed to load ManageSetting. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('An error occurred: $e');
      return null;
    }
  }

}
