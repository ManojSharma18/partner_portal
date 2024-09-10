import 'package:flutter/material.dart';

class MenuEditorVariables {

  static Map<String, List<Map<String,dynamic>>> filteredFoodCategory = {};

  static Set<String> selectedCategories = Set();

  static Set<String> selectedSubscriptionCategories = Set();

  static String selectedItem = "";

  static Map<String, List<Map<String,dynamic>>> menuFoodCategories = {};

  static Map<String, dynamic> selectItem = {};

  static List<String> consumptionMode = [];

  static TextEditingController nameController = TextEditingController();
  static TextEditingController displayNameController = TextEditingController();
  static TextEditingController categoryController = TextEditingController();
  static TextEditingController subCategoryController = TextEditingController();
  static TextEditingController regionalController = TextEditingController();
  static TextEditingController subTagController = TextEditingController();
  static TextEditingController tagController = TextEditingController();
  static TextEditingController budgetController = TextEditingController();
  static TextEditingController typeController = TextEditingController();
  static TextEditingController subTypeController = TextEditingController();
  static TextEditingController descriptionController = TextEditingController();
  static TextEditingController comboController = TextEditingController();
  static TextEditingController consumptionModeController = TextEditingController();
  static TextEditingController sectionController = TextEditingController();
  static TextEditingController itemController = TextEditingController();
  static TextEditingController normalPriceController = TextEditingController();
  static TextEditingController preorderPriceController = TextEditingController();
  static TextEditingController halfNormalPriceController = TextEditingController();
  static TextEditingController halfPreorderPriceController = TextEditingController();
  static TextEditingController packagindController = TextEditingController();
  static TextEditingController gstController = TextEditingController();
  static TextEditingController cuisineController = TextEditingController();
  static TextEditingController rawSourceController = TextEditingController();

  static Map<String,Map<String,bool>> mealSessions = {
    'Breakfast' : {"s1" : true,"s2" : false, "s3" : false},
    "Lunch" : {"s1" : true,"s2" : true, "s3" : true},
    "Dinner" : {"s1" : true,"s2" : false, "s3" : false}
  };

  static Map<String,Map<String,Map<String,int>>> daysMealSession = {
    "Sun" :
    {
      "Breakfast" : { "S1" :0,"S2" : 0,"S3" : 0,"S4" :0 },
      "Lunch" : { "S1" :0,"S2" : 0,"S3" : 0,"S4" :0 },
      "Dinner" : { "S1" :0,"S2" : 0,"S3" : 0,"S4" :0 },
    },
    "Mon" :
    {
      "Breakfast" : { "S1" :0,"S2" : 0,"S3" : 0,"S4" :0 },
      "Lunch" : { "S1" :0,"S2" : 0,"S3" : 0,"S4" :0 },
      "Dinner" : { "S1" :0,"S2" : 0,"S3" : 0,"S4" :0 },
    },
    "Tue" :
    {
      "Breakfast" : { "S1" :0,"S2" : 0,"S3" : 0,"S4" :0 },
      "Lunch" : { "S1" :0,"S2" : 0,"S3" : 0,"S4" :0 },
      "Dinner" : { "S1" :0,"S2" : 0,"S3" : 0,"S4" :0 },
    },
    "Wed" :
    {
      "Breakfast" : { "S1" :0,"S2" : 0,"S3" : 0,"S4" :0 },
      "Lunch" : { "S1" :0,"S2" : 0,"S3" : 0,"S4" :0 },
      "Dinner" : { "S1" :0,"S2" : 0,"S3" : 0,"S4" :0 },
    },
    "Thu" :
    {
      "Breakfast" : { "S1" :0,"S2" : 0,"S3" : 0,"S4" :0 },
      "Lunch" : { "S1" :0,"S2" : 0,"S3" : 0,"S4" :0 },
      "Dinner" : { "S1" :0,"S2" : 0,"S3" : 0,"S4" :0 },
    },
    "Fri" :
    {
      "Breakfast" : { "S1" :0,"S2" : 0,"S3" : 0,"S4" :0 },
      "Lunch" : { "S1" :0,"S2" : 0,"S3" : 0,"S4" :0 },
      "Dinner" : { "S1" :0,"S2" : 0,"S3" : 0,"S4" :0 },
    },
    "Sat" :
    {
      "Breakfast" : { "S1" :0,"S2" : 0,"S3" : 0,"S4" :0 },
      "Lunch" : { "S1" :0,"S2" : 0,"S3" : 0,"S4" :0 },
      "Dinner" : { "S1" :0,"S2" : 0,"S3" : 0,"S4" :0 },
    },
  };

  static Map<String, Map<String, Map<String, Map<String, dynamic>>>> daysMealSession1 = {
    "Sun": {
      "Breakfast": {
        "S1": {"active": false, "count":0},
        "S2": {"active": true, "count": 0},
        "S3": {"active": true, "count": 0},
        "S4": {"active": true, "count": 0},
      },
      "Lunch": {
        "S1": {"active": true, "count": 0},
        "S2": {"active": true, "count": 0},
        "S3": {"active": true, "count": 0},
        "S4": {"active": false, "count": 0},
      },
      "Dinner": {
        "S1": {"active": true, "count": 0},
        "S2": {"active": true, "count": 0},
        "S3": {"active": true, "count": 0},
        "S4": {"active": false, "count": 0},
      },
    },
    "Mon": {
      "Breakfast": {
        "S1": {"active": false, "count": 0},
        "S2": {"active": true, "count": 0},
        "S3": {"active": true, "count": 0},
        "S4": {"active": true, "count": 0},
      },
      "Lunch": {
        "S1": {"active": true, "count": 0},
        "S2": {"active": true, "count": 0},
        "S3": {"active": true, "count": 0},
        "S4": {"active": false, "count": 0},
      },
      "Dinner": {
        "S1": {"active": true, "count": 0},
        "S2": {"active": true, "count": 0},
        "S3": {"active": true, "count": 0},
        "S4": {"active": false, "count": 0},
      },
    },
    "Tue": {
      "Breakfast": {
        "S1": {"active": false, "count": 0},
        "S2": {"active": true, "count": 0},
        "S3": {"active": true, "count": 0},
        "S4": {"active": true, "count": 0},
      },
      "Lunch": {
        "S1": {"active": true, "count": 0},
        "S2": {"active": true, "count": 0},
        "S3": {"active": true, "count": 0},
        "S4": {"active": false, "count": 0},
      },
      "Dinner": {
        "S1": {"active": true, "count": 0},
        "S2": {"active": true, "count": 0},
        "S3": {"active": true, "count": 0},
        "S4": {"active": false, "count": 0},
      },
    },
    "Wed": {
      "Breakfast": {
        "S1": {"active": false, "count": 0},
        "S2": {"active": true, "count": 0},
        "S3": {"active": true, "count": 0},
        "S4": {"active": true, "count": 0},
      },
      "Lunch": {
        "S1": {"active": true, "count": 0},
        "S2": {"active": true, "count": 0},
        "S3": {"active": true, "count": 0},
        "S4": {"active": false, "count": 0},
      },
      "Dinner": {
        "S1": {"active": true, "count": 0},
        "S2": {"active": true, "count": 0},
        "S3": {"active": true, "count": 0},
        "S4": {"active": false, "count": 0},
      },
    },
    "Thu": {
      "Breakfast": {
        "S1": {"active": false, "count": 0},
        "S2": {"active": true, "count": 0},
        "S3": {"active": true, "count": 0},
        "S4": {"active": true, "count": 0},
      },
      "Lunch": {
        "S1": {"active": true, "count": 0},
        "S2": {"active": true, "count": 0},
        "S3": {"active": true, "count": 0},
        "S4": {"active": false, "count": 0},
      },
      "Dinner": {
        "S1": {"active": true, "count": 0},
        "S2": {"active": true, "count": 0},
        "S3": {"active": true, "count": 0},
        "S4": {"active": false, "count": 0},
      },
    },
    "Fri": {
      "Breakfast": {
        "S1": {"active": false, "count": 0},
        "S2": {"active": true, "count": 0},
        "S3": {"active": true, "count": 0},
        "S4": {"active": true, "count": 0},
      },
      "Lunch": {
        "S1": {"active": true, "count": 0},
        "S2": {"active": true, "count": 0},
        "S3": {"active": true, "count": 0},
        "S4": {"active": false, "count": 0},
      },
      "Dinner": {
        "S1": {"active": true, "count": 0},
        "S2": {"active": true, "count": 0},
        "S3": {"active": true, "count": 0},
        "S4": {"active": false, "count": 0},
      },
    },
    "Sat": {
      "Breakfast": {
        "S1": {"active": false, "count": 0},
        "S2": {"active": true, "count": 0},
        "S3": {"active": true, "count": 0},
        "S4": {"active": true, "count": 0},
      },
      "Lunch": {
        "S1": {"active": true, "count": 0},
        "S2": {"active": true, "count": 0},
        "S3": {"active": true, "count": 0},
        "S4": {"active": false, "count": 0},
      },
      "Dinner": {
        "S1": {"active": true, "count": 0},
        "S2": {"active": true, "count": 0},
        "S3": {"active": true, "count": 0},
        "S4": {"active": false, "count": 0},
      },
    },

  };

