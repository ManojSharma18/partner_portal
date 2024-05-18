
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:partner_admin_portal/models/order_model.dart';

@immutable
abstract class OrdersState extends Equatable{}

class OrdersLoadingState extends OrdersState{
  final List<OrderModel>? orders;
  final List<Map<String,dynamic>>? ordersList;
  final List<Map<String,dynamic>>? inprogressList;
  final List<Map<String,dynamic>>? closedList;
  OrdersLoadingState({this.orders, this.ordersList,this.inprogressList,this.closedList});
  @override
  List<Object?> get props => [orders,ordersList,inprogressList,closedList];
}

class OrdersLoadedState extends OrdersState {
  final List<OrderModel> orders;
  final List<Map<String,dynamic>> ordersList;
  final List<Map<String,dynamic>> inprogressList;
  final List<Map<String,dynamic>> closedList;
  OrdersLoadedState(this.orders,this.ordersList,this.inprogressList,this.closedList);

  @override
  List<Object?> get props =>  [];
}

class OrderErrorState extends OrdersState{
  final String error;
  OrderErrorState(this.error);

  @override
  List<Object?> get props =>  [error];
}
