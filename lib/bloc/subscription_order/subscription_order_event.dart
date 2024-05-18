import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';


@immutable
abstract class SubscriptionOrdersEvent extends Equatable{
  const SubscriptionOrdersEvent();
}

class LoadSubscriptionOrdersEvent extends SubscriptionOrdersEvent {
  @override
  List<Object?> get props =>  [];
}

class OrderStatusEvent extends LoadSubscriptionOrdersEvent{
  final List<Map<String,dynamic>> orderList;
  final List<Map<String,dynamic>> filteredList;
  final List<Map<String,dynamic>> closedList;
  final int index;
  final String status;
  final String ordId;
  OrderStatusEvent(this.orderList,this.closedList,this.filteredList,this.index, this.status, this.ordId,);
  @override
  List<Object?> get props =>  [];
}

class OrderCancelEvent extends LoadSubscriptionOrdersEvent{
  final List<Map<String,dynamic>> orderList;
  final List<Map<String,dynamic>> closedList;
  final int index;
  final String ordId;
  OrderCancelEvent(this.orderList,this.index, this.closedList, this.ordId,);
  @override
  List<Object?> get props =>  [];
}


class OrderCompleteEvent extends LoadSubscriptionOrdersEvent{
  final List<Map<String,dynamic>> orderList;
  final List<Map<String,dynamic>> closedList;
  final int index;
  final String ordId;
  OrderCompleteEvent( this.orderList, this.closedList,this.index, this.ordId,);
  @override
  List<Object?> get props =>  [];
}

class CancelAllEventSubscription extends LoadSubscriptionOrdersEvent {
  final List<Map<String,dynamic>> orderList;
  final List<Map<String,dynamic>> closedList;
  final List<Map<String,dynamic>> filterdList;
  CancelAllEventSubscription( this.orderList, this.closedList,this.filterdList,);
  @override
  List<Object?> get props =>  [];
}



