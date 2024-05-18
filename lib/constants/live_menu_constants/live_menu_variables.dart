
import 'package:flutter/material.dart';

class LiveMenuVariables {
  static Map<String, List<Map<String,dynamic>>> filteredFoodCategory = {};

  static Set<String> selectedCategories = Set();

  static bool enabled = false;

  static String selectedItem = 'Akki payasa';

  static Map<String, List<Map<String,dynamic>>> foodCategories = {};

  static Map<String, dynamic> selectItem = {};

  static TextEditingController total = TextEditingController();
  static TextEditingController breakfastTotal = TextEditingController();
  static TextEditingController lunchTotal = TextEditingController();
  static TextEditingController dinnerTotal = TextEditingController();

  static TextEditingController bfSession1Controller = TextEditingController();
  static TextEditingController bfSession2Controller = TextEditingController();
  static TextEditingController bfSession3Controller = TextEditingController();
  static TextEditingController bfSession4Controller = TextEditingController();

  static TextEditingController lnSession1Controller = TextEditingController();
  static TextEditingController lnSession2Controller = TextEditingController();
  static TextEditingController lnSession3Controller = TextEditingController();
  static TextEditingController lnSession4Controller = TextEditingController();

  static TextEditingController dnSession1Controller = TextEditingController();
  static TextEditingController dnSession2Controller = TextEditingController();
  static TextEditingController dnSession3Controller = TextEditingController();
  static TextEditingController dnSession4Controller = TextEditingController();



}