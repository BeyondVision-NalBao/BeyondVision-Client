import 'package:beyond_vision/core/constants.dart';
import 'package:beyond_vision/ui/home/widgets/home_grid_button.dart';
import 'package:beyond_vision/ui/setting/widgets/edit_goal.dart';
import 'package:beyond_vision/ui/setting/widgets/setting_box.dart';
import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Icon(speakerIcon, color: Color(fontYellowColor), size: 50),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: GridView.count(
                crossAxisCount: 2,
                children: const [
                  SettingBox(name: "운동 목표\n수정"),
                  SettingBox(name: "로그아웃"),
                  SettingBox(name: "회원탈퇴"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