  static List<Map<String, dynamic>> getBreakfastSessionsWithCountGreaterThanZero() {
    List<Map<String, dynamic>> sessionsWithCountGreaterThanZero = [];

    // Iterate through each day in the map
    daysMealSession1.forEach((day, meals) {
      // Get the "Breakfast" meal for the current day
      Map<String, Map<String, dynamic>> breakfastSessions = meals["Breakfast"]!;

      // Iterate through each session in the "Breakfast" meal
      breakfastSessions.forEach((session, details) {
        // Check if the count is greater than zero
        if (details["count"] > 0) {
          // Add session to the list if count is greater than zero
          sessionsWithCountGreaterThanZero.add({
            "day": day,
            "session": session,
            "details": details,
          });
        }
      });
    });

    return sessionsWithCountGreaterThanZero;
  }


  static Map<String,Map<String,Map<String,bool>>> daysMealSessionSub = {
    "Sun" :
    {
      "Breakfast" : { "B1" : false,"B2" : false,"B3" : false },
      "Lunch" : { "B1" : false,"B2" : false,"B3" : false },
      "Dinner" : { "B1" : false,"B2" : false,"B3" : false },
    },
    "Mon" :
    {
      "Breakfast" : { "B1" : false,"B2" : false,"B3" : false },
      "Lunch" : { "B1" : false,"B2" : false,"B3" : false },
      "Dinner" : { "B1" : false,"B2" : false,"B3" : false },
    },
    "Tue" :
    {
      "Breakfast" : { "B1" : false,"B2" : false,"B3" : false },
      "Lunch" : { "B1" : false,"B2" : false,"B3" : false },
      "Dinner" : { "B1" : false,"B2" : false,"B3" : false },
    },
    "Wed" :
    {
      "Breakfast" : { "B1" : false,"B2" : false,"B3" : false },
      "Lunch" : { "B1" : false,"B2" : false,"B3" : false },
      "Dinner" : { "B1" : false,"B2" : false,"B3" : false },
    },
    "Thu" :
    {
      "Breakfast" : { "B1" : false,"B2" : false,"B3" : false },
      "Lunch" : { "B1" : false,"B2" : false,"B3" : false },
      "Dinner" : { "B1" : false,"B2" : false,"B3" : false },
    },
    "Fri" :
    {
      "Breakfast" : { "B1" : false,"B2" : false,"B3" : false },
      "Lunch" : { "B1" : false,"B2" : false,"B3" : false },
      "Dinner" : { "B1" : false,"B2" : false,"B3" : false },
    },
    "Sat" :
    {
      "Breakfast" : { "B1" : false,"B2" : false,"B3" : false },
      "Lunch" : { "B1" : false,"B2" : false,"B3" : false },
      "Dinner" : { "B1" : false,"B2" : false,"B3" : false },
    },
  };

