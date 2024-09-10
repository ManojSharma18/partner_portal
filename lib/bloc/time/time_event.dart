
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

abstract class TimeSelectionEvent extends Equatable  {}

class SelectTimeEvent extends TimeSelectionEvent {
  BuildContext context;
  final TimeOfDay selectedTime;
  final String meal;
  final String session;
  final String timeString;

  SelectTimeEvent(this.selectedTime, this.meal, this.session, this.timeString,this.context);

  @override
  List<Object?> get props => [];
}

class SelectTimeSubEvent extends TimeSelectionEvent {
  BuildContext context;
  final TimeOfDay selectedTime;
  final String meal;
  final String session;
  final String timeString;

  SelectTimeSubEvent(this.selectedTime, this.meal, this.session, this.timeString,this.context);

  @override
  List<Object?> get props => [];
}