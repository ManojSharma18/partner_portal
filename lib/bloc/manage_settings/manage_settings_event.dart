import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:partner_admin_portal/screens/manage_setting.dart';

import '../../models/manage_setting.dart';

@immutable
abstract class ManageSettingEvent extends Equatable{
  const ManageSettingEvent();

}

class LoadManageSettingEvent extends ManageSettingEvent {
  @override
  List<Object?> get props =>  [];
}

class ChangeRestaurantModelEvent extends ManageSettingEvent {
  final BuildContext context;
  final String model;
  const ChangeRestaurantModelEvent(this.context, this.model);
  @override
  List<Object?> get props =>  [];
}

class SetMealSessionTimeEvent extends ManageSettingEvent {
  final BuildContext context;
  const SetMealSessionTimeEvent(this.context);

  @override
  List<Object?> get props => [];
}

class AddTimingsEvent extends ManageSettingEvent {
  final BuildContext context;
  final ManageSettingModel manageSetting;
  const AddTimingsEvent(this.context,this.manageSetting);
  @override
  List<Object?> get props => [];
}

class UpdateTimingsEvent extends ManageSettingEvent {
  final BuildContext context;
  final String id;
  final ManageSettingModel manageSetting;
  const UpdateTimingsEvent(this.id,this.context,this.manageSetting);
  @override
  List<Object?> get props => [];
}