  static Map<String,Map<String,Map<String,bool>>> daysMealSessionSubMob = {
    "Sun" :
    {
      "Breakfast" : { "B1" : false,"B2" : false, },
      "Lunch" : { "B1" : false,"B2" : false, },
      "Dinner" : { "B1" : false,"B2" : false, },
    },
    "Mon" :
    {
      "Breakfast" : { "B1" : false,"B2" : false, },
      "Lunch" : { "B1" : false,"B2" : false, },
      "Dinner" : { "B1" : false,"B2" : false, },
    },
    "Tue" :
    {
      "Breakfast" : { "B1" : false,"B2" : false, },
      "Lunch" : { "B1" : false,"B2" : false, },
      "Dinner" : { "B1" : false,"B2" : false, },
    },
    "Wed" :
    {
      "Breakfast" : { "B1" : false,"B2" : false, },
      "Lunch" : { "B1" : false,"B2" : false, },
      "Dinner" : { "B1" : false,"B2" : false, },
    },
    "Thu" :
    {
      "Breakfast" : { "B1" : false,"B2" : false, },
      "Lunch" : { "B1" : false,"B2" : false, },
      "Dinner" : { "B1" : false,"B2" : false, },
    },
    "Fri" :
    {
      "Breakfast" : { "B1" : false,"B2" : false, },
      "Lunch" : { "B1" : false,"B2" : false, },
      "Dinner" : { "B1" : false,"B2" : false, },
    },
    "Sat" :
    {
      "Breakfast" : { "B1" : false,"B2" : false, },
      "Lunch" : { "B1" : false,"B2" : false, },
      "Dinner" : { "B1" : false,"B2" : false, },
    },
  };

  static Map<String, Map<String, Map<String, Map<String, dynamic>>>> daysMealSessionSub1 = {
    "Sun": {
      "Breakfast": {
        "B1": {"active": false, "count": 0},
        "B2": {"active": true, "count": 0},
        "B3": {"active": true, "count": 0},
      },
      "Lunch": {
        "B1": {"active": false, "count": 0},
        "B2": {"active": true, "count": 0},
        "B3": {"active": true, "count": 0},
      },
      "Dinner": {
        "B1": {"active": false, "count": 0},
        "B2": {"active": true, "count": 0},
        "B3": {"active": true, "count": 0},
      },
    },
    "Mon": {
      "Breakfast": {
        "B1": {"active": false, "count": 0},
        "B2": {"active": true, "count": 0},
        "B3": {"active": true, "count": 0},
      },
      "Lunch": {
        "B1": {"active": false, "count": 0},
        "B2": {"active": true, "count": 0},
        "B3": {"active": true, "count": 0},
      },
      "Dinner": {
        "B1": {"active": false, "count": 0},
        "B2": {"active": true, "count": 0},
        "B3": {"active": true, "count": 0},
      },
    },
    "Tue": {
      "Breakfast": {
        "B1": {"active": false, "count": 0},
        "B2": {"active": true, "count": 0},
        "B3": {"active": true, "count": 0},
      },
      "Lunch": {
        "B1": {"active": false, "count": 0},
        "B2": {"active": true, "count": 0},
        "B3": {"active": true, "count": 0},
      },
      "Dinner": {
        "B1": {"active": false, "count": 0},
        "B2": {"active": true, "count": 0},
        "B3": {"active": true, "count": 0},
      },
    },
    "Wed": {
      "Breakfast": {
        "B1": {"active": false, "count": 0},
        "B2": {"active": true, "count": 0},
        "B3": {"active": true, "count": 0},
      },
      "Lunch": {
        "B1": {"active": false, "count": 0},
        "B2": {"active": true, "count": 0},
        "B3": {"active": true, "count": 0},
      },
      "Dinner": {
        "B1": {"active": false, "count": 0},
        "B2": {"active": true, "count": 0},
        "B3": {"active": true, "count": 0},
      },
    },
    "Thu": {
      "Breakfast": {
        "B1": {"active": false, "count": 0},
        "B2": {"active": true, "count": 0},
        "B3": {"active": true, "count": 0},
      },
      "Lunch": {
        "B1": {"active": false, "count": 0},
        "B2": {"active": true, "count": 0},
        "B3": {"active": true, "count": 0},
      },
      "Dinner": {
        "B1": {"active": false, "count": 0},
        "B2": {"active": true, "count": 0},
        "B3": {"active": true, "count": 0},
      },
    },
    "Fri": {
      "Breakfast": {
        "B1": {"active": false, "count": 0},
        "B2": {"active": true, "count": 0},
        "B3": {"active": true, "count": 0},
      },
      "Lunch": {
        "B1": {"active": false, "count": 0},
        "B2": {"active": true, "count": 0},
        "B3": {"active": true, "count": 0},
      },
      "Dinner": {
        "B1": {"active": false, "count": 0},
        "B2": {"active": true, "count": 0},
        "B3": {"active": true, "count": 0},
      },
    },
    "Sat": {
      "Breakfast": {
        "B1": {"active": false, "count": 0},
        "B2": {"active": true, "count": 0},
        "B3": {"active": true, "count": 0},
      },
      "Lunch": {
        "B1": {"active": false, "count": 0},
        "B2": {"active": true, "count": 0},
        "B3": {"active": true, "count": 0},
      },
      "Dinner": {
        "B1": {"active": false, "count": 0},
        "B2": {"active": true, "count": 0},
        "B3": {"active": true, "count": 0},
      },
    },

  };

