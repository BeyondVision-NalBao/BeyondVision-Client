import 'package:beyond_vision/core/constants.dart';
import 'package:beyond_vision/ui/appbar.dart';
import 'package:beyond_vision/ui/workout/widgets/workout_detail.dart';
import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
  final String cate;

  const Categories({
    super.key,
    required this.cate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(context, titleText: cate),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return const WorkOutDetail(name: "운동이름");
              }),
        ),
      ),
    );
  }
}