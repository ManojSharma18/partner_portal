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

class AddMenuItemEvent extends MenuEvent {
  final BuildContext context;
  final String displayName;
  final String tagName;
  AddMenuItemEvent(this.context,this.displayName,this.tagName);
  @override
  List<Object?> get props =>  [];
}

class UpdateItemSection extends MenuEvent {
  final BuildContext context;
  final String id;
  final String tagName;
  final String itemName;
  UpdateItemSection(this.context,this.id,this.tagName,this.itemName);
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
  final String id;
  DeleteItemEvent(this.context,this.id);
  @override
  List<Object?> get props =>  [];
}

class ReplaceSectionEvent extends MenuEvent {
  final BuildContext context;
  final String tagName;
  ReplaceSectionEvent(this.context,this.tagName);
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

