import 'package:beyond_vision/provider/login_provider.dart';
import 'package:beyond_vision/service/tts_service.dart';
import 'package:beyond_vision/ui/appbar.dart';
import 'package:beyond_vision/ui/home/widgets/home_grid_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';

class HomePage extends StatefulWidget {
  final int? memberId;
  final int? exerciseGoal;
  bool isFirst;
  HomePage({Key? key, this.memberId, this.exerciseGoal, this.isFirst = false})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TtsService ttsService = TtsService();
  final FlutterTts tts = FlutterTts();
  @override
  void initState() {
    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
    if (widget.memberId != null && widget.exerciseGoal != null) {
      auth.getMemberId(widget.memberId!);
      auth.getGoal(widget.exerciseGoal!);
    }
    if (widget.isFirst == true) {
      tts.setLanguage('ko-KR');
      tts.setSpeechRate(0.4);
      tts.setPitch(0.9);
      tts.speak(
          "오늘도 BeyondVision과 함께 즐겁게 운동해봅시다. 설명을 듣고 싶으시다면 언제든 우측 상단의 스피커 버튼을 누르세요!");
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(context,
          titleText: "", getString: ttsService.getMainExplain()),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: GridView.count(
              crossAxisCount: 2,
              children: const [
                HomeButton(name: "운동 하기"),
                HomeButton(name: "운동 루틴"),
                HomeButton(name: "운동 기록"),
                HomeButton(name: "앱 설정")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
