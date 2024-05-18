import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';


@immutable
abstract class MenuEvent extends Equatable{
  const MenuEvent();
}

class LoadMenuEvent extends MenuEvent {
  final BuildContext context;

  LoadMenuEvent(this.context);
  @override
  List<Object?> get props =>  [];
}

class ItemSelectEvent extends MenuEvent {
  final Map<String, dynamic> item;
  ItemSelectEvent(this.item,);
  @override
  List<Object?> get props =>  [];
}

class MenuItemSelectEvent extends MenuEvent {
  final Map<String, dynamic> menuItem;
  MenuItemSelectEvent(this.menuItem,);
  @override
  List<Object?> get props =>  [];
}

class MenuDateSelectEvent extends MenuEvent {
  final String date;
  MenuDateSelectEvent(this.date,);
  @override
  List<Object?> get props =>  [];
}


