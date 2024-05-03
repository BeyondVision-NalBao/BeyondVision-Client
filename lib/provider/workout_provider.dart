import 'package:beyond_vision/model/workout_model.dart';
import 'package:flutter/material.dart';

class WorkoutResult {
  final String name;
  final int time;
  final int count;

  WorkoutResult(this.name, this.time, this.count);

  WorkoutResult.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        time = json['time'],
        count = json['count'];
}

class WorkoutProvider extends ChangeNotifier {
  List<WorkOut> workoutTop = [];
  List<WorkOut> workoutBottom = [];
  List<WorkOut> workoutCore = [];
  List<WorkOut> workoutStretch = [];
  List<WorkoutResult> results = [
    WorkoutResult("스쿼트", 4, 30),
    WorkoutResult("스쿼트", 4, 30)
  ];
  WorkOut workoutEx = WorkOut(0, "", "", 0, "");
  int sum = 0;
  WorkOut todayWorkout = WorkOut(0, "", "", 0, "");

  void getWorkoutList(List<List<WorkOut>> workouts) {
    for (int i = 0; i < 4; i++) {
      if (i == 0) {
        print(workouts[i]);
        workoutTop = workouts[i];
      } else if (i == 1) {
        workoutBottom = workouts[i];
      } else if (i == 2) {
        workoutCore = workouts[i];
      } else {
        workoutStretch = workouts[i];
      }
    }

    for (int i = 0; i < workoutBottom.length; i++) {
      print(workoutBottom[i].name);
    }
  }

  WorkOut findWorkout(String name) {
    if (name == "스쿼트") {
      return workoutBottom[0];
    } else if (name == "숄더프레스") {
      return workoutTop[0];
    } else if (name == "레터럴레이즈") {
      return workoutTop[1];
    } else if (name == "헌드레드") {
      return workoutCore[1];
    } else if (name == "플랭크") {
      return workoutCore[0];
    } else if (name == "프론트레이즈") {
      return workoutTop[2];
    } else if (name == "제트업") {
      return workoutBottom[1];
    } else {
      //브릿지
      return workoutCore[2];
    }
  }
}
