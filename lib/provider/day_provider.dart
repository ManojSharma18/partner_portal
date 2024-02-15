import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayProvider extends ChangeNotifier {
  String _selectedDay = 'Today : ${DateFormat('dd MMM').format(DateTime.now())}'; // Initial value is Monday

  String get selectedDay => _selectedDay;

  void updateSelectedDay(String day) {
    _selectedDay = day;
    notifyListeners(); // Notify listeners of the change
  }
}
