
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:partner_admin_portal/models/order_model.dart';
import 'package:partner_admin_portal/models/subscription_order_model.dart';

@immutable
abstract class SubscriptionOrdersState extends Equatable{}

class SubscriptionOrdersLoadingState extends SubscriptionOrdersState {
  final List<SubscriptionOrderModel>? orders;
  final List<Map<String,dynamic>>? ordersList;
  final List<Map<String,dynamic>>? closedList;
  SubscriptionOrdersLoadingState({this.orders, this.ordersList, this.closedList});
  @override
  List<Object?> get props => [orders,ordersList,closedList];
}

class SubscriptionOrdersLoadedState extends SubscriptionOrdersState {
  final List<SubscriptionOrderModel> orders;
  final List<Map<String,dynamic>> ordersList;
  final List<Map<String,dynamic>> closedList;
  SubscriptionOrdersLoadedState(this.orders, this.ordersList, this.closedList);

  @override
  List<Object?> get props =>  [orders,ordersList,closedList];
}

class ErrorState extends SubscriptionOrdersState{
  final String error;
  ErrorState(this.error);

  @override
  List<Object?> get props =>  [error];
}

