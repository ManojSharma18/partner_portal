import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';


@immutable
abstract class MenuEditorState extends Equatable{}

class MenuEditorLoadingState extends MenuEditorState{
  MenuEditorLoadingState();
  @override
  List<Object?> get props => [];
}

class MenuEditorLoadedState extends MenuEditorState {
  final Set<String> selectedCategories;
  final Map<String, List<Map<String,dynamic>>> foodCategories;
  final String itemName;
  final Map<String,Map<String,Map<String,bool>>> daysMealSession;
  MenuEditorLoadedState(this.selectedCategories, this.foodCategories, this.itemName,this.daysMealSession);

  @override
  List<Object?> get props =>  [selectedCategories,foodCategories,itemName];
}

class MenuEditorTableState extends MenuEditorState {
  final Map<String,Map<String,Map<String,bool>>> daysMealSession;
  MenuEditorTableState(this.daysMealSession);

  @override
  List<Object?> get props =>  [daysMealSession];
}

class MenuEditorErrorState extends MenuEditorState {
  final String error;
  MenuEditorErrorState(this.error);

  @override
  List<Object?> get props =>  [error];
}



