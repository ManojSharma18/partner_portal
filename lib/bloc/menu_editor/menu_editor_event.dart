import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';


@immutable
abstract class MenuEditorEvent extends Equatable{
  const MenuEditorEvent();
}

class LoadMenuEditorEvent extends MenuEditorEvent {
  @override
  List<Object?> get props =>  [];
}

class SelectMenuCategoryEvent extends MenuEditorEvent {
  final Set<String> selectedCategories;
  final Map<String, List<Map<String,dynamic>>> foodCategories;
  final String categoryName;
  const SelectMenuCategoryEvent(this.selectedCategories,this.foodCategories,this.categoryName);
  @override
  List<Object?> get props =>  [];
}

class SelectAllDaysEvent extends MenuEditorEvent {
  final Set<String> selectedCategories;
  final Map<String, List<Map<String,dynamic>>> foodCategories;
  final String categoryName;
  final Map<String,Map<String,Map<String,bool>>> daysMealSession;
  final bool val;
   SelectAllDaysEvent(this.selectedCategories,this.foodCategories,this.categoryName,this.daysMealSession,this.val);
  @override
  List<Object?> get props =>  [];
}

class SelectMealsEvent extends MenuEditorEvent {
  final Set<String> selectedCategories;
  final Map<String, List<Map<String,dynamic>>> foodCategories;
  final String categoryName;
  final Map<String,Map<String,Map<String,bool>>> daysMealSession;
  final String meal;
  final bool val;
  SelectMealsEvent(this.selectedCategories,this.foodCategories,this.categoryName,this.daysMealSession,this.meal,this.val);
  @override
  List<Object?> get props =>  [];
}

class SelectSingleDayEvent extends MenuEditorEvent {
  final Set<String> selectedCategories;
  final Map<String, List<Map<String,dynamic>>> foodCategories;
  final String categoryName;
  final Map<String,Map<String,Map<String,bool>>> daysMealSession;
  final String d;
  final bool val;
  SelectSingleDayEvent(this.selectedCategories,this.foodCategories,this.categoryName,this.daysMealSession,this.d,this.val);
  @override
  List<Object?> get props =>  [];
}

class SelectAllDaysSubEvent extends MenuEditorEvent {
  final Set<String> selectedCategories;
  final Map<String, List<Map<String,dynamic>>> foodCategories;
  final String categoryName;
  final Map<String,Map<String,Map<String,bool>>> daysMealSession;
  final bool val;
  SelectAllDaysSubEvent(this.selectedCategories,this.foodCategories,this.categoryName,this.daysMealSession,this.val);
  @override
  List<Object?> get props =>  [];
}

class SelectMealsSubEvent extends MenuEditorEvent {
  final Set<String> selectedCategories;
  final Map<String, List<Map<String,dynamic>>> foodCategories;
  final String categoryName;
  final Map<String,Map<String,Map<String,bool>>> daysMealSession;
  final String meal;
  final bool val;
  SelectMealsSubEvent(this.selectedCategories,this.foodCategories,this.categoryName,this.daysMealSession,this.meal,this.val);
  @override
  List<Object?> get props =>  [];
}

class SelectSingleDaySubEvent extends MenuEditorEvent {
  final Set<String> selectedCategories;
  final Map<String, List<Map<String,dynamic>>> foodCategories;
  final String categoryName;
  final Map<String,Map<String,Map<String,bool>>> daysMealSession;
  final String d;
  final bool val;
  SelectSingleDaySubEvent(this.selectedCategories,this.foodCategories,this.categoryName,this.daysMealSession,this.d,this.val);
  @override
  List<Object?> get props =>  [];
}
