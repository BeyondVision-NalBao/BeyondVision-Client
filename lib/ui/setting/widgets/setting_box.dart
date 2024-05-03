import 'package:beyond_vision/core/constants.dart';
import 'package:beyond_vision/ui/setting/setting.dart';
import 'package:beyond_vision/ui/setting/widgets/delete_account.dart';
import 'package:beyond_vision/ui/setting/widgets/edit_goal.dart';
import 'package:beyond_vision/ui/setting/widgets/edit_weight.dart';
import 'package:beyond_vision/ui/setting/widgets/logout.dart';
import 'package:flutter/material.dart';

class SettingBox extends StatelessWidget {
  final String name;
  const SettingBox({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(10),
          backgroundColor: const Color(boxColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () {
          if (name == "운동 목표\n수정") {
            showDialog(
                context: context,
                builder: (BuildContext context) => const EditGoal());
          } else if (name == "회원탈퇴") {
            showDialog(
                context: context,
                builder: (BuildContext context) => const DeleteAccount());
          } else if (name == "로그아웃") {
            showDialog(
                context: context,
                builder: (BuildContext context) => const LogOut());
          } else if (name == "몸무게\n수정") {
            showDialog(
                context: context,
                builder: (BuildContext context) => const EditWeight());
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Setting()));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 36,
                  color: Color(fontYellowColor),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
