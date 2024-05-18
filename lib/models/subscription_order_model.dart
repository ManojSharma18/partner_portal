import 'dart:convert';

import 'order_model.dart';

class SubscriptionOrderModel {
  String? id;
  final String fpUnitFordId;
  final String fpUnitName;
  final String fpUnitFordDate;
  final String fpUnitFordTime;
  final String cUid;
  final String cMobNo;
  final double fpUnitFordAmt;
  final String fpUnitFordStatus;
  final String dName;
  final List<OrderItemModel> fpUnitFordItems;
  final String fpUnitFordCMode;
  final String fpUnitFordMeal;
  final String fpUnitForBtype;
  final String fpUnitFordMealSession;
  final String fpUnitFordType;

  SubscriptionOrderModel({
    required this.fpUnitFordId,
    required this.fpUnitName,
    required this.fpUnitFordDate,
    required this.fpUnitFordTime,
    required this.cUid,
    required this.cMobNo,
    required this.fpUnitFordAmt,
    required this.fpUnitFordStatus,
    required this.dName,
    required this.fpUnitFordItems,
    required this.fpUnitFordCMode,
    required this.fpUnitFordMeal,
    required this.fpUnitFordMealSession,
    required this.fpUnitFordType,
    required this.fpUnitForBtype,
    this.id
  });

  factory SubscriptionOrderModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionOrderModel(
      id: map['_id'],
      fpUnitForBtype: map['fp_unit_ford_btype'],
      fpUnitFordId: map['fp_unit_ford_id'],
      fpUnitName: map['fp_unit_name'],
      fpUnitFordDate: map['fp_unit_ford_date'],
      fpUnitFordTime: map['fp_unit_ford_time'],
      cUid: map['c_uid'],
      cMobNo: map['c_mobno'],
      fpUnitFordAmt: map['fp_unit_ford_amt'].toDouble(),
      fpUnitFordStatus: map['fp_unit_ford_status'],
      dName: map['d_name'],
      fpUnitFordItems: List<OrderItemModel>.from(map['fp_unit_ford_items']
          .map((item) => OrderItemModel.fromMap(item))),
      fpUnitFordCMode: map['fp_unit_ford_cmode'],
      fpUnitFordMeal: map['fp_unit_ford_meal'],
      fpUnitFordMealSession: map['fp_unit_ford_meal_Session'],
      fpUnitFordType: map['fp_unit_ford_type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fp_unit_ford_btype':fpUnitForBtype,
      '_id': id,
      'fp_unit_ford_id': fpUnitFordId,
      'fp_unit_name': fpUnitName,
      'fp_unit_ford_date': fpUnitFordDate,
      'fp_unit_ford_time': fpUnitFordTime,
      'c_uid': cUid,
      'c_mobno': cMobNo,
      'fp_unit_ford_amt': fpUnitFordAmt,
      'fp_unit_ford_status': fpUnitFordStatus,
      'd_name': dName,
      'fp_unit_ford_items': fpUnitFordItems.map((item) => item.toMap()).toList(),
      'fp_unit_ford_cmode': fpUnitFordCMode,
      'fp_unit_ford_meal': fpUnitFordMeal,
      'fp_unit_ford_meal_Session': fpUnitFordMealSession,
      'fp_unit_ford_type': fpUnitFordType,
    };
  }

  factory SubscriptionOrderModel.fromJson(String jsonString) {
    return SubscriptionOrderModel.fromMap(json.decode(jsonString));
  }

  String toJson() {
    return json.encode(toMap());
  }
}


