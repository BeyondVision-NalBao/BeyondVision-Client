import 'dart:async';
import 'package:beyond_vision/model/day_model.dart';
import 'package:beyond_vision/core/constants.dart';
import 'package:beyond_vision/provider/login_provider.dart';
import 'package:beyond_vision/service/alarm_service.dart';
import 'package:beyond_vision/service/user_service.dart';
import 'package:beyond_vision/ui/setting/widgets/select_day.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:time_picker_spinner/time_picker_spinner.dart';

class EditAlarm extends StatefulWidget {
  const EditAlarm({super.key});

  @override
  State<EditAlarm> createState() => _EditAlarmState();
}

class _EditAlarmState extends State<EditAlarm> {
  List<Days> days = [
    Days(0, "월", false),
    Days(1, "화", false),
    Days(2, "수", false),
    Days(3, "목", false),
    Days(4, "금", false),
    Days(5, "토", false),
    Days(6, "일", false)
  ];
  int _counter = 0; // _counter 변수를 0으로 초기화
  final int _targetNumber = 10; // _targetNumber 변수를 10으로 초기화
  Timer? _timer; // 타이머를 선언

  @override
  void initState() {
    _requestNotificationPermissions(); // 알림 권한 요청

    super.initState();
  }

  void _requestNotificationPermissions() async {
    //알림 권한 요청
    final status = await NotificationService().requestNotificationPermissions();
    if (status.isDenied && context.mounted) {
      showDialog(
        // 알림 권한이 거부되었을 경우 다이얼로그 출력
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('알림 권한이 거부되었습니다.'),
          content: const Text('알림을 받으려면 앱 설정에서 권한을 허용해야 합니다.'),
          actions: <Widget>[
            TextButton(
              child: const Text('설정'), //다이얼로그 버튼의 죄측 텍스트
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings(); //설정 클릭시 권한설정 화면으로 이동
              },
            ),
            TextButton(
              child: const Text('취소'), //다이얼로그 버튼의 우측 텍스트
              onPressed: () => Navigator.of(context).pop(), //다이얼로그 닫기
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
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
    DateTime dateTime = DateTime.now();
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
              "알람 시간",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(fontYellowColor),
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            const Text("알람 시간을 설정하세요",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 24)),
            const SizedBox(height: 30),
            SizedBox(
                height: 150,
                child: GridView.count(
                  crossAxisCount: 4,
                  //scrollDirection: Axis.horizontal,
                  children: List.generate(days.length, (index) {
                    return SelectImage(
                      index: index,
                      name: days[index].day,
                      isSelected: days[index].select,
                      onTap: (index) {
                        setState(() {
                          days[index].selected();
                        });
                      },
                    );
                  }),
                )),
            SizedBox(
              height: 150,
              child: TimePickerSpinner(
                highlightedTextStyle: const TextStyle(
                    color: Color(fontYellowColor),
                    fontSize: 36,
                    fontWeight: FontWeight.bold),
                normalTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
                minutesInterval: 15,
                onTimeChange: (time) {
                  setState(() {
                    dateTime = time;
                  });
                },
              ),
            ),
            SizedBox(height: 30),
            TextButton(
                onPressed: () async {
                  _toggleTimer();
                  // Navigator.pop(context);
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

  void _toggleTimer() {
    // 타이머 시작/정지 기능
    if (_timer?.isActive == true) {
      _stopTimer();
    } else {
      _startTimer();
    }
  }

  void _startTimer() {
    //타이머 시작
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _counter++;
      if (_counter == _targetNumber) {
        NotificationService().showNotification(_targetNumber);
        _stopTimer();
      }
    });
  }

  void _stopTimer() {
    //타이머 정지
    _timer?.cancel();
  }
}
