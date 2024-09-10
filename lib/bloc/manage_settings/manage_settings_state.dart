import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';


@immutable
abstract class ManageSettingState extends Equatable{}

class ManageSettingsLoadingState extends ManageSettingState{
  ManageSettingsLoadingState();
  @override
  List<Object?> get props => [];
}

class ManageSettingsLoadedState extends ManageSettingState {
  final String restaurantModel;
  ManageSettingsLoadedState(this.restaurantModel);

  @override
  List<Object?> get props =>  [];
}


class ManageSettingsErrorState extends ManageSettingState {
  final String error;
  ManageSettingsErrorState(this.error);

  @override
  List<Object?> get props =>  [error];
}



