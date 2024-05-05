import 'package:beyond_vision/core/constants.dart';
import 'package:beyond_vision/model/record_model.dart';
import 'package:beyond_vision/provider/date_provider.dart';
import 'package:beyond_vision/provider/login_provider.dart';
import 'package:beyond_vision/service/record_service.dart';
import 'package:beyond_vision/service/tts_service.dart';
import 'package:beyond_vision/ui/appbar.dart';
import 'package:beyond_vision/ui/record/widgets/record_calendar.dart';
import 'package:beyond_vision/ui/record/widgets/record_detail.dart';
import 'package:beyond_vision/ui/record/widgets/record_graph_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordPage extends StatelessWidget {
  const RecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    DateProvider provider = Provider.of<DateProvider>(context);
    RecordService recordService = RecordService();
    AuthProvider auth = Provider.of<AuthProvider>(context);
    TtsService tts = TtsService();

    return FutureBuilder(
        future: recordService.getAllRecord(auth.memberId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            provider.getRecord(snapshot.data!);
            return Scaffold(
                appBar: provider.currentIdx == 0
                    ? MyAppBar(context,
                        titleText: "운동 기록",
                        getString: tts.getDailyRecord(provider.todayRecords,
                            provider.todayExerciseTime, provider.selectedDay))
                    : MyAppBar(context,
                        titleText: "운동 기록",
                        getString: tts.getWeeklyRecord(
                            provider.thisWeekOnlyResult,
                            provider.thisWeekExerciseTime)),
                backgroundColor: Colors.black,
                body: Column(
                  children: [
                    Calendar(provider: provider),
                    SizedBox(
                      height: 550,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                  height: 250,
                                  child: GraphSlider(provider: provider)),
                              const RecordDetail()
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ));
          } else {
            return const Center(
                child: CircularProgressIndicator(
              color: Color(fontYellowColor),
            ));

            // return const Scaffold(
            //   backgroundColor: Colors.black,
            //   body: Center(
            //     child: Text(
            //       "아직 기록이 없습니다",
            //       style: TextStyle(
            //           color: Color(fontYellowColor),
            //           fontSize: 40,
            //           fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // );
          }
        });
  }
}
