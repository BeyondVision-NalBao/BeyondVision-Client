import 'package:flutter/material.dart';
import 'package:beyond_vision/model/record_model.dart';
import 'package:table_calendar/table_calendar.dart';

class DateProvider extends ChangeNotifier {
  DateTime selectedDay = DateTime.now();
  int selectedIndex = -1;
  double todayExerciseTime = 0.0;
  int todayHeartRate = 0;
  double average = 0.0;
  double todayCalories = 0.0;
  List<double> thisWeekExerciseTime = [
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
  ];
  List<DateTime> successWeek = [];
  List<Record> records = [];
  List<List<Record>> thisWeek = [];

  List<List<Record>> thisWeekOnlyResult = [];
  List<Record> todayRecords = [];
  int currentIdx = 0;

  DateProvider() {
    selectedIndex = selectedDay.weekday - 1;
    updateSelectedDay(selectedDay, selectedDay);
  }

  void getRecord(List<Record> newRecords) {
    records = newRecords;
  }

  void moveWeek(DateTime newDay) {
    selectedDay = newDay;
    updateSelectedDay(selectedDay, selectedDay);
  }

  void getCurrentIdx(int index) {
    currentIdx = index;
    notifyListeners();
  }

  void updateSelectedDay(DateTime newDay, DateTime focusedDay) {
    successWeek = [];
    thisWeek = [];
    todayRecords = [];
    todayExerciseTime = 0.0;
    thisWeekExerciseTime = [];
    thisWeekOnlyResult = [];
    selectedDay = newDay;
    selectedIndex = selectedDay.weekday - 1;
    todayHeartRate = 0;
    average = 0.0;
    todayCalories = 0.0;

    //오늘 기록
    todayRecords = records
        .where((record) => isSameDay(record.exerciseDate, selectedDay))
        .toList();

    for (int i = 0; i < todayRecords.length; i++) {
      todayExerciseTime +=
          double.parse((todayRecords[i].exerciseTime! / 60).toStringAsFixed(1));
      todayCalories += todayRecords[i].caloriesBurnedSum!;
      todayHeartRate += todayRecords[i].averageHeartRate!;
    }
    average = todayHeartRate / todayRecords.length;

    //이번주 기록
    int mondayOffset = selectedDay.weekday - DateTime.monday;
    DateTime newDate = selectedDay.subtract(Duration(days: mondayOffset));

    for (int i = 0; i < 7; i++) {
      List<Record> record = [];
      DateTime currentDate = newDate.add(Duration(days: i));
      record = records
          .where((record) => isSameDay(record.exerciseDate, currentDate))
          .toList();
      if (record.isEmpty) {
        thisWeek.add(
            [Record(null, null, null, null, currentDate, null, null, null)]);
      } else {
        thisWeek.add(record);
        thisWeekOnlyResult.add(record);
      }
    }

    for (int i = 0; i < thisWeek.length; i++) {
      double sum = 0.0;
      for (int j = 0; j < thisWeek[i].length; j++) {
        if (thisWeek[i][j].exerciseTime != null) {
          sum +=
              double.parse((thisWeek[i][j].exerciseTime!).toStringAsFixed(1));
        }
      }
      thisWeekExerciseTime.add(sum);
    }

    notifyListeners(); // 상태가 변경될 때마다 리스너들에게 알림
  }
}
