import 'package:beyond_vision/model/workout_model.dart';
import 'package:beyond_vision/provider/workout_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WorkOutService {
  static const String baseUrl = "http://34.64.89.205/api/v1/exercise";

  Future<List<List<WorkOut>>> getAllWorkOut() async {
    List<List<WorkOut>> workoutInstances = [];

    for (int i = 0; i < 4; i++) {
      List<WorkOut> workouts = [];
      final url = Uri.parse('$baseUrl/detail/$i');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> workoutsData =
            jsonDecode(utf8.decode(response.bodyBytes));
        for (var workout in workoutsData) {
          workouts.add(WorkOut.fromJson(workout));
        }
      }

      workoutInstances.add(workouts);
    }
    return workoutInstances;
  }

  Future<WorkOut> getRecommend(int memberId) async {
    final url = Uri.parse('$baseUrl/random');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(utf8.decode(response.bodyBytes));
      WorkOut recommandWorkout = WorkOut.fromJson(data);

      return recommandWorkout;
    }
    throw Error();
  }

  // Future<WorkoutResult> getResults() async {
  //   final url =
  //       Uri.parse('https://52ff-221-145-51-165.ngrok-free.app/exercise/output');

  //   final response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> data =
  //         jsonDecode(utf8.decode(response.bodyBytes));
  //     WorkoutResult workoutResult = WorkoutResult.fromJson(data);
  //     return workoutResult;
  //   }
  //   throw Error();
  // }

  // Future<void> postReady() async {
  //   final url = Uri.parse('$baseUrl/1/ready');

  //   var response = await http.post(url,
  //       headers: {"Content-Type": "application/json; charset=UTF-8"},
  //       body: json.encode({"routineName": "멋지게 살자"}));

  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(utf8.decode(response.bodyBytes));
  //     postStart();
  //   }
  //   throw Error();
  // }

  // Future<void> postStart() async {
  //   final url = Uri.parse('$baseUrl/1/1/1/start');

  //   var response = await http.post(url);
  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(utf8.decode(response.bodyBytes));
  //   }
  //   throw Error();
  // }
}
