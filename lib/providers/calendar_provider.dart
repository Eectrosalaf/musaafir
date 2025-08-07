import 'package:flutter/material.dart';

class CalendarProvider extends ChangeNotifier {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  void setFocusedDay(DateTime day) {
    focusedDay = day;
    notifyListeners();
  }

  void setSelectedDay(DateTime day) {
    selectedDay = day;
    focusedDay = day;
    notifyListeners();
  }

  // You can add schedule data and methods here as needed
}