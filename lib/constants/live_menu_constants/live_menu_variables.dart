
import 'package:flutter/material.dart';

class LiveMenuVariables {
  static Map<String, List<Map<String,dynamic>>> filteredFoodCategory = {};

  static Set<String> selectedCategories = Set();

  static bool enabled = false;

  static String selectedItem = 'Idli';

  static Map<String, List<Map<String,dynamic>>> foodCategories = {
    'South indian breakfast': [
      {'name' : 'Idli', 'availability' : true,'category' : 'veg'},
      {'name' :'Poori','availability' : false,'category' : 'veg'},
      {'name' : 'Shavige bath','availability' : false,'category' : 'veg'}
    ],

    'North indian breakfast': [
      {'name' : 'Chole bature', 'availability' : true,'category' : 'veg'},
      {'name' :'Rava chilla','availability' : false,'category' : 'veg'},
      {'name' : 'Pav bhaji','availability' : true ,'category' : 'veg'}
    ],

    'South indian palya': [
      {'name' : 'Beans palya', 'availability' : true,'category' : 'veg'},
      {'name' :'Balekayi palya','availability' : false,'category' : 'veg'},
      {'name' : 'Soppin palya','availability' : false ,'category' : 'veg'}
    ],

    'North indian subzi': [
      {'name' : 'Aloo moongere ki sabzi', 'availability' : true,'category' : 'veg'},
      {'name' : 'Aloo bhindi','availability' : false,'category' : 'veg'},
      {'name' : 'Gobo mater','availability' : false,'category' : 'veg' }
    ],

    'South indian ricebath': [
      {'name' : 'lemon rice', 'availability' : true,'category' : 'veg'},
      {'name' :'puliyogare','availability' : false,'category' : 'veg'},
      {'name' : 'tomoto anna','availability' : false ,'category' : 'veg'}
    ],

    'South indian sambar': [
      {'name' : 'onion sambar', 'availability' : true,'category' : 'veg'},
      {'name' :'drumstick sambar','availability' : false,'category' : 'veg'},
      {'name' : 'mixed vegitables sambar','availability' : false ,'category' : 'veg'}
    ],

    'South indian sweets': [
      {'name' : 'Akki payasa', 'availability' : true,'category' : 'veg'},
      {'name' :'Godhi payasa','availability' : false,'category' : 'veg'},
      {'name' : 'shavide payasa','availability' : false,'category' : 'veg'}
    ],

  };

  static TextEditingController total = TextEditingController();
  static TextEditingController breakfastTotal = TextEditingController();
  static TextEditingController lunchTotal = TextEditingController();
  static TextEditingController dinnerTotal = TextEditingController();

}