import 'package:beyond_vision/core/constants.dart';
import 'package:beyond_vision/provider/workout_provider.dart';
import 'package:beyond_vision/service/workout_service.dart';
import 'package:beyond_vision/ui/appbar.dart';
import 'package:beyond_vision/ui/workout/widgets/workout_suggest_box.dart';
import 'package:beyond_vision/ui/workout/widgets/workout_routine_box.dart';
import 'package:beyond_vision/ui/workout/widgets/workout_big_box.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkOut extends StatelessWidget {
  const WorkOut({super.key});

  @override
  Widget build(BuildContext context) {
    WorkOutService workoutService = WorkOutService();
    WorkoutProvider workoutProvider = Provider.of<WorkoutProvider>(context);
    if (workoutProvider.workoutTop.isEmpty) {
      return FutureBuilder(
          future: workoutService.getAllWorkOut(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                workoutProvider.getWorkoutList(snapshot.data!);

                return Scaffold(
                    appBar: MyAppBar(context, titleText: "운동 하기"),
                    backgroundColor: Colors.black,
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SuggestBox(),
                        const RoutineBox(),
                        const SizedBox(height: 12),
                        const Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Text("운동 프로그램",
                              style: TextStyle(
                                  color: Color(fontYellowColor),
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 5),
                            width: MediaQuery.of(context).size.width * 0.95,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(blurYellowColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: GridView.count(
                            crossAxisCount: 2,
                            children: const [
                              BigBox(cateNum: 0, name: "상체"),
                              BigBox(cateNum: 1, name: "하체"),
                              BigBox(cateNum: 2, name: "코어"),
                              BigBox(cateNum: 3, name: "스트레칭"),
                            ],
                          ),
                        ),
                      ],
                    ));
              } else {
                return const Center(child: Text("오류가 발생했습니다."));
              }
            } else if (snapshot.hasError) {
              return const Center(child: Text("오류가 발생했습니다."));
            } else {
              return const Center(
                  child: CircularProgressIndicator(
                color: Color(fontYellowColor),
              ));
            }
          });
    } else {
      return Scaffold(
          appBar: MyAppBar(context, titleText: "운동 하기"),
          backgroundColor: Colors.black,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SuggestBox(),
              const RoutineBox(),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text("운동 프로그램",
                    style: TextStyle(
                        color: Color(fontYellowColor),
                        fontSize: 40,
                        fontWeight: FontWeight.bold)),
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: MediaQuery.of(context).size.width * 0.95,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(blurYellowColor),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: GridView.count(
                  crossAxisCount: 2,
                  children: const [
                    BigBox(cateNum: 0, name: "상체"),
                    BigBox(cateNum: 1, name: "하체"),
                    BigBox(cateNum: 2, name: "코어"),
                    BigBox(cateNum: 3, name: "스트레칭"),
                  ],
                ),
              ),
            ],
          ));
    }
  }
}
