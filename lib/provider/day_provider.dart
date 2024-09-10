import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:partner_admin_portal/constants/global_variables.dart';

class DayProvider extends ChangeNotifier {
  int _tapCount = 0;



  String _selectedDay = '${DateFormat('EEE').format(DateTime.now())} : ${DateFormat('dd MMM').format(DateTime.now())}'; // Initial value is Monday

  String get selectedDay => _selectedDay;

  void updateSelectedDay(String day) {
    _selectedDay = day;
    notifyListeners();
  }

  void updateSelectedDayWithTapCount(String day,int tapCount) {
    GlobalVariables.selectedDay = day;
    _selectedDay = day;
    _tapCount = tapCount;
    notifyListeners();
  }

  void showNextDay() {
    if (_tapCount < 6) {
      DateTime nextDay = DateTime.now().add(Duration(days: _tapCount + 1));
      String formattedNextDay = '${DateFormat('EEE').format(nextDay)} : ${DateFormat('dd MMM').format(nextDay)}';
      updateSelectedDay(formattedNextDay);
      _tapCount++;
    }
  }

  void showPreviousDay() {
    if (_tapCount > 0) {
      DateTime nextDay = DateTime.now().add(Duration(days: _tapCount - 1));
      String formattedNextDay = '${DateFormat('EEE').format(nextDay)} : ${DateFormat('dd MMM').format(nextDay)}';
      updateSelectedDay(formattedNextDay);
      _tapCount--;
    }
  }

}