  static int selectedOption = 1;

  static int selectedOptionSub = 0;

  static  Map<String, Map<String, bool>> mealData = {
    'Sun': {'Breakfast': true,  'Lunch':  true, 'Dinner': true},
    'Mon': {'Breakfast': false, 'Lunch': false, 'Dinner': false},
    'Tue': {'Breakfast': false, 'Lunch': false, 'Dinner': false},
    'Wed': {'Breakfast': false, 'Lunch': false, 'Dinner': false},
    'Thu': {'Breakfast': false, 'Lunch': false, 'Dinner': false},
    'Fri': {'Breakfast': false, 'Lunch': false, 'Dinner': false},
    'Sat': {'Breakfast': false, 'Lunch': false, 'Dinner': false},
  };

  static List<String> tags = [];

  static List<String> items = [];

  static List<String> budget = ["BUDGET","POCKET FRIENDLY","PREMIUM","LUXURY"];

  static List<String> subCategory = ["PREPARE TO EAT","READY TO EAT"];

  static List<String> cuisine = [];

  static List<String> regional = [];

  static Map<String,dynamic> requestBody = {};

  static double preOrderFinalPrice = 0.0;
  static double normalFinalPrice = 0.0;

  static double halfPreOrderFinalPrice = 0.0;
  static double halfNormalFinalPrice = 0.0;

  static String oldestTagName = "";

  static String tagAddType = "imported";

  static String itemAddType = "imported";

  static bool isTagDropdown = false;

  static bool isItemDropdown = false;

  static int itemIndex = 0;

  static int findItemIndex = 0;

  static bool isVegChecked = false;
  static bool isNonVegChecked = false;

  static bool isFood = false;
  static bool isBeverage = false;

  static bool isBreakfast = false;
  static bool isLunch = false;
  static bool isDinner = false;

  static bool isBudget = false;
  static bool isPocketFriendly = false;
  static bool isPremium = false;
  static bool isLuxury = false;

  static bool gstPayment = true;

  static bool tagFlag = false;

  static bool priceFlag = false;
  static bool displayNameFlag = false;
  static bool propertyFlag = false;

  static bool halfSelected = false;

  static bool availabilityFlag = false;

  static int getSessionCount(String mealType, String day, int sessionNumber,Map<String, dynamic> item) {
    // You can customize this logic as needed based on your data source
    final sessionKey = '${day.toLowerCase().substring(0, 3)}${mealType}Session$sessionNumber';
    return item[sessionKey];
  }

  static int getSessionCount1(String mealType, String day, int sessionNumber,Map<String, dynamic> item) {
    print("Value is ${day.substring(0,3)} ${mealType}  ${sessionNumber}");
    print("Value is ${MenuEditorVariables.daysMealSession1['${day.substring(0,3)}']![mealType]!['S$sessionNumber']!['count']}");
    return MenuEditorVariables.daysMealSession1['${day.substring(0,3)}']![mealType]!['S$sessionNumber']!['count'];
  }

}