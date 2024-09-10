
import 'package:flutter/material.dart';

class LiveMenuVariables {
  static Map<String, List<Map<String,dynamic>>> filteredFoodCategory = {};

  static Set<String> selectedCategoriesBreakfast = Set();
  static Set<String> selectedCategoriesLunch = Set();
  static Set<String> selectedCategoriesDinner = Set();
  static Set<String> selectedCategoriesAll = Set();

  static bool enabled = false;

  static String selectedItem = 'Akki payasa';

  static Map<String, List<Map<String,dynamic>>> foodCategories = {};

  static Map<String, List<Map<String,dynamic>>> liveMenufoodCategoriesBreakfast = {};
  static Map<String, List<Map<String,dynamic>>> liveMenufoodCategoriesLunch = {};
  static Map<String, List<Map<String,dynamic>>> liveMenufoodCategoriesDinner = {};
  static Map<String, List<Map<String,dynamic>>> liveMenufoodCategoriesAll = {};

  static Map<String, List<Map<String,dynamic>>> liveMenuNewfoodCategoriesBreakfast = {};
  static Map<String, List<Map<String,dynamic>>> liveMenuNewfoodCategoriesLunch = {};
  static Map<String, List<Map<String,dynamic>>> liveMenuNewfoodCategoriesDinner = {};
  static Map<String, List<Map<String,dynamic>>> liveMenuNewfoodCategoriesAll = {};

  static Map<String, List<Map<String,dynamic>>> subscriptionCategories = {};

  static Map<String, dynamic> selectItem = {};

  static Map<String, dynamic> liveMenuSelectItemBreakfast = {};
  static Map<String, dynamic> liveMenuSelectItemLunch = {};
  static Map<String, dynamic> liveMenuSelectItemDinner = {};
  static Map<String, dynamic> liveMenuSelectItemAll = {};

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

  static bool breakfastEnabled = true;
  static bool lunchEnabled = true;
  static bool dinnerEnabled = true;

  static bool bfSession1Enabled = true;
  static bool bfSession2Enabled = true;
  static bool bfSession3Enabled = true;

  static bool lnSession1Enabled = true;
  static bool lnSession2Enabled = true;
  static bool lnSession3Enabled = true;

  static bool dnSession1Enabled = true;
  static bool dnSession2Enabled = true;
  static bool dnSession3Enabled = true;

  static List<String> onSelectionItems = [];

}