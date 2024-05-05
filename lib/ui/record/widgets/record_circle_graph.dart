import 'package:beyond_vision/core/constants.dart';
import 'package:beyond_vision/provider/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:beyond_vision/provider/date_provider.dart';
import 'package:provider/provider.dart';

class RecordCircle extends StatelessWidget {
  final DateProvider provider;
  const RecordCircle({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    return SizedBox(
      height: 250,
      child: AspectRatio(
          aspectRatio: 2,
          child: AspectRatio(
            aspectRatio: 1,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                    // touchCallback:
                    //     (FlTouchEvent event, pieTouchResponse) {
                    //   setState(() {
                    //     if (!event.isInterestedForInteractions ||
                    //         pieTouchResponse == null ||
                    //         pieTouchResponse.touchedSection == null) {
                    //       touchedIndex = -1;
                    //       return;
                    //     }
                    //     touchedIndex = pieTouchResponse
                    //         .touchedSection!.touchedSectionIndex;
                    //   });
                    // },
                    ),
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 0,
                centerSpaceRadius: 70,
                startDegreeOffset: 270.0,
                sections: showingSections(provider, auth.goal),
              ),
            ),
          )),
    );
  }

  List<PieChartSectionData> showingSections(DateProvider provider, int goal) {
    return List.generate(2, (i) {
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(fontYellowColor),
            value: provider.todayExerciseTime / goal,
            showTitle: false,
            radius: 35,
          );
        case 1:
          return PieChartSectionData(
            color: const Color(blurYellowColor),
            value: provider.todayExerciseTime > goal
                ? 0
                : 1 - (provider.todayExerciseTime / goal),
            showTitle: false,
            radius: 20,
          );
        default:
          throw Error();
      }
    });
  }
}
