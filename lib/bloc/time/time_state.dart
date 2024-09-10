
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class TimeSelectState extends Equatable {
  final  String timeOfDay;
  const TimeSelectState(this.timeOfDay);
  @override
  List<Object?> get props => [timeOfDay];
}