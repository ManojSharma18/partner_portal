import 'package:flutter/material.dart';
import 'package:partner_admin_portal/repository/order_service.dart';

import '../../models/order_model.dart';

class OrderVariables {

  static String selecteditem = "Idli";

  static bool isExpanded = false;

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

  static List<Map<String,dynamic>> inprogress = [];

  static List<Map<String,dynamic>> closed = [];

  static OrderService orderService =  OrderService();

  static List<Map<String, dynamic>> filteredOrders = [];

  static List<Map<String, dynamic>> filteredInprogressOrders = [];

  static List<Map<String, dynamic>> filteredClosedOrders = [];

  static TextEditingController totalController = TextEditingController(text: itemDetails[0]['total'].toString());
  static TextEditingController breakfastController = TextEditingController(text: itemDetails[0]['breakfast'].toString());
  static TextEditingController lunchController = TextEditingController(text: itemDetails[0]['lunch'].toString());
  static TextEditingController dinnerController = TextEditingController(text: itemDetails[0]['Dinner'].toString());

  static TextEditingController bs1Controller = TextEditingController(text: itemDetails[0]['bs1'].toString());
  static TextEditingController bs2Controller = TextEditingController(text: itemDetails[0]['bs2'].toString());
  static TextEditingController bs3Controller = TextEditingController(text: itemDetails[0]['bs3'].toString());
  static TextEditingController bs4Controller = TextEditingController(text: itemDetails[0]['bs4'].toString());
  static TextEditingController ls1Controller = TextEditingController(text: itemDetails[0]['ls1'].toString());
  static TextEditingController ls2Controller = TextEditingController(text: itemDetails[0]['ls2'].toString());
  static TextEditingController ls3Controller = TextEditingController(text: itemDetails[0]['ls3'].toString());
  static TextEditingController ls4Controller = TextEditingController(text: itemDetails[0]['ls4'].toString());
  static TextEditingController ds1Controller = TextEditingController(text: itemDetails[0]['ds1'].toString());
  static TextEditingController ds2Controller = TextEditingController(text: itemDetails[0]['ds2'].toString());
  static TextEditingController ds3Controller = TextEditingController(text: itemDetails[0]['ds3'].toString());
  static TextEditingController ds4Controller = TextEditingController(text: itemDetails[0]['ds4'].toString());

  static List<OrderModel> orders = [];

  static bool ascending = true;

  static bool isPickup = false;
  static bool isDeliver = false;
  static bool isDineIn = false;
}