import 'package:beyond_vision/provider/login_provider.dart';
import 'package:beyond_vision/provider/routine_provider.dart';
import 'package:flutter/material.dart';
import 'package:beyond_vision/core/constants.dart';
import 'package:provider/provider.dart';

class SetCount extends StatefulWidget {
  final String workoutName;
  const SetCount({super.key, required this.workoutName});

  @override
  State<SetCount> createState() => _SetCountState();
}

class _SetCountState extends State<SetCount> {
  late TextEditingController _count;

  @override
  void initState() {
    // TODO: implement initState
    _count = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _count.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RoutineProvider routineProvider = Provider.of<RoutineProvider>(context);
    AuthProvider auth = Provider.of<AuthProvider>(context);
    return Dialog(
      backgroundColor: const Color(boxColor),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text(
            "운동 횟수 또는\n시간(초)을 설정하세요\n(1세트 기준)",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color(fontYellowColor),
                fontSize: 38,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _count,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white, fontSize: 40),
            // onSubmitted: (String value) async{await showDialog()},
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              routineProvider.addWorkout(
                  widget.workoutName, int.parse(_count.text), auth.memberId);

              Navigator.pop(context);
              Navigator.pop(context);

              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              "저장",
              style: TextStyle(
                  color: Color(fontYellowColor),
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "취소",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ]),
      ),
    );
  }
}
