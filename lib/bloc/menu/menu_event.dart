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

class LoadMenuConsumptionModeEvent extends MenuEvent {
  final BuildContext context;

  LoadMenuConsumptionModeEvent(this.context);
  @override
  List<Object?> get props =>  [];
}


class LoadTagsEvent extends MenuEvent {
  final BuildContext context;

  LoadTagsEvent(this.context);
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

class AddSectionEvent extends MenuEvent {
  final BuildContext context;
  final String tag;
  AddSectionEvent(this.context,this.tag);
  @override
  List<Object?> get props =>  [];
}

class AddItemsEvent extends MenuEvent {
  final Map<String, List<Map<String,dynamic>>> foodCategories;
  final BuildContext context;
  final String tagName;
  final BuildContext menuContext;
  AddItemsEvent(this.context,this.tagName,this.foodCategories,this.menuContext);
  @override
  List<Object?> get props =>  [];
}

class SearchItemsEvent extends MenuEvent {
  final Map<String, List<Map<String,dynamic>>> foodCategories;
  final BuildContext context;
  final String tagName;
  final BuildContext menuContext;
  final String query;
  SearchItemsEvent(this.context,this.tagName,this.foodCategories,this.menuContext,this.query);
  @override
  List<Object?> get props =>  [];
}

class AddCuisineEvent extends MenuEvent {
  final BuildContext context;
  final BuildContext menuContext;
  final String id;
  final String displayName;
  AddCuisineEvent(this.context,this.menuContext,this.id,this.displayName);
  @override
  List<Object?> get props =>  [];
}

class AddRegionalEvent extends MenuEvent {
  final BuildContext context;
  final BuildContext menuContext;
  final String id;
  final String displayName;
  AddRegionalEvent(this.context,this.menuContext,this.id,this.displayName);
  @override
  List<Object?> get props =>  [];
}

class AddSubcategoryEvent extends MenuEvent {
  final BuildContext context;
  final BuildContext menuContext;
  final String category;
  final String id;
  final String displayName;
  AddSubcategoryEvent(this.context,this.menuContext,this.category, this.id, this.displayName);
  @override
  List<Object?> get props =>  [];
}

class AddMenuItemEvent extends MenuEvent {
  final BuildContext context;
  final String displayName;
  final String tagName;
  final String itemAddType;
  AddMenuItemEvent(this.context,this.displayName,this.tagName,this.itemAddType);
  @override
  List<Object?> get props =>  [];
}

class UpdateItemSection extends MenuEvent {
  final BuildContext context;
  final String id;
  final String tagName;
  final String itemName;
  final String oldTag;
  final Map<String,dynamic> requestBody;
  Map<String, dynamic> oneItem;
  UpdateItemSection(this.context,this.id,this.tagName,this.itemName,this.requestBody,this.oldTag,this.oneItem);
  @override
  List<Object?> get props =>  [];
}

class ReplaceItemSection extends MenuEvent {
  final BuildContext context;
  final String currentId;
  final String id;
  final String tagName;
  final String itemName;
  final String oldTag;
  final Map<String,dynamic> requestBody;
  Map<String, dynamic> oneItem;
  ReplaceItemSection(this.context,this.id,this.tagName,this.itemName,this.requestBody,this.oldTag,this.oneItem, this.currentId);
  @override
  List<Object?> get props =>  [];
}

class UpdateItemAvailability extends MenuEvent {
  final BuildContext context;
  final String id;
  final String tagName;
  final String itemName;
  final bool available;
  final Map<String, dynamic> item;
  final Map<String, List<Map<String,dynamic>>> menuFoodCategory;
  UpdateItemAvailability(this.context,this.id,this.tagName,this.itemName,this.available,this.item,this.menuFoodCategory);
  @override
  List<Object?> get props =>  [];
}

class DeleteItemEvent extends MenuEvent {
  final BuildContext context;
  final String tagName;
  final Map<String, dynamic> item;
  final String id;
  DeleteItemEvent(this.context,this.id,this.tagName,this.item);
  @override
  List<Object?> get props =>  [];
}

class DeleteSectionEvent extends MenuEvent {
  final BuildContext context;
  final String tag;
  DeleteSectionEvent (this.context,this.tag);
  @override
  List<Object?> get props =>  [];
}

class ReplaceSectionEvent extends MenuEvent {
  final BuildContext context;
  final Map<String,dynamic> requestBody;
  final String tagName;
  ReplaceSectionEvent(this.context,this.tagName,this.requestBody);
  @override
  List<Object?> get props =>  [];
}

class UpdateTagNameEvent extends MenuEvent {
  final BuildContext context;
  final String oldTag;
  final String newTAg;
  UpdateTagNameEvent(this.context,this.oldTag,this.newTAg);
  @override
  List<Object?> get props =>  [];
}


class UpdateSectionAvailability extends MenuEvent {
  final BuildContext context;
  final String tagName;
  final bool availability;
  UpdateSectionAvailability(this.context,this.tagName,this.availability);
  @override
  List<Object?> get props =>  [];
}

class UpdateLiveMenuEvent extends MenuEvent {
  final BuildContext context;
  final String id;
  final Map<String,dynamic> requestBody;
  final String itemName;
  UpdateLiveMenuEvent(this.context,this.id,this.requestBody,this.itemName);
  @override
  List<Object?> get props =>  [];
}

class HandleVegEvent extends MenuEvent {
  final BuildContext context;
  final bool value;
  HandleVegEvent(this.context,this.value);
  @override
  List<Object?> get props =>  [];
}

class HandleNonVegEvent extends MenuEvent {
  final BuildContext context;
  final bool value;
  HandleNonVegEvent(this.context,this.value);
  @override
  List<Object?> get props =>  [];
}

class HandleFoodEvent extends MenuEvent {
  final BuildContext context;
  final bool value;
  HandleFoodEvent(this.context,this.value);
  @override
  List<Object?> get props =>  [];
}


class HandleBeverageEvent extends MenuEvent {
  final BuildContext context;
  final bool value;
  HandleBeverageEvent(this.context,this.value);
  @override
  List<Object?> get props =>  [];
}

class HandleBreakfastEvent extends MenuEvent {
  final BuildContext context;
  final bool value;
  HandleBreakfastEvent(this.context,this.value);
  @override
  List<Object?> get props =>  [];
}

class HandleLunchEvent extends MenuEvent {
  final BuildContext context;
  final bool value;
  HandleLunchEvent(this.context,this.value);
  @override
  List<Object?> get props =>  [];
}


class HandleDinnerEvent extends MenuEvent {
  final BuildContext context;
  final bool value;
  HandleDinnerEvent(this.context,this.value);
  @override
  List<Object?> get props =>  [];
}

class HandleBudgetEvent extends MenuEvent {
  final BuildContext context;
  final bool value;
  HandleBudgetEvent(this.context,this.value);
  @override
  List<Object?> get props =>  [];
}

class HandlePocketFriendlyEvent extends MenuEvent {
  final BuildContext context;
  final bool value;
  HandlePocketFriendlyEvent(this.context,this.value);
  @override
  List<Object?> get props =>  [];
}

class HandlePremiumEvent extends MenuEvent {
  final BuildContext context;
  final bool value;
  HandlePremiumEvent(this.context,this.value);
  @override
  List<Object?> get props =>  [];
}

class HandleLuxuryEvent extends MenuEvent {
  final BuildContext context;
  final bool value;
  HandleLuxuryEvent(this.context,this.value);
  @override
  List<Object?> get props =>  [];
}



