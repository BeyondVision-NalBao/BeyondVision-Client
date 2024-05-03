import 'package:beyond_vision/core/constants.dart';
import 'package:flutter/material.dart';

class DetailBox extends StatelessWidget {
  final int index;
  final String title;
  final String time;
  const DetailBox(
      {super.key,
      required this.index,
      required this.title,
      required this.time});

  @override
  Widget build(BuildContext context) {
    String setting = "회";
    if (title == "헌드레드" || title == "플랭크" || title == "제트업" || title == "브릿지") {
      setting = "초";
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
            color: const Color(boxColor),
            borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 200,
                height: 50,
                child: Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold)),
              ),
              Center(
                child: Text('$time $setting',
                    style: const TextStyle(color: Colors.white, fontSize: 20)),
              ),
              ReorderableDragStartListener(
                index: index,
                child: const Column(
                  children: [
                    Icon(Icons.keyboard_arrow_up, color: Colors.white),
                    Icon(Icons.keyboard_arrow_down, color: Colors.white)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
