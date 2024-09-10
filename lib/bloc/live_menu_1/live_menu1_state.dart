import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:partner_admin_portal/models/live_menu_model.dart';

import '../../models/restaurant_menu.dart';


@immutable
abstract class LiveMenu1State extends Equatable{}

class LiveMenu1LoadingState extends LiveMenu1State {
  LiveMenu1LoadingState();
  @override
  List<Object?> get props => [];
}

class LiveMenu1LoadedState extends LiveMenu1State {
  final Set<String> selectedCategoriesBreakfast;
  final Set<String> selectedCategoriesLunch;
  final Set<String> selectedCategoriesDinner;
  final Set<String> selectedCategoriesAll;
  final List<LiveMenuModel> menus;
  final List<LiveMenuModel> liveMenu;
  final Map<String, List<Map<String,dynamic>>> foodCategoryBreakfast;
  final Map<String, List<Map<String,dynamic>>> foodCategoryLunch;
  final Map<String, List<Map<String,dynamic>>> foodCategoryDinner;
  final Map<String, List<Map<String,dynamic>>> foodCategoryAll;
  final Map<String, dynamic> menuItemBreakfast;
  final Map<String, dynamic> menuItemLunch;
  final Map<String, dynamic> menuItemDinner;
  final Map<String, dynamic> menuItemAll;
  LiveMenu1LoadedState(
      this.selectedCategoriesBreakfast,
      this.selectedCategoriesLunch,
      this.selectedCategoriesDinner,
      this.selectedCategoriesAll,
      this.menus,this.liveMenu,
      this.foodCategoryBreakfast,
      this.foodCategoryLunch,
      this.foodCategoryDinner,
      this.foodCategoryAll,
      this.menuItemBreakfast,
      this.menuItemLunch,
      this.menuItemDinner,
      this.menuItemAll
      );

  @override
  List<Object?> get props =>  [selectedCategoriesLunch,selectedCategoriesBreakfast,selectedCategoriesDinner,selectedCategoriesAll,menus,liveMenu,foodCategoryBreakfast,foodCategoryLunch,foodCategoryDinner,foodCategoryAll,menuItemBreakfast,menuItemLunch,menuItemDinner,menuItemAll];
}


class LiveMenu1ErrorState extends LiveMenu1State {
  final String error;
  LiveMenu1ErrorState(this.error);

  @override
  List<Object?> get props =>  [error];
}



