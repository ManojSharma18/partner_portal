import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:partner_admin_portal/constants/utils.dart';

import '../widgets/small_custom_textfield.dart';

class GlobalVariables {
  static const primaryColor =  Color(0xfffbb830);
  static const textColor =  Color(0xFF363563);
  static const whiteColor = Color(0xffffffff);

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

  static List<Map<String,dynamic>> orders = [
    {
      "Id" : "KAA104122300001",
      "Restaurant" : "Keralapura Milrti Hotel",
      "Date" : "04 Jun 2023",
      "Time" : "8:02 PM",
      "CustomerName" : "Manoj",
      "number" : "8431944706",
      "Amount" : 353.00,
      "Status" : "Start",
      "dname" : "Prajwal",
      "budgetType" : "Pocket friendly",
      "Items": [
        {"itemName": "Decadent Chocolate Fudge Brownie Sundae", "count": 3, "price": 150},
        {"itemName": "Crispy Honey Glazed Salmon Fillet", "count": 2, "price": 110},
        {"itemName": "Delectable Southern Style Buttermilk Fried Chicken", "count": 2, "price": 100},
        {"itemName": "Vada", "count": 5, "price":200},
        {"itemName": "Palav", "count": 2, "price": 100},
        {"itemName": "Mosaranna", "count": 1, "price": 50},
        {"itemName": "Puliyogare", "count": 2, "price": 100},
        {"itemName": "kali dosa", "count": 3, "price": 100},
      ],
      "Expand" : false,
      "Type" : "Deliver",
      "Address" : "Home",
      "rating" :  0,
      "order" : "PreOrder",
    },
    {
      "Id" : "KAA104122300002",
      "Restaurant" : "Keralapura Milrti Hotel",
      "Date" : "04 Jun 2023",
      "Time" : "8:07 PM",
      "CustomerName" : "Anusha",
      "number" : "9353425719",
      "budgetType" : "Budget",
      "Amount" : 353.00,
      "Status" : "Start",
      "dname" : "Shashank",
      "Items": [
        {"itemName": "Masala Dosa", "count": 3, "price": 150},
        {"itemName": "Rava Idli", "count": 2, "price": 110},
        {"itemName": "Set Dosa", "count": 2, "price": 100},
        {"itemName": "Vada", "count": 5, "price":200},
        {"itemName": "Palav", "count": 2, "price": 100},
        {"itemName": "Mosaranna", "count": 1, "price": 50},

      ],
      "Expand" : false,
      "Type" : "Pick up",
      "Address" : "Work",
      "rating" :  0,
      "order" : "Subcription",
    },
    {
      "Id" : "KAA104122300003",
      "Restaurant" : "Keralapura Milrti Hotel",
      "Date" : "04 Jun 2023",
      "Time" : "8:15 PM",
      "number" : "8105445911",
      "budgetType" : "Premium",
      "Amount" : 353.00,
      "CustomerName" : "krishna",
      "Status" : "Start",
      "Items": [
        {"itemName": "Vada", "count": 5, "price":200},
        {"itemName": "Palav", "count": 2, "price": 100},
        {"itemName": "Mosaranna", "count": 1, "price": 50},
        {"itemName": "Puliyogare", "count": 2, "price": 100},
        {"itemName": "kali dosa", "count": 3, "price": 100},
      ],
      "Expand" : false,
      "dname" : "Shamanth",
      "Type" : "Dine in",
      "Address" : "Home",
      "rating" :  0,
      "order" : "Subscription",
    },
    {
      "Id" : "KAA104122300004",
      "Restaurant" : "Keralapura Milrti Hotel",
      "Date" : "04 Jun 2023",
      "Time" : "8:18 PM",
      "Amount" : 353.00,
      "number" : "944292368",
      "budgetType" : "Premium",
      "CustomerName" : "Kumari",
      "Status" : "Start",
      "Items": [
        {"itemName": "Rava Idli", "count": 2, "price": 110},
        {"itemName": "Set Dosa", "count": 2, "price": 100},
        {"itemName": "Vada", "count": 5, "price":200},
        {"itemName": "Palav", "count": 2, "price": 100},
        {"itemName": "Mosaranna", "count": 1, "price": 50},
        {"itemName": "Puliyogare", "count": 2, "price": 100},
        {"itemName": "kali dosa", "count": 3, "price": 100},
      ],
      "Expand" : false,
      "dname" : "Usman",
      "Type" : "Deliver",
      "Address" : "Work",
      "rating" :  0,
      "order" : "PreOrder",
    },
    {
      "Id" : "KAA104122300005",
      "Restaurant" : "Keralapura Milrti Hotel",
      "Date" : "04 Jun 2023",
      "Time" : "8:24 PM",
      "number" : "9980859042",
      "CustomerName" : "Deepak",
      "Amount" : 353.00,
      "Status" : "Start",
      "budgetType" : "Luxury",
      "Items": [
        {"itemName": "Palav", "count": 2, "price": 100},
        {"itemName": "Mosaranna", "count": 1, "price": 50},
        {"itemName": "Puliyogare", "count": 2, "price": 100},
        {"itemName": "kali dosa", "count": 3, "price": 100},
      ],
      "Expand" : false,
      "dname" : "Sachin",
      "Type" : "Pick up",
      "Address" : "Home",
      "rating" :  0,
      "order" : "Subscription",
    },
    {
      "Id" : "KAA104122300006",
      "Restaurant" : "Keralapura Milrti Hotel",
      "Date" : "04 Jun 2023",
      "Time" : "8:29 PM",
      "number" : "7204339914",
      "Amount" : 353.00,
      "Status" : "Start",
      "budgetType" : "Pocket friendly",
      "dname" : "Prajwal",
      "CustomerName" : "Divya",
      "Items": [
        {"itemName": "Mosaranna", "count": 1, "price": 50},
        {"itemName": "Puliyogare", "count": 2, "price": 100},
        {"itemName": "kali dosa", "count": 3, "price": 100},
      ],
      "Expand" : false,
      "Type" : "Dine in",
      "Address" : "Home",
      "rating" :  0,
      "order" : "PreOrder",
    },
    {
      "Id" : "KAA104122300007",
      "Restaurant" : "Keralapura Milrti Hotel",
      "Date" : "04 Jun 2023",
      "Time" : "8:43 PM",
      "Amount" : 353.00,
      "number" : "95293580982",
      "Status" : "Start",
      "CustomerName" : "Shilpa",
      "budgetType" : "Pocket friendly",
      "dname" : "Shashank",
      "Items": [

        {"itemName": "Mosaranna", "count": 1, "price": 50},
      ],
      "Expand" : false,
      "Type" : "Pick up",
      "Address" : "Work",
      "rating" :  0,
      "order" : "Subcription",
    },
    {
      "Id" : "KAA104122300008",
      "Restaurant" : "Keralapura Milrti Hotel",
      "Date" : "04 Jun 2023",
      "number" : "9392038940",
      "Time" : "8:57 PM",
      "Amount" : 353.00,
      "Status" : "Start",
      "budgetType" : "Budget",
      "CustomerName" : "Bharath",
      "Items": [
        {"itemName": "Masala Dosa", "count": 3, "price": 150},
        {"itemName": "Rava Idli", "count": 2, "price": 110}
      ],
      "Expand" : false,
      "dname" : "Shamanth",
      "Type" : "Dine in",
      "Address" : "Home",
      "rating" :  0,
      "order" : "Subscription",
    },
    {
      "Id" : "KAA104122300009",
      "Restaurant" : "Keralapura Milrti Hotel",
      "Date" : "04 Jun 2023",
      "Time" : "9:00 PM",
      "number" : "8927239028",
      "budgetType" : "Premium",
      "Amount" : 353.00,
      "Status" : "Start",
      "CustomerName" : "Gowtham",
      "Items": [
        {"itemName": "Masala Dosa", "count": 3, "price": 150},
        {"itemName": "Rava Idli", "count": 2, "price": 110},
        {"itemName": "Set Dosa", "count": 2, "price": 100},
        {"itemName": "Vada", "count": 5, "price":200},
        {"itemName": "Palav", "count": 2, "price": 100},
        {"itemName": "Mosaranna", "count": 1, "price": 50},
        {"itemName": "Puliyogare", "count": 2, "price": 100},
        {"itemName": "kali dosa", "count": 3, "price": 100},
      ],
      "Expand" : false,
      "dname" : "Usman",
      "Type" : "Deliver",
      "Address" : "Work",
      "rating" :  0,
      "order" : "PreOrder",
    },
  ];

  static List<Map<String,dynamic>> inprogress = [];

  static List<Map<String,dynamic>> closed = [];


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

  static List<double> rowHeights = List.filled(GlobalVariables.itemDetails.length, 70.0);




}


class _FakeTickerProvider extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}