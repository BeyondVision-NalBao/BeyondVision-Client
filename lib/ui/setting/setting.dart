import 'package:beyond_vision/service/tts_service.dart';
import 'package:beyond_vision/ui/appbar.dart';
import 'package:beyond_vision/ui/setting/widgets/delete_account.dart';
import 'package:beyond_vision/ui/setting/widgets/setting_box.dart';
import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    TtsService tts = TtsService();
    return Scaffold(
      appBar: MyAppBar(context, titleText: "설정", getString: tts.getSetting()),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 200),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: GridView.count(
                crossAxisCount: 2,
                children: const [
                  SettingBox(name: "운동 목표\n수정"),
                  SettingBox(name: "로그아웃"),
                  SettingBox(name: "몸무게\n수정"),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            const DeleteAccount());
                  },
                  child: const Text("회원탈퇴",
                      style: TextStyle(color: Colors.white, fontSize: 20))),
            )
          ],
        ),
      ),
    );
  }
}
