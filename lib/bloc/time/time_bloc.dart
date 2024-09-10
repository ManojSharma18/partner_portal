import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:partner_admin_portal/bloc/time/time_event.dart';
import 'package:partner_admin_portal/bloc/time/time_state.dart';
import 'package:partner_admin_portal/constants/manage_settings/manage_settings_variables.dart';


import '../../constants/manage_settings/manage_settings_functions.dart';
import '../../constants/utils.dart';


class TimeSelectionBloc extends Bloc<TimeSelectionEvent, TimeSelectState> {
  TimeSelectionBloc() : super(TimeSelectState(TimeOfDay.now().toString()));

  @override
  Stream<TimeSelectState> mapEventToState(TimeSelectionEvent event) async* {
    if (event is SelectTimeEvent) {
      final selectedTime = event.selectedTime;
      final meal = event.meal;

      print(selectedTime);

      TimeOfDay time = ManageSettingFunction.buildTimeOfDay(selectedTime.hour, selectedTime.minute, selectedTime.period == DayPeriod.am);

      if (meal == "Breakfast") {
        if (ManageSettingFunction.isTimeInRange(time, TimeOfDay(hour: 2, minute: 0), TimeOfDay(hour: 11, minute: 59))) {
          if(event.timeString == "StartTime")
            {
              ManageSettingsVariables.mealTiming[meal]![event.session]![event.timeString] = event.selectedTime.format(event.context);
            }
          else {
            if(ManageSettingsVariables.mealTiming['Breakfast']![event.session]!['StartTime'] != '-- -- --' )
            {
              TimeOfDay timeOfDay = ManageSettingFunction.parseTimeOfDay(ManageSettingsVariables.mealTiming['Breakfast']![event.session]!['StartTime']);

              int comparisonResult = ManageSettingFunction.compareTimeOfDay(timeOfDay, time);

              if (comparisonResult < 0) {
                ManageSettingsVariables.mealTiming[meal]![event.session]![event.timeString] = ManageSettingFunction.buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(event.context);
              }
              else if (comparisonResult > 0) {

              } else {

              }

            }
            else {

            }
          }

          yield TimeSelectState(event.selectedTime.format(event.context));
        } else {
          // yield TimeSelectionError("Please select the time between 02:00 AM to 12:00 PM");
        }
      }
      else if (meal == "Lunch") {
        if (ManageSettingFunction.isTimeInRange(time, TimeOfDay(hour: 4, minute: 30), TimeOfDay(hour: 16, minute: 30))) {
          if(event.timeString == "StartTime")
          {
            ManageSettingsVariables.mealTiming[meal]![event.session]![event.timeString] = event.selectedTime.format(event.context);
          }
          else {
            if(ManageSettingsVariables.mealTiming['Lunch']![event.session]!['StartTime'] != '-- -- --' )
            {
              TimeOfDay timeOfDay = ManageSettingFunction.parseTimeOfDay(ManageSettingsVariables.mealTiming['Lunch']![event.session]!['StartTime']);

              int comparisonResult = ManageSettingFunction.compareTimeOfDay(timeOfDay, time);

              if (comparisonResult < 0) {
                ManageSettingsVariables.mealTiming[meal]![event.session]![event.timeString] = ManageSettingFunction.buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(event.context);
              }
              else if (comparisonResult > 0) {

              } else {

              }

            }
            else {

            }
          }
          yield TimeSelectState(event.selectedTime.format(event.context));
        } else {
          // yield TimeSelectionError("Please select the time between 04:30 AM to 04:30 PM");
        }
      }
      else if (meal == "Dinner") {
        if(event.timeString == "StartTime")
        {
          ManageSettingsVariables.mealTiming[meal]![event.session]![event.timeString] = event.selectedTime.format(event.context);
        }
        else {
          if(ManageSettingsVariables.mealTiming['Dinner']![event.session]!['StartTime'] != '-- -- --' )
          {
            TimeOfDay timeOfDay = ManageSettingFunction.parseTimeOfDay(ManageSettingsVariables.mealTiming['Dinner']![event.session]!['StartTime']);

            int comparisonResult = ManageSettingFunction.compareTimeOfDay(timeOfDay, time);

            if (comparisonResult < 0) {
              ManageSettingsVariables.mealTiming[meal]![event.session]![event.timeString] = ManageSettingFunction.buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(event.context);
            }
            else if (comparisonResult > 0) {

            } else {

            }

          }
          else {

          }
        }
        yield TimeSelectState(event.selectedTime.format(event.context));
      }
    }

    if (event is SelectTimeSubEvent) {
      final selectedTime = event.selectedTime;
      final meal = event.meal;

      print(selectedTime);

      TimeOfDay time = ManageSettingFunction.buildTimeOfDay(selectedTime.hour, selectedTime.minute, selectedTime.period == DayPeriod.am);

      if (meal == "Breakfast") {
        if (ManageSettingFunction.isTimeInRange(time, TimeOfDay(hour: 2, minute: 0), TimeOfDay(hour: 11, minute: 59))) {
          if(event.timeString == "StartTime")
          {
            ManageSettingsVariables.mealTimingSub[meal]![event.session]![event.timeString] = event.selectedTime.format(event.context);
          }
          else {
            if(ManageSettingsVariables.mealTimingSub['Breakfast']![event.session]!['StartTime'] != '-- -- --' )
            {
              TimeOfDay timeOfDay = ManageSettingFunction.parseTimeOfDay(ManageSettingsVariables.mealTimingSub['Breakfast']![event.session]!['StartTime']);

              int comparisonResult = ManageSettingFunction.compareTimeOfDay(timeOfDay, time);

              if (comparisonResult < 0) {
                ManageSettingsVariables.mealTimingSub[meal]![event.session]![event.timeString] = ManageSettingFunction.buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(event.context);
              }
              else if (comparisonResult > 0) {

              } else {

              }

            }
            else {

            }
          }

          yield TimeSelectState(event.selectedTime.format(event.context));
        } else {
          // yield TimeSelectionError("Please select the time between 02:00 AM to 12:00 PM");
        }
      }
      else if (meal == "Lunch") {
        if (ManageSettingFunction.isTimeInRange(time, TimeOfDay(hour: 4, minute: 30), TimeOfDay(hour: 16, minute: 30))) {
          if(event.timeString == "StartTime")
          {
            ManageSettingsVariables.mealTimingSub[meal]![event.session]![event.timeString] = event.selectedTime.format(event.context);
          }
          else {
            if(ManageSettingsVariables.mealTimingSub['Lunch']![event.session]!['StartTime'] != '-- -- --' )
            {
              TimeOfDay timeOfDay = ManageSettingFunction.parseTimeOfDay(ManageSettingsVariables.mealTimingSub['Lunch']![event.session]!['StartTime']);

              int comparisonResult = ManageSettingFunction.compareTimeOfDay(timeOfDay, time);

              if (comparisonResult < 0) {
                ManageSettingsVariables.mealTimingSub[meal]![event.session]![event.timeString] = ManageSettingFunction.buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(event.context);
              }
              else if (comparisonResult > 0) {

              } else {

              }

            }
            else {

            }
          }
          yield TimeSelectState(event.selectedTime.format(event.context));
        } else {
          // yield TimeSelectionError("Please select the time between 04:30 AM to 04:30 PM");
        }
      }
      else if (meal == "Dinner") {
        if(event.timeString == "StartTime")
        {
          ManageSettingsVariables.mealTimingSub[meal]![event.session]![event.timeString] = event.selectedTime.format(event.context);
        }
        else {
          if(ManageSettingsVariables.mealTimingSub['Dinner']![event.session]!['StartTime'] != '-- -- --' )
          {
            TimeOfDay timeOfDay = ManageSettingFunction.parseTimeOfDay(ManageSettingsVariables.mealTimingSub['Dinner']![event.session]!['StartTime']);

            int comparisonResult = ManageSettingFunction.compareTimeOfDay(timeOfDay, time);

            if (comparisonResult < 0) {
              ManageSettingsVariables.mealTimingSub[meal]![event.session]![event.timeString] = ManageSettingFunction.buildTimeOfDay(ManageSettingsVariables.selectedHour, ManageSettingsVariables.selectedMinute, ManageSettingsVariables.isAM).format(event.context);
            }
            else if (comparisonResult > 0) {

            } else {

            }

          }
          else {

          }
        }
        yield TimeSelectState(event.selectedTime.format(event.context));
      }
    }
  }
}
