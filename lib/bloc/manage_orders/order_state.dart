import 'package:equatable/equatable.dart';
import 'package:partner_admin_portal/constants/global_function.dart';
import 'package:partner_admin_portal/widgets/orders/manage/manage_orderes.dart';

import '../../widgets/menu/live_menu/live_menu.dart';

class OrderState extends Equatable {
  final bool active;
  final MealTime? mealTime;
  final MealSession? mealSession;
  final InProgress? inProgress;
  final Closed? closed;
  final Orders? orders;
  final Amount? amount;
  final Subsciption? subsciption;
  final int? index;
  final List<Map<String, dynamic>> orderList;
  final List<Map<String, dynamic>> inProgressList;
  final List<Map<String, dynamic>> closedList;
  final List<Map<String, dynamic>>? filterList;
  final String? status;
  final String? ordId;
  final String? searchQuery;

  const OrderState( {
    required this.active,
    this.mealTime,
    this.mealSession,
    this.inProgress,
    this.closed,
    this.orders,
    this.amount,
    required this.orderList,
    this.index,
    required this.closedList,
    required this.inProgressList,
    this.status,
    this.subsciption,
    this.searchQuery,
    this.ordId,
    this.filterList
  });

  @override
  List<Object?> get props =>
      [active, mealTime, mealSession, inProgress, closed, amount, orders, orderList, index, inProgressList, closedList, status, searchQuery, filterList,subsciption,ordId];

  OrderState copyWith({
    bool? active,
    MealTime? mealTime,
    MealSession? mealSession,
    InProgress? inProgress,
    Closed? closed,
    Orders? orders,
    Amount? amount,
    List<Map<String, dynamic>>? orderList,
    final List<Map<String, dynamic>>? inProgressList,
    final List<Map<String,dynamic>>? closedList,
    final List<Map<String,dynamic>>? filterList,
    String? status,
    int? index,
    String? ordId,
    String? searchQuery,

  }) {
    return OrderState(
      active: active ?? this.active,
      mealTime: mealTime ?? this.mealTime,
      mealSession: mealSession ?? this.mealSession,
      inProgress: inProgress ?? this.inProgress,
      closed: closed ?? this.closed,
      orders: orders ?? this.orders,
      amount: amount ?? this.amount,
      orderList: orderList ?? this.orderList,
      index: index ?? this.index,
      inProgressList: inProgressList ?? this.inProgressList,
      closedList: closedList ?? this.closedList,
        status: status ?? this.status,
      searchQuery: searchQuery ?? this.searchQuery,
      filterList: filterList ?? this.filterList,
      ordId: ordId ?? this.ordId
    );
  }
}

