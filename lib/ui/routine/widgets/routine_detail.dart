import 'dart:ui';
import 'package:beyond_vision/core/constants.dart';
import 'package:beyond_vision/model/routine_model.dart';
import 'package:beyond_vision/provider/login_provider.dart';
import 'package:beyond_vision/provider/routine_provider.dart';
import 'package:beyond_vision/service/tts_service.dart';
import 'package:beyond_vision/ui/appbar.dart';
import 'package:beyond_vision/ui/routine/widgets/new_button.dart';
import 'package:beyond_vision/ui/routine/widgets/routine_detail_box.dart';
import 'package:beyond_vision/ui/workout/widgets/workout_camera_routine.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoutineDetail extends StatefulWidget {
  final Routine routine;
  final int index;
  const RoutineDetail({super.key, required this.routine, required this.index});

  @override
  State<RoutineDetail> createState() => _RoutineDetailState();
}

class _RoutineDetailState extends State<RoutineDetail> {
  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Container(
            decoration: const BoxDecoration(color: Color(fontYellowColor)),
            child: child);
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    RoutineProvider routineProvider = Provider.of<RoutineProvider>(context);
    List<RoutineExercise> items = widget.routine.routineDetails;
    AuthProvider auth = Provider.of<AuthProvider>(context);
    TtsService tts = TtsService();
    // @override
    // void dispose() {
    //   routineService.editRoutine(routineProvider.routines[widget.index], 3);
    //   super.dispose();
    // }

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: MyAppBar(context,
            titleText: widget.routine.routineName,
            getString: tts.getRoutineDetailExplain(widget.routine)),
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: ReorderableListView(
                proxyDecorator: proxyDecorator,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    // 아이템의 순서를 변경하는 로직
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final item = items.removeAt(oldIndex);
                    items.insert(newIndex, item);

                    routineProvider.isChanged = true;
                  });
                },
                buildDefaultDragHandles: false,
                children: List.generate(
                  items.length,
                  (index) {
                    return DetailBox(
                      key: ValueKey(index),
                      index: index,
                      title: items[index].exerciseName,
                      time: items[index].exerciseCount.toString(),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (routineProvider.isWorkout == false)
              if (routineProvider.isChanged)
                Center(
                  child: Material(
                    shape: const CircleBorder(side: BorderSide.none),
                    elevation: 15,
                    child: CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color(boxColor),
                        child: IconButton(
                            onPressed: () {
                              routineProvider.editOrder(
                                  widget.index, items, auth.memberId);
                              setState(() {
                                routineProvider.isChanged = false;
                              });
                            },
                            icon: const Icon(
                              Icons.check,
                              size: 80,
                              color: Color(fontYellowColor),
                            ))),
                  ),
                )
              else
                NewButton(previousPage: false, index: widget.index)
            else
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CameraView(
                            exercises: items,
                            memberId: auth.memberId,
                            weight: auth.weight),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.play_arrow,
                    size: 80,
                    color: Color(fontYellowColor),
                  ))
          ]),
        ));
  }
}
