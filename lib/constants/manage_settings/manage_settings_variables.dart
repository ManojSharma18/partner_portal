
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'manage_settings_functions.dart';
import 'dart:io' as iFile;

class ManageSettingsVariables {

  static List<String> outletList = ['Preference','Outlet information','Bank details','Outlet Timings','FSSAI','GST'];

  static List<String> permission = ['Outlet Permission','App permission','Communication permission'];

  static String selectedPermission = "";

  static bool number = true;

  static List<Map<String,dynamic>> staff =[
    {
      "role" : "Owner",
      "number" : "+91 8431944706",
      "name" : "Krishna",
      "email" : "krishna@gmail.com"
    },

    {
      "role" : "Manager",
      "number" : "+91 8105445911",
      "name" : "Manoj",
      "email" : "manojsharma1882001@gmail.com"
    }
  ];

  static Map<String,dynamic> selectedStaff =  {
    "role" : "Owner",
    "number" : "+91 8431944706",
    "name" : "Krishna",
    "email" : "krishna@gmail.com"
  };

  static List<String> roleType = ['Owner','Manager'];

  static String selectedOutlet = "";

  static String selectedType = "View all";

  static TextEditingController nameController = TextEditingController();
  static TextEditingController emailController = TextEditingController();
  static TextEditingController roleController = TextEditingController();
  static TextEditingController numberController = TextEditingController();

  static TextEditingController restaurantModelController = TextEditingController();

  static bool breakfast = true;
  static bool lunch = true;
  static bool dinner = true;

  static bool isBreakfastSessionEnabled = true;
  static bool isLunchSessionEnabled = true;
  static bool isDinnerSessionEnabled = true;

  static  Map<String, Map<String, bool>> mealData = {
    'Sun': {'Breakfast': true,  'Lunch':  true, 'Dinner': true},
    'Mon': {'Breakfast': false, 'Lunch': false, 'Dinner': false},
    'Tue': {'Breakfast': false, 'Lunch': false, 'Dinner': false},
    'Wed': {'Breakfast': false, 'Lunch': false, 'Dinner': false},
    'Thu': {'Breakfast': false, 'Lunch': false, 'Dinner': false},
    'Fri': {'Breakfast': false, 'Lunch': false, 'Dinner': false},
    'Sat': {'Breakfast': false, 'Lunch': false, 'Dinner': false},
  };

  static  Map<String,Map<String,Map<String,dynamic>>> mealTiming = {
    'Breakfast'   :  {
      'Default'   : {'StartTime' :  '-- -- --','EndTime' : '-- -- --','Enabled' : true},
      'Session1'  : {'StartTime' :  '5:00 AM','EndTime' : '7:00 AM','Enabled' : false},
      'Session2'  : {'StartTime' :  '6:00 AM','EndTime' : '9:00 AM','Enabled' : false},
      'Session3'  : {'StartTime' :  '9:00 AM','EndTime' : '11:00 AM','Enabled' : false},
    },
    'Lunch'   :  {
      'Default'   : {'StartTime' :  '-- -- --','EndTime' : '-- -- --','Enabled' : true},
      'Session1'  : {'StartTime' :  '-- -- --','EndTime' : '-- -- --','Enabled' : false},
      'Session2'  : {'StartTime' :  '-- -- --','EndTime' : '-- -- --','Enabled' : false},
      'Session3'  : {'StartTime' :  '-- -- --','EndTime' : '-- -- --','Enabled' : false},
    },
    'Dinner'   :  {
      'Default'   : {'StartTime' :  '-- -- --','EndTime' : '-- -- --','Enabled' : true},
      'Session1'  : {'StartTime' :  '-- -- --','EndTime' : '-- -- --','Enabled' : false},
      'Session2'  : {'StartTime' :  '-- -- --','EndTime' : '-- -- --','Enabled' : false},
      'Session3'  : {'StartTime' :  '-- -- --','EndTime' : '-- -- --','Enabled' : false},

    },

  };

  static List<String> breakfastTimings = [];
  static List<String> lunchTimings = [];
  static List<String> dinnerTimings = [];

  static List<String> breakfastTimingsSub = [];
  static List<String> lunchTimingsSub = [];
  static List<String> dinnerTimingsSub = [];

  static List<String> consumptionMode = [];

  static TimeOfDay currentTime = TimeOfDay.now();
  static TimeOfDay selectedTime = TimeOfDay.now();


  static int selectedHour = 2;
  static int selectedMinute = 15;
  static bool isAM = true;

  static  Map<String, Map<String, bool>> mealDataSub = {
    'Sun': {'Breakfast': false,  'Lunch':  false, 'Dinner': false},
    'Mon': {'Breakfast': false, 'Lunch': false, 'Dinner': false},
    'Tue': {'Breakfast': false, 'Lunch': false, 'Dinner': false},
    'Wed': {'Breakfast': false, 'Lunch': false, 'Dinner': false},
    'Thu': {'Breakfast': false, 'Lunch': false, 'Dinner': false},
    'Fri': {'Breakfast': false, 'Lunch': false, 'Dinner': false},
    'Sat': {'Breakfast': false, 'Lunch': false, 'Dinner': false},
  };

  static  Map<String,Map<String,Map<String,dynamic>>> mealTimingSub = {
    'Breakfast'   :  {
      'Default'   : {'StartTime' :  '-- -- --','EndTime' : '-- -- --','Enabled' : true},
      'Session1'  : {'StartTime' :  '-- -- --','EndTime' : '-- -- --','Enabled' : false},
      'Session2'  : {'StartTime' :  '-- -- --','EndTime' : '-- -- --','Enabled' : false},
      'Session3'  : {'StartTime' :  '-- -- --','EndTime' : '-- -- --','Enabled' : false},
    },
    'Lunch'   :  {
      'Default'   : {'StartTime' :  '-- -- --','EndTime' : '-- -- --','Enabled' : true},
      'Session1'  : {'StartTime' :  '-- -- --','EndTime' : '-- -- --','Enabled' : false},
      'Session2'  : {'StartTime' :  '-- -- --','EndTime' : '-- -- --','Enabled' : false},
      'Session3'  : {'StartTime' :  '-- -- --','EndTime' : '-- -- --','Enabled' : false},
    },
    'Dinner'   :  {
      'Default'   : {'StartTime' :  '-- -- --','EndTime' : '-- -- --','Enabled' : true},
      'Session1'  : {'StartTime' :  '-- -- --','EndTime' : '-- -- --','Enabled' : false},
      'Session2'  : {'StartTime' :  '-- -- --','EndTime' : '-- -- --','Enabled' : false},
      'Session3'  : {'StartTime' :  '-- -- --','EndTime' : '-- -- --','Enabled' : false},

    },

  };

  static String selectedStartTimeBF = '-- -- --';
  static String selectedStartTimeLunch = '-- -- --';
  static String selectedStartTimeDinner = '-- -- --';

  static String selectedEndTimeBF = '-- -- --';
  static String selectedEndTimeLunch = '-- -- --';
  static String selectedEndTimeDinner = '-- -- --';

  static String selectedStartTimeBFSub = '-- -- --';
  static String selectedStartTimeLunchSub = '-- -- --';
  static String selectedStartTimeDinnerSub = '-- -- --';

  static String selectedEndTimeBFSub = '-- -- --';
  static String selectedEndTimeLunchSub = '-- -- --';
  static String selectedEndTimeDinnerSub = '-- -- --';

  static List<SessionData> sessions = [SessionData(startTime: "", endTime: ""),];

  static List<SessionData> lunchSessions = [SessionData(startTime: "", endTime: ""),];

  static List<SessionData> dinnerSessions = [SessionData(startTime: "", endTime: ""),];


  static List<SessionData> sessionsSub = [SessionData(startTime: "", endTime: "")];

  static List<SessionData> lunchSessionsSub = [SessionData(startTime: "", endTime: "")];

