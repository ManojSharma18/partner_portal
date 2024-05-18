
import 'package:flutter/material.dart';

class MenuEditorVariables {

  static Map<String, List<Map<String,dynamic>>> filteredFoodCategory = {};

  static Set<String> selectedCategories = Set();

  static String selectedItem = '';

  static Map<String, List<Map<String,dynamic>>> menuFoodCategories = {};

  static Map<String, dynamic> selectItem = {};

  static TextEditingController nameController = TextEditingController();
  static TextEditingController categoryController = TextEditingController();
  static TextEditingController subCategoryController = TextEditingController();
  static TextEditingController subTagController = TextEditingController();
  static TextEditingController budgetController = TextEditingController();
  static TextEditingController typeController = TextEditingController();
  static TextEditingController subTypeController = TextEditingController();
  static TextEditingController descriptionController = TextEditingController();
  static TextEditingController comboController = TextEditingController();
  static TextEditingController sectionController = TextEditingController();
  static TextEditingController itemController = TextEditingController();
  static TextEditingController normalPriceController = TextEditingController();
  static TextEditingController preorderPriceController = TextEditingController();
  static TextEditingController packagindController = TextEditingController();
  static TextEditingController gstController = TextEditingController();
  static TextEditingController cuisineController = TextEditingController();
  static TextEditingController rawSourceController = TextEditingController();

  static Map<String,Map<String,bool>> mealSessions = {
    'Breakfast' : {"s1" : true,"s2" : false, "s3" : false},
    "Lunch" : {"s1" : true,"s2" : true, "s3" : true},
    "Dinner" : {"s1" : true,"s2" : false, "s3" : false}
  };

  static Map<String,Map<String,Map<String,bool>>> daysMealSession = {
    "Sun" :
    {
      "Breakfast" : { "S1" : false,"S2" : true,"S3" : true,"S4" : true },
      "Lunch" : { "S1" : true,"S2" : true,"S3" : true , "S4" : false},
      "Dinner" : { "S1" : true,"S2" : true,"S3" : true , "S4" : false },
    },
    "Mon" :
    {
      "Breakfast" : { "S1" : false,"S2" : false,"S3" : false,"S4" : false },
      "Lunch" : { "S1" : false,"S2" : false,"S3" : false , "S4" : false},
      "Dinner" : { "S1" : false,"S2" : false,"S3" : false , "S4" : false},
    },
    "Tue" :
    {
      "Breakfast" : { "S1" : false,"S2" : false,"S3" : false,"S4" : false },
      "Lunch" : { "S1" : false,"S2" : false,"S3" : false , "S4" : false},
      "Dinner" : { "S1" : false,"S2" : false,"S3" : false , "S4" : false},
    },
    "Wed" :
    {
      "Breakfast" : { "S1" : false,"S2" : false,"S3" : false,"S4" : false },
      "Lunch" : { "S1" : false,"S2" : false,"S3" : false , "S4" : false},
      "Dinner" : { "S1" : false,"S2" : false,"S3" : false , "S4" : false},
    },
    "Thu" :
    {
      "Breakfast" : { "S1" : false,"S2" : false,"S3" : false,"S4" : false },
      "Lunch" : { "S1" : false,"S2" : false,"S3" : false , "S4" : false},
      "Dinner" : { "S1" : false,"S2" : false,"S3" : false , "S4" : false},
    },
    "Fri" :
    {
      "Breakfast" : { "S1" : false,"S2" : false,"S3" : false,"S4" : false },
      "Lunch" : { "S1" : false,"S2" : false,"S3" : false , "S4" : false},
      "Dinner" : { "S1" : false,"S2" : false,"S3" : false , "S4" : false},
    },
    "Sat" :
    {
      "Breakfast" : { "S1" : false,"S2" : false,"S3" : false,"S4" : false },
      "Lunch" : { "S1" : false,"S2" : false,"S3" : false , "S4" : false},
      "Dinner" : { "S1" : false,"S2" : false,"S3" : false , "S4" : false},
    },
  };

  static int selectedOption = 1;

}