import 'package:beyond_vision/core/constants.dart';
import 'package:beyond_vision/provider/workout_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';

import 'package:beyond_vision/ui/workout/widgets/camera_flutter.dart';

class SuggestBox extends StatelessWidget {
  const SuggestBox({super.key});

  @override
  Widget build(BuildContext context) {
    WorkoutProvider workoutProvider = Provider.of<WorkoutProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(10),
              backgroundColor: const Color(boxColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CameraView(name: "숄더프레스")));
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) =>
              //             CameraView(name: workoutProvider.todayWorkout.name)));
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => const WorkoutResultPage()),
              // );
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => CameraView(
              //             workout: WorkOut(
              //                 1, "스쿼트", "description", 0, "exerciseImageUrl"),
              //             count: 30)));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "오늘의 운동",
                      style: TextStyle(
                          fontSize: 28,
                          color: Color(fontYellowColor),
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      workoutProvider.todayWorkout.name,
                      style: const TextStyle(
                          fontSize: 36,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.white)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
//   }
// }
