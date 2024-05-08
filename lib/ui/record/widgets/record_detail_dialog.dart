import 'package:beyond_vision/core/constants.dart';
import 'package:beyond_vision/provider/date_provider.dart';
import 'package:flutter/material.dart';
import 'package:beyond_vision/model/record_model.dart';
import 'package:provider/provider.dart';

class RecordDetailDialog extends StatelessWidget {
  final Record record;
  const RecordDetailDialog({
    super.key,
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(boxColor),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text(
            record.exerciseName!,
            style: const TextStyle(
                color: Color(fontYellowColor),
                fontSize: 40,
                fontWeight: FontWeight.bold),
          ),
          Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                const Text("자세 성공 횟수",

                    // widget.record.averageHeartRate!.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700)),
                Text(record.successCount.toString(),

                    // widget.record.averageHeartRate!.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w500)),
              ]),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                const Text("평균 심박수",

                    // widget.record.averageHeartRate!.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700)),
                Text(record.averageHeartRate.toString(),

                    // widget.record.averageHeartRate!.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w500)),
              ]),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                const Text("소모 칼로리",

                    // widget.record.averageHeartRate!.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700)),
                Text(record.caloriesBurnedSum!.toStringAsFixed(2),

                    // widget.record.averageHeartRate!.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
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
