import 'package:beyond_vision/core/constants.dart';
import 'package:beyond_vision/ui/appbar.dart';
import 'package:beyond_vision/ui/routine/widgets/new_button.dart';
import 'package:beyond_vision/ui/routine/widgets/routine_button.dart';

import 'package:flutter/material.dart';

class Routine extends StatelessWidget {
  const Routine({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> routine = [
      const RoutineButton(
        index: "1",
        name: "매일 저녁",
      ),
      const RoutineButton(index: "2", name: "요가"),
      const RoutineButton(index: "3", name: "하체 근력"),
      const NewButton(
        previousPage: true,
      )
    ];
    return Scaffold(
      appBar: MyAppBar(context, titleText: "당신의 루틴"),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: GridView.count(
                crossAxisCount: 2,
                children: routine,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
