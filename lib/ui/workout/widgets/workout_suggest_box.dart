import 'package:beyond_vision/core/constants.dart';
import 'package:beyond_vision/provider/login_provider.dart';
import 'package:beyond_vision/service/workout_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:beyond_vision/ui/workout/widgets/camera_flutter.dart';

class SuggestBox extends StatefulWidget {
  const SuggestBox({super.key});

  @override
  State<SuggestBox> createState() => _SuggestBoxState();
}

class _SuggestBoxState extends State<SuggestBox> {
  _showDialog(context) async {
    final result = showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(boxColor),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text(
                  "운동 목표 수정",
                  style: TextStyle(
                      color: Color(fontYellowColor),
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                const Text("연결된 스마트 워치가 있으신가요?",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: Color(fontYellowColor), fontSize: 36)),
                const Text("워치 앱을 켜고, 운동하기에서\n심박수, 칼로리 등을 얻을 수 있습니다",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 24)),
                const SizedBox(height: 30),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("워치와 연결 완료",
                        style: TextStyle(
                            color: Color(fontYellowColor), fontSize: 24))),
                const SizedBox(height: 10),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("워치 없이 바로 운동하기",
                        style: TextStyle(color: Colors.white, fontSize: 24)))
              ]),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    WorkOutService workoutService = WorkOutService();

    return FutureBuilder(
        future: workoutService.getRecommend(auth.memberId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
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
                              builder: (context) => CameraView(
                                  workout: snapshot.data!,
                                  count: 3,
                                  memberId: auth.memberId,
                                  weight: auth.weight)));
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
                              snapshot.data!.name,
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
          } else {
            return const Center(
                child:
                    CircularProgressIndicator(color: Color(fontYellowColor)));
          }
        });
  }
}
//   }
// }
