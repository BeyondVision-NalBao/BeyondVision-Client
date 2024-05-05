import 'package:beyond_vision/core/constants.dart';
import 'package:flutter/material.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:beyond_vision/model/record_model.dart';

class RecordDetailDialog extends StatefulWidget {
  final Record record;
  const RecordDetailDialog({
    super.key,
    required this.record,
  });

  @override
  State<RecordDetailDialog> createState() => _RecordDetailDialogState();
}

class _RecordDetailDialogState extends State<RecordDetailDialog> {
  final FlutterTts tts = FlutterTts();

  bool isListening = false;
  int isResult = 1;
  String networkUrl = "";

  @override
  void initState() {
    // TODO: implement initState
    tts.setSpeechRate(0.4);
    tts.setPitch(0.9);
    // tts.speak(widget.workout.description);
    // networkUrl = widget.workout.exerciseImageUrl;

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(boxColor),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text(
            widget.record.exerciseName!,
            style: const TextStyle(
                color: Color(fontYellowColor),
                fontSize: 40,
                fontWeight: FontWeight.bold),
          ),
          const Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Text("자세 성공 횟수",

                    // widget.record.averageHeartRate!.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700)),
                Text("6",

                    // widget.record.averageHeartRate!.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w500)),
              ]),
              SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Text("평균 심박수",

                    // widget.record.averageHeartRate!.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700)),
                Text("135",

                    // widget.record.averageHeartRate!.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w500)),
              ]),
              SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Text("소모 칼로리",

                    // widget.record.averageHeartRate!.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700)),
                Text("15",

                    // widget.record.averageHeartRate!.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w500)),
              ]),
            ],
          ),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("닫기",
                  style: TextStyle(color: Colors.white, fontSize: 24)))
        ]),
      ),
    );
  }
}
