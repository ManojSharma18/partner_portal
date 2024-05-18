
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:partner_admin_portal/models/restaurant_menu.dart';

import '../../models/live_menu_model.dart';

@immutable
abstract class MenuState extends Equatable{}

class MenuLoadingState extends MenuState{
  @override
  List<Object?> get props => [];
}

class MenuLoadedState extends MenuState{
  final List<Mymenu> menus;
  final List<Mymenu> liveMenu;
  final Map<String, List<Map<String,dynamic>>> foodCategory;
  final Map<String, dynamic> item;
  final Map<String, List<Map<String,dynamic>>> menuFoodCategory;
  final Map<String, dynamic> menuItem;
  MenuLoadedState(this.menus,this.liveMenu,this.foodCategory,this.item, this.menuFoodCategory, this.menuItem);

  @override
  List<Object?> get props =>  [menus,foodCategory,item,menuFoodCategory,menuItem];
}

class ErrorState extends MenuState{
  final String error;
  ErrorState(this.error);

  @override
  List<Object?> get props =>  [error];
}

