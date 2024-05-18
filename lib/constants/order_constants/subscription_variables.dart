import 'package:flutter/material.dart';
import 'package:partner_admin_portal/models/subscription_order_model.dart';

class SubscriptionVariables{

  static List<Map<String,dynamic>> inprogress = [];

  static List<Map<String,dynamic>> closed = [];

  static List<Map<String,dynamic>> orders = [];

  static bool loadFirstTime = true;

  static List<SubscriptionOrderModel> subscriptionOrders = [];

  static List<Map<String, dynamic>> filteredInprogressOrders = [];

  static List<Map<String, dynamic>> filteredClosedOrders = [];

}