  static List<SessionData> dinnerSessionsSub = [SessionData(startTime: "", endTime: "")];

  static bool defaultBreakfastPreorder = false;
  static bool defaultLunchPreorder = false;
  static bool defaultDinnerPreorder = false;

  static bool defaultBreakfastSubscription = false;
  static bool defaultLunchSubscription = false;
  static bool defaultDinnerSubscription = false;

  static bool breakfastSession1Preorder = false;
  static bool breakfastSession2Preorder = false;
  static bool breakfastSession3Preorder = false;
  static bool breakfastSession4Preorder = false;

  static bool lunchSession1Preorder = false;
  static bool lunchSession2Preorder = false;
  static bool lunchSession3Preorder = false;
  static bool lunchSession4Preorder = false;

  static bool dinnerSession1Preorder = false;
  static bool dinnerSession2Preorder = false;
  static bool dinnerSession3Preorder = false;
  static bool dinnerSession4Preorder = false;

  static bool breakfastSession1Subscription = false;
  static bool breakfastSession2Subscription = false;
  static bool breakfastSession3Subscription = false;
  static bool breakfastSession4Subscription = false;

  static bool lunchSession1Subscription = false;
  static bool lunchSession2Subscription = false;
  static bool lunchSession3Subscription = false;
  static bool lunchSession4Subscription = false;

  static bool dinnerSession1Subscription = false;
  static bool dinnerSession2Subscription = false;
  static bool dinnerSession3Subscription = false;
  static bool dinnerSession4Subscription = false;

  static TextEditingController restaurantDisplayNameController = TextEditingController();
  static TextEditingController unitTypeController = TextEditingController();
  static TextEditingController unitMobController = TextEditingController();
  static TextEditingController unitEmailController = TextEditingController();
  static TextEditingController itemsAvailabilityController = TextEditingController();
  static TextEditingController cityController = TextEditingController();
  static TextEditingController stateController = TextEditingController();
  static TextEditingController addressController = TextEditingController();
  static TextEditingController pincodeController = TextEditingController();

  static TextEditingController chainController = TextEditingController();
  static TextEditingController chainCatrgory = TextEditingController();
  static TextEditingController unitManadeByController = TextEditingController();

  static TextEditingController comanyName = TextEditingController();
  static TextEditingController ownerNumberController = TextEditingController();
  static TextEditingController ownerNameController = TextEditingController();
  static TextEditingController franchiseNameController = TextEditingController();
  static TextEditingController franchiseNumberController = TextEditingController();
  static TextEditingController managerNameController = TextEditingController();
  static TextEditingController managaerNumberController = TextEditingController();

  static TextEditingController panBelongController = TextEditingController();
  static TextEditingController panNumberController = TextEditingController();
  static TextEditingController panNameController = TextEditingController();
  static TextEditingController panDocController = TextEditingController();

  static TextEditingController gstinController = TextEditingController();
  static TextEditingController gstCategoryController = TextEditingController();
  static TextEditingController gstDocController = TextEditingController();

  static TextEditingController upiIdController = TextEditingController();
  static TextEditingController bankNameController = TextEditingController();
  static TextEditingController benificiaryNameController = TextEditingController();
  static TextEditingController actNumController = TextEditingController();
  static TextEditingController ifscController = TextEditingController();
  static TextEditingController bankDocController = TextEditingController();

  static TextEditingController fassiDateController = TextEditingController();
  static TextEditingController fssaiValidateController = TextEditingController();
  static TextEditingController fssaiLicsenceTypeController = TextEditingController();
  static TextEditingController fssaiFirstNameController = TextEditingController();
  static TextEditingController fssaiAddressController = TextEditingController();


  static Uint8List? passbookImage;
  static Uint8List? panImage;
  static Uint8List? gstImage;
  static iFile.File? pickedPassbookImage;
  static iFile.File? pickedPankImage;
  static iFile.File? pickedGstImage;

  static Uint8List? webImage;
  static iFile.File? pickedImage;
}