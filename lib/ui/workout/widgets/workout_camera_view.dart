import 'dart:io';
import 'dart:convert';
import 'package:beyond_vision/core/constants.dart';
import 'package:beyond_vision/provider/login_provider.dart';
import 'package:beyond_vision/provider/workout_provider.dart';
import 'package:beyond_vision/ui/home/home.dart';
import 'package:beyond_vision/ui/workout/widgets/workout_explain.dart';
import 'package:beyond_vision/ui/workout/widgets/workout_result.dart';
import 'package:beyond_vision/ui/workout/workout.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'dart:typed_data';
import 'package:wakelock/wakelock.dart';

//자신의 배꼽 위치에 휴대폰을 세우고 두걸음 뒤로 물러나세요
//삑 소리가 울리면 동작을 수행하세요
List<CameraDescription> cameras = [];

class CameraView extends StatefulWidget {
  final String name;
  const CameraView({super.key, required this.name});

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  FlutterTts tts = FlutterTts();
  late CameraController _controller;
  late bool _isInitialized;
  bool _isStreamingPaused = false;
  bool isReady = false;

  @override
  void initState() {
    super.initState();

    Wakelock.enable();
    _isInitialized = false;
    _initializeCamera();
  }

  void _initializeCamera() async {
    cameras = await availableCameras();
    _controller = CameraController(cameras[1], ResolutionPreset.low);
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {
        _isInitialized = true;
      });
      _startStreaming(); // 카메라 컨트롤러가 초기화된 후에 호출
    });
  }

  void _startStreaming() async {
    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);

    bool isReady = await getReady(auth.memberId, widget.name, 3);

    if (isReady == true) {
      tts.setSpeechRate(0.6);

      tts.speak("${widget.name}를 시작합니다. 신호에 맞춰 동작을 수행해주세요");
    }

    Timer timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      // "삑"이라는 문자열을 말하기
      if (!_isStreamingPaused) {
        await tts.speak("삑");

        // 1초 후에 다음 코드를 실행
        await Future.delayed(const Duration(seconds: 1), () {
          _controller.takePicture().then((XFile? file) {
            if (file != null) {
              // 이미지 파일을 읽고 서버에 보내는 로직
              File imageFile = File(file.path);
              List<int> imageBytes = imageFile.readAsBytesSync();
              _sendFrameToServer(imageBytes);
            }
          });
        });
      }
    });

    if (_isStreamingPaused == true) {
      timer.cancel();
    }
  }

  Future<bool> getReady(
      int memberId, String exerciseName, int exerciseCount) async {
    final url = Uri.parse('https://6b53-1-209-144-251.ngrok-free.app/3/start');
    var response = await http.post(url,
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: json.encode({
          "exerciseName": exerciseName,
          "exerciseCount": exerciseCount,
        }));
    if (response.statusCode == 200) {
      return true;
    } else {
      _isInitialized = false;
      _isStreamingPaused = true;
      Navigator.of(context).popUntil((route) => route.isFirst);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const WorkOut()),
      );
      return false;
    }
  }

  void _sendFrameToServer(List<int> bytes) async {
    String url = 'https://6b53-1-209-144-251.ngrok-free.app/frame';
    try {
      // Send POST request with image bytes
      // 바이트 리스트를 Uint8List로 변환
      Uint8List uint8list = Uint8List.fromList(bytes);

      // Uint8List를 FormData에 추가
      FormData formData = FormData.fromMap({
        'frame': MultipartFile.fromBytes(
          uint8list,
          filename: 'image.png',
        ),
      });
      // Dio 인스턴스 생성
      Dio dio = Dio();

      // POST 요청 보내기
      Response response = await dio.post(
        url,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      if (response.statusCode == 200) {
        tts.speak(response.data);

        if (response.data == "운동이 끝났습니다") {
          setState(() {
            _isInitialized = false;
            _isStreamingPaused = true;
            isReady = false;
          });

          getResultAfterWorkout();
        }
        // Handle response from server if needed
        print('Frame processed successfully');
      } else {
        print('Failed to send frame to server');
      }
    } catch (e) {
      print('Error sending frame to server: $e');
    }
  }

  void getResultAfterWorkout() async {
    final url =
        Uri.parse('https://6b53-1-209-144-251.ngrok-free.app/exercise/output');

    final response = await http.get(url);

    // if (response.statusCode == 200) {
    //   List<WorkoutResult> results = [];
    //   final Map<String, dynamic> data =
    //       jsonDecode(utf8.decode(response.bodyBytes));
    //   WorkoutResult workoutResult = WorkoutResult.fromJson(data);

    //   results.add(workoutResult);
    //   Navigator.pop(context);
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => WorkoutResultPage(
    //                 results: results,
    //               )));
    // }
  }

  @override
  void dispose() {
    _isInitialized = false;
    _isStreamingPaused = true;
    _controller.dispose(); // 카메라 컨트롤러 해제
    Wakelock.disable(); // Wakelock 비활성화
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    WorkoutProvider workoutProvider = Provider.of<WorkoutProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            CameraPreview(_controller),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                  backgroundColor: const Color(boxColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  // Pause streaming when dialog is shown
                  setState(() {
                    _isStreamingPaused = true;
                  });
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => WorkOutExplain(
                      workout: workoutProvider.todayWorkout,
                      pop: true,
                    ),
                  ).then((_) {
                    setState(() {
                      _isStreamingPaused = false;
                    });
                  });
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(speakerIcon, color: Color(fontYellowColor), size: 40),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "설명 다시 듣기",
                          style: TextStyle(
                              fontSize: 36,
                              color: Color(fontYellowColor),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
