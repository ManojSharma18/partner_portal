import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../models/live_menu_new_model.dart';
import '../../repository/live_menu_new_service.dart';

@immutable
abstract class LiveMenu1Event extends Equatable{
  const LiveMenu1Event();

}

class LoadLiveMenu1Event extends LiveMenu1Event {
  final BuildContext context;
  LoadLiveMenu1Event(this.context);
  @override
  List<Object?> get props =>  [];
}


class LiveMenuDateSelectEvent extends LiveMenu1Event {
  final String date;
  LiveMenuDateSelectEvent(this.date,);
  @override
  List<Object?> get props =>  [];
}

class LiveMenuBreakfastItemSelectEvent extends LiveMenu1Event {
  final Map<String, dynamic> menuItem;
  LiveMenuBreakfastItemSelectEvent(this.menuItem,);
  @override
  List<Object?> get props =>  [];
}

class LiveMenuLunchItemSelectEvent extends LiveMenu1Event {
  final Map<String, dynamic> menuItem;
  LiveMenuLunchItemSelectEvent(this.menuItem,);
  @override
  List<Object?> get props =>  [];
}

class LiveMenuDinnerItemSelectEvent extends LiveMenu1Event {
  final Map<String, dynamic> menuItem;
  LiveMenuDinnerItemSelectEvent(this.menuItem,);
  @override
  List<Object?> get props =>  [];
}


class LiveMenuAllItemSelectEvent extends LiveMenu1Event {
  final Map<String, dynamic> menuItem;
  LiveMenuAllItemSelectEvent(this.menuItem,);
  @override
  List<Object?> get props =>  [];
}

class SelectLiveMenuBreakfastCategoryEvent extends LiveMenu1Event {
  final Set<String> selectedCategories;
  final Map<String, List<Map<String,dynamic>>> foodCategories;
  final String categoryName;
  const SelectLiveMenuBreakfastCategoryEvent(this.selectedCategories,this.foodCategories,this.categoryName);
  @override
  List<Object?> get props =>  [];
}

class SelectLiveMenuLunchCategoryEvent extends LiveMenu1Event {
  final Set<String> selectedCategories;
  final Map<String, List<Map<String,dynamic>>> foodCategories;
  final String categoryName;
  const SelectLiveMenuLunchCategoryEvent(this.selectedCategories,this.foodCategories,this.categoryName);
  @override
  List<Object?> get props =>  [];
}


class SelectLiveMenuDinnerCategoryEvent extends LiveMenu1Event {
  final Set<String> selectedCategories;
  final Map<String, List<Map<String,dynamic>>> foodCategories;
  final String categoryName;
  const SelectLiveMenuDinnerCategoryEvent(this.selectedCategories,this.foodCategories,this.categoryName);
  @override
  List<Object?> get props =>  [];
}

class SelectLiveMenuAllCategoryEvent extends LiveMenu1Event {
  final Set<String> selectedCategories;
  final Map<String, List<Map<String,dynamic>>> foodCategories;
  final String categoryName;
  const SelectLiveMenuAllCategoryEvent(this.selectedCategories,this.foodCategories,this.categoryName);
  @override
  List<Object?> get props =>  [];
}

class DeleteItemEvent extends LiveMenu1Event {
  final Map<String,dynamic> data;
  final Map<String, List<Map<String,dynamic>>> foodCategories;
  final String tagName;
  final Map<String, dynamic> item;
  const DeleteItemEvent(this.data,this.foodCategories,this.tagName,this.item);
  @override
  List<Object?> get props =>  [];
}

class UpdateItemEvent extends LiveMenu1Event {
  final Map<String,dynamic> data;
  final Map<String, List<Map<String,dynamic>>> foodCategories;
  final String tagName;
  final Map<String, dynamic> item;
  const UpdateItemEvent(this.data,this.foodCategories,this.tagName,this.item);
  @override
  List<Object?> get props =>  [];
}

class AddLiveMenuItemEvent extends LiveMenu1Event {
  final List<LiveMenuNew> data;
  const AddLiveMenuItemEvent(this.data,);
  @override
  List<Object?> get props =>  [];
}


class AddLiveMenuItemFromLiveMenuEvent extends LiveMenu1Event {
  final List<LiveMenuNew> data;
  const AddLiveMenuItemFromLiveMenuEvent(this.data,);
  @override
  List<Object?> get props =>  [];
}

class UpdateLiveMenuItemEvent extends LiveMenu1Event {
  final List<LiveMenuNewSample> data;
  const UpdateLiveMenuItemEvent(this.data,);
  @override
  List<Object?> get props =>  [];
}







