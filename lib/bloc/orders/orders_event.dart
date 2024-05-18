import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';


@immutable
abstract class OrdersEvent extends Equatable{
  const OrdersEvent();
}

class LoadOrdersEvent extends OrdersEvent {
  @override
  List<Object?> get props =>  [];
}

class OrdersStatusEvent extends OrdersEvent {
  final List<Map<String,dynamic>> ordersList;
  final List<Map<String,dynamic>> inprogressList;
  final List<Map<String,dynamic>> closedList;
  final List<Map<String,dynamic>> filteredList;
  final int index;
  final String status;
  final String ordId;
  OrdersStatusEvent(this.ordersList,this.inprogressList,this.closedList,this.filteredList,this.index, this.status, this.ordId,);
  @override
  List<Object?> get props =>  [];
}

class OrdersCompleteEvent extends OrdersEvent {
  final List<Map<String,dynamic>> ordersList;
  final List<Map<String,dynamic>> inprogressList;
  final List<Map<String,dynamic>> closedList;
  final List<Map<String,dynamic>> filterList;
  final int index;
  final String ordId;
  OrdersCompleteEvent(this.ordersList, this.inprogressList, this.closedList, this.filterList,this.index,this.ordId);
  @override
  List<Object?> get props =>  [];
}

class OrdersAcceptEvent extends OrdersEvent {
  final List<Map<String,dynamic>> orderList;
  final List<Map<String,dynamic>> inProgressList;
  final List<Map<String,dynamic>> closedList;
  final int index;
  final String ordId;
  OrdersAcceptEvent(this.orderList,this.inProgressList,this.closedList,this.index, this.ordId);
  @override
  List<Object?> get props =>  [];
}

class OrdersRejectEvent extends OrdersEvent {
  final bool? isOrderList;
  final List<Map<String,dynamic>> orderList;
  final List<Map<String,dynamic>> inProgressList;
  final List<Map<String,dynamic>> closedList;
  final int index;
  final String ordId;
  OrdersRejectEvent(this.orderList, this.inProgressList, this.index, this.closedList, this.ordId, {this.isOrderList = true});

  @override
  List<Object?> get props =>  [];
}

class OrdersCancelEvent extends OrdersEvent {
  final List<Map<String,dynamic>> ordersList;
  final List<Map<String,dynamic>> inProgressList;
  final List<Map<String,dynamic>> closedList;
  final int index;
  final String ordId;
  OrdersCancelEvent(this.ordersList,this.inProgressList, this.index, this.closedList, this.ordId,);

  @override
  List<Object?> get props =>  [];
}

class CancelAllOrderEvent extends OrdersEvent {
  final List<Map<String,dynamic>> ordersList;
  final List<Map<String,dynamic>> inProgressList;
  final List<Map<String,dynamic>> closedList;
  final List<Map<String,dynamic>> filterdList;
  CancelAllOrderEvent(this.ordersList,this.inProgressList,this.closedList,this.filterdList);
  @override
  List<Object?> get props =>  [];
}



