import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:partner_admin_portal/constants/utils.dart';

import '../models/live_menu_model.dart';
import '../models/restaurant_menu.dart';

final String apiUrl = 'http://slys.in:4000';

class GlobalVariables {
  static const primaryColor =  Color(0xfffbb830);
  static const textColor =  Color(0xFF363563);
  static const whiteColor = Color(0xffffffff);
  static  Color lightColor = Color(0xFF363563).withOpacity(0.07);

  static final headingStyle = SafeGoogleFont(
    'Poppins',
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: GlobalVariables.primaryColor,
  );

  static final dataItemStyle = SafeGoogleFont(
    'Poppins',
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: GlobalVariables.textColor,
  );

  static bool isOpend = true;

  static TabController getSubscriptionTabController() {
    return TabController(length: 2, vsync: _FakeTickerProvider());
  }

  static List<Map<String,dynamic>> orders = [ ];

  static bool loadFirstTime = true;

  static List<Map<String,dynamic>> inprogress = [];

  static List<Map<String,dynamic>> closed = [];

  static List<Map<String,dynamic>> canceled = [];

  static String order = "Order";

  static List<Map<String,dynamic>> itemDetails = [
    {"name" : "Idli", "total" : 400,"breakfast" : 200, "lunch" : 100,"Dinner" : 100,'bs1' : 50,'bs2' : 50, 'bs3' : 50, 'bs4' : 50,'ls1' : 50,'ls2' : 50, 'ls3' : 50, 'ls4' : 50,'ds1' : 25,'ds2' : 25, 'ds3' : 25, 'ds4' : 25},
    {"name" : "Dosa", "total" : 300,"breakfast" : 100, "lunch" : 100,"Dinner" : 100,'bs1' : 50,'bs2' : 50, 'bs3' : 50, 'bs4' : 50,'ls1' : 50,'ls2' : 50, 'ls3' : 50, 'ls4' : 50,'ds1' : 25,'ds2' : 25, 'ds3' : 25, 'ds4' : 25},
    {"name" : "Palav", "total" : 200,"breakfast" : 100, "lunch" : 100,"Dinner" : 0,'bs1' : 50,'bs2' : 50, 'bs3' : 50, 'bs4' : 50,'ls1' : 50,'ls2' : 50, 'ls3' : 50, 'ls4' : 50,'ds1' : 25,'ds2' : 25, 'ds3' : 25, 'ds4' : 25},
    {"name" : "Poori", "total" : 400,"breakfast" : 200, "lunch" : 100,"Dinner" : 100,'bs1' : 50,'bs2' : 50, 'bs3' : 50, 'bs4' : 50,'ls1' : 50,'ls2' : 50, 'ls3' : 50, 'ls4' : 50,'ds1' : 25,'ds2' : 25, 'ds3' : 25, 'ds4' : 25},
    {"name" : "Puliyogare", "total" : 100,"breakfast" : 40, "lunch" : 40,"Dinner" : 20,'bs1' : 50,'bs2' : 50, 'bs3' : 50, 'bs4' : 50,'ls1' : 50,'ls2' : 50, 'ls3' : 50, 'ls4' : 50,'ds1' : 25,'ds2' : 25, 'ds3' : 25, 'ds4' : 25},
    {"name" : "Decadent Chocolate Fudge Brownie Sundae", "total" : 400,"breakfast" : 200, "lunch" : 100,"Dinner" : 100,'bs1' : 50,'bs2' : 50, 'bs3' : 50, 'bs4' : 50,'ls1' : 50,'ls2' : 50, 'ls3' : 50, 'ls4' : 50,'ds1' : 25,'ds2' : 25, 'ds3' : 25, 'ds4' : 25},
    {"name" : "Crispy Honey Glazed Salmon Fillet", "total" : 300,"breakfast" : 100, "lunch" : 100,"Dinner" : 100,'bs1' : 50,'bs2' : 50, 'bs3' : 50, 'bs4' : 50,'ls1' : 50,'ls2' : 50, 'ls3' : 50, 'ls4' : 50,'ds1' : 25,'ds2' : 25, 'ds3' : 25, 'ds4' : 25},
    {"name" : "Delectable Southern Style Buttermilk Fried Chicken", "total" : 200,"breakfast" : 100, "lunch" : 100,"Dinner" : 0,'bs1' : 50,'bs2' : 50, 'bs3' : 50, 'bs4' : 50,'ls1' : 50,'ls2' : 50, 'ls3' : 50, 'ls4' : 50,'ds1' : 25,'ds2' : 25, 'ds3' : 25, 'ds4' : 25},
    {"name" : "Chole bature", "total" : 400,"breakfast" : 200, "lunch" : 100,"Dinner" : 100,'bs1' : 50,'bs2' : 50, 'bs3' : 50, 'bs4' : 50,'ls1' : 50,'ls2' : 50, 'ls3' : 50, 'ls4' : 50,'ds1' : 25,'ds2' : 25, 'ds3' : 25, 'ds4' : 25},
    {"name" : "Kesari bath", "total" : 100,"breakfast" : 40, "lunch" : 40,"Dinner" : 20,'bs1' : 50,'bs2' : 50, 'bs3' : 50, 'bs4' : 50,'ls1' : 50,'ls2' : 50, 'ls3' : 50, 'ls4' : 50,'ds1' : 25,'ds2' : 25, 'ds3' : 25, 'ds4' : 25}
  ];

  static List<Mymenu> totalFoodItems = [];

  static List<LiveMenuModel> totalLiveMenuItems = [];

  static List<double> rowHeights = List.filled(GlobalVariables.totalFoodItems.length, 85.0);


}


class _FakeTickerProvider extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}