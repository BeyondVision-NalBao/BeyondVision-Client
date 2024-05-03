import 'dart:io';

import 'package:beyond_vision/ml/calculate_degree.dart';
import 'package:beyond_vision/model/record_model.dart';
import 'package:beyond_vision/model/routine_model.dart';
import 'package:beyond_vision/model/workout_model.dart';
import 'package:beyond_vision/provider/workout_provider.dart';
import 'package:beyond_vision/ui/workout/widgets/workout_result.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'package:watch_connectivity/watch_connectivity.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:beyond_vision/ml/painter.dart';

import 'package:beyond_vision/core/constants.dart';
import 'package:beyond_vision/ui/workout/widgets/workout_explain.dart';

class CameraView extends StatefulWidget {
  const CameraView(
      {Key? key,
      this.onCameraFeedReady,
      this.onDetectorViewModeChanged,
      this.onCameraLensDirectionChanged,
      this.initialCameraLensDirection = CameraLensDirection.front,
      required this.exercises,
      required this.memberId,
      required this.weight})
      : super(key: key);

  final VoidCallback? onCameraFeedReady;
  final VoidCallback? onDetectorViewModeChanged;
  final Function(CameraLensDirection direction)? onCameraLensDirectionChanged;
  final CameraLensDirection initialCameraLensDirection;
  final List<RoutineExercise> exercises;
  final int memberId;
  final int weight;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  final watch = WatchConnectivity();

  static List<CameraDescription> _cameras = [];
  CameraController? _controller;
  CustomPaint? customPaint;
  int _cameraIndex = -1;
  double _currentZoomLevel = 1.0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  bool _changingCameraLens = false;
  var _supported = false;
  var _paired = false;
  var _reachable = false;

  FlutterTts tts = FlutterTts();
  bool isSpeaking = false;

  CalculateDegree cal = CalculateDegree();

  String workout = "시작 전";

  List<Map<String, int>> resultFromWatch = [];
  int exerciseTime = 0;
  int heartRate = 0;
  double calories = 0;
  int successCount = 0;
  List<Record> results = [];
  bool isPaused = false;
  int index = 0;
  void sendMessagetoWatch(String msg) {
    final message = {'data': msg};
    watch.sendMessage(message);
    // setState(() => _log.add('Sent message: $message'));
  }

  int exercise = 0;
  final PoseDetector poseDetector = PoseDetector(
    options: PoseDetectorOptions(
        mode: PoseDetectionMode.single, model: PoseDetectionModel.base),
  );

  @override
  void initState() {
    Wakelock.enable();
    super.initState();
    tts.setLanguage('ko-KR');
    tts.setSpeechRate(0.8);
    tts.setPitch(0.9);
    _initialize();
    initPlatformState();

    watch.messageStream.listen((e) {
      List<dynamic> parsedJson = jsonDecode(e['data']);
      exerciseTime = parsedJson[0]['time'];
      heartRate = parsedJson[0]['heartRate'];
      calories = parsedJson[0]['calories'];
      finishExercise();
      setState(() {});
    });
  }

  startNewExercise() {
    cal.setCount(widget.exercises[index].exerciseCount);
    sendMessagetoWatch(jsonEncode([
      {
        'exercise': widget.exercises[index].exerciseName,
        'weight': widget.weight
      }
    ]));
  }

  void initPlatformState() async {
    _supported = await watch.isSupported;
    _paired = await watch.isPaired;
    _reachable = await watch.isReachable;
    setState(() {});
  }

  void _initialize() async {
    if (_cameras.isEmpty) {
      _cameras = await availableCameras();
    }
    for (var i = 0; i < _cameras.length; i++) {
      if (_cameras[i].lensDirection == widget.initialCameraLensDirection) {
        _cameraIndex = i;
        break;
      }
    }
    if (_cameraIndex != -1) {
      setState(() {});
      _startLiveFeed();
    }
  }

  Widget _liveFeedBody() {
    if (_cameras.isEmpty) return Container();
    if (_controller == null) return Container();
    if (_controller?.value.isInitialized == false) return Container();
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Center(
            child: switch (_changingCameraLens) {
              true => const Center(
                  child: Text('Changing camera lens'),
                ),
              false => CameraPreview(
                  _controller!,
                  child: customPaint,
                ),
            },
          ),
          _switchLiveCameraToggle(),
        ],
      ),
    );
  }

  Widget _switchLiveCameraToggle() => Positioned(
        bottom: 16,
        right: 16,
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: FloatingActionButton(
            heroTag: Object(),
            onPressed: _switchLiveCamera,
            // backgroundColor: Colors.black54,
            child: Icon(
              Platform.isIOS
                  ? Icons.flip_camera_ios_outlined
                  : Icons.flip_camera_android_outlined,
              size: 25,
            ),
          ),
        ),
      );

  Future _startLiveFeed() async {
    final camera = _cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller?.getMinZoomLevel().then((value) {
        _currentZoomLevel = value;
        _minAvailableZoom = value;
      });
      _controller?.getMaxZoomLevel().then((value) {
        _maxAvailableZoom = value;
      });

      _controller?.startImageStream(_processCameraImage).then((value) {
        if (widget.onCameraFeedReady != null) {
          widget.onCameraFeedReady!();
        }
        if (widget.onCameraLensDirectionChanged != null) {
          widget.onCameraLensDirectionChanged!(camera.lensDirection);
        }
      });
      initPlatformState();
      setState(() {});
    });
  }

  void _processCameraImage(CameraImage image) async {
    if (DateTime.now().millisecondsSinceEpoch % (1000 ~/ 24) == 0 &&
        cal.count > 0) {
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage == null) return;

      // 비동기로 Pose Detection을 처리하고 완료될 때까지 대기
      final poses = await _processImageAsync(inputImage);

      // Pose Detection 결과를 사용하여 UI 업데이트
      if (inputImage.metadata?.size != null &&
          inputImage.metadata?.rotation != null &&
          poses.isNotEmpty) {
        final painter = PosePainter(
          poses[0],
          inputImage.metadata!.size,
          inputImage.metadata!.rotation,
          CameraLensDirection.front,
        );
        String result =
            cal.exercise(poses[0], widget.exercises[index].exerciseName);

        if (!isSpeaking) {
          isSpeaking = true;
          await tts.speak(result).then((_) {
            isSpeaking = false; // 말하기가 끝나면 상태 업데이트
          });
        }
        setState(() {
          customPaint = CustomPaint(painter: painter);
        });
      }
    } else if (cal.count == 0) {
      _stopLiveFeed();
    }
    return;
  }

  Future<List<Pose>> _processImageAsync(InputImage inputImage) async {
    // Pose Detection을 비동기적으로 처리
    final poses = await poseDetector.processImage(inputImage);

    return poses;
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();

    sendMessagetoWatch('stop');
    _controller = null;
  }

  Future _switchLiveCamera() async {
    setState(() => _changingCameraLens = true);
    _cameraIndex = (_cameraIndex + 1) % _cameras.length;
    await _stopLiveFeed();
    await _startLiveFeed();
    setState(() => _changingCameraLens = false);
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_controller == null) return null;

    final camera = _cameras[_cameraIndex];
    final sensorOrientation = camera.sensorOrientation;

    InputImageRotation? rotation;
    if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[_controller!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);

    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(
          image.width.toDouble(),
          image.height.toDouble(),
        ),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }

  void finishExercise() async {
    //success count
    successCount = cal.success;
    //심박수 데이터, 운동시간, 칼로리
    if (exerciseTime != 0) {
      Record record = Record(
          null,
          successCount,
          exerciseTime,
          widget.exercises[index].exerciseName,
          DateTime.now(),
          successCount,
          calories,
          heartRate);

      results.add(record);
      setState(() {});
    }
  }

  saveRecord() async {
    //   //서버로 저장

    // final url = Uri.parse('http://34.64.89.205/api/v1/exercise/record/${widget.workout.exerciseId}')
    final url = Uri.parse(
        'https://403e-1-209-144-250.ngrok-free.app/api/v1/exercise/record/$exercise');

    var response = await http.post(url,
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: json.encode({
          "exerciseTime": exerciseTime,
          "exerciseCount": widget.exercises[index].exerciseCount,
          "memberId": widget.memberId,
          "successCount": successCount,
          "caloriesBurnedSum": calories,
          "averageHeartRate": heartRate
        }));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (index == widget.exercises.length) {
        goToResult();
      } else {
        cal.success = 0;
        index++;
        setState(() {});
      }
    }
    throw Error();
  }

  void goToResult() {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WorkoutResultPage(
                  results: results,
                )));
  }

  void setExerciseId(WorkoutProvider provider) {
    WorkOut workout =
        provider.findWorkout(widget.exercises[index].exerciseName);
    exercise = workout.exerciseId;
  }

  @override
  void dispose() {
    // 카메라 컨트롤러 해제
    Wakelock.disable(); // Wakelock 비활성화
    tts.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WorkoutProvider workoutProvider = Provider.of<WorkoutProvider>(context);
    setExerciseId(workoutProvider);

    return Scaffold(
      body: Column(
        children: [
          isPaused == false ? _liveFeedBody() : Container(),
          ElevatedButton(
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
                isPaused = true;
              });
              showDialog(
                context: context,
                builder: (BuildContext context) => WorkOutExplain(
                  workout: workoutProvider
                      .findWorkout(widget.exercises[index].exerciseName),
                  pop: true,
                ),
              ).then((_) {
                setState(() {
                  isPaused = false;
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
        ],
      ),
    );
  }
}
