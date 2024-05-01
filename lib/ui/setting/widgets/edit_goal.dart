import 'package:beyond_vision/core/constants.dart';
import 'package:beyond_vision/provider/login_provider.dart';
import 'package:beyond_vision/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditGoal extends StatefulWidget {
  const EditGoal({super.key});

  @override
  State<EditGoal> createState() => _EditGoalState();
}

class _EditGoalState extends State<EditGoal> {
  late TextEditingController _count;

  @override
  void initState() {
    _count = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _count.dispose();
    super.dispose();
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
        });

        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          backgroundColor: const Color(boxColor), // 원하는 배경 색상으로 변경
          content: const SizedBox(
            height: 100,
            child: Center(
              child: Text(
                "수정 성공",
                style: TextStyle(
                    color: Color(fontYellowColor),
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    UserService userService = UserService();

    return Dialog(
      backgroundColor: const Color(boxColor),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text(
              "운동 목표 수정",
              style: TextStyle(
                  color: Color(fontYellowColor),
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            const Text("운동 횟수 또는 시간을 \n수정하세요\n(분 단위로 입력)",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 24)),
            const SizedBox(height: 30),
            TextField(
              style:
                  const TextStyle(color: Color(fontYellowColor), fontSize: 40),
              keyboardType: TextInputType.number,
              controller: _count,
              // onSubmitted: (String value) async{await showDialog()},
            ),
            const SizedBox(height: 30),
            TextButton(
                onPressed: () async {
                  int isSuccess = await userService.editUserInfo(
                      auth.goal, int.parse(_count.text), auth.memberId);
                  auth.goal = isSuccess;
                  Navigator.pop(context);
                  _showDialog();
                },
                child: const Text("수정하기",
                    style: TextStyle(
                        color: Color(fontYellowColor), fontSize: 24))),
            const SizedBox(height: 10),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("취소",
                    style: TextStyle(color: Colors.white, fontSize: 24)))
          ]),
        ),
      ),
    );
  }
}
