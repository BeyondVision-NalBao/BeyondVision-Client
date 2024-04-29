import 'dart:io';

import 'package:beyond_vision/ml/calculate_degree.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

import 'package:beyond_vision/ml/painter.dart';

class CameraView extends StatefulWidget {
  const CameraView(
      {Key? key,
      this.onCameraFeedReady,
      this.onDetectorViewModeChanged,
      this.onCameraLensDirectionChanged,
      this.initialCameraLensDirection = CameraLensDirection.front,
      required this.name})
      : super(key: key);

  final VoidCallback? onCameraFeedReady;
  final VoidCallback? onDetectorViewModeChanged;
  final Function(CameraLensDirection direction)? onCameraLensDirectionChanged;
  final CameraLensDirection initialCameraLensDirection;
  final String name;

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

  final _supported = false;
  var _paired = false;
  final _reachable = false;
  final _context = <String, dynamic>{};
  final _receivedContexts = <Map<String, dynamic>>[];
  final _log = <String>[];
  FlutterTts tts = FlutterTts();

  CalculateDegree cal = CalculateDegree();

  String workout = "시작 전";

  void sendMessageToWatch() {}

  void startMessage() {
    final message = {'data': 'phone'};
    watch.sendMessage(message);
    print("qhsoTwl");
    // setState(() => _log.add('Sent message: $message'));
  }

  void sendMessage() {
    final message = {'data': 'start'};
    watch.sendMessage(message);
    // setState(() => _log.add('Sent message: $message'));
  }

  void sendContext() {
    print("anjwl");
    final context = {'data': 'stop'};
    //_watch.updateApplicationContext(context);

    watch.sendMessage(context);

    //setState(() => _log.add('Sent message: $context'));
  }

  final PoseDetector poseDetector = PoseDetector(
    options: PoseDetectorOptions(
        mode: PoseDetectionMode.single, model: PoseDetectionModel.base),
  );

  @override
  void initState() {
    super.initState();

    tts.setLanguage('ko-KR');
    tts.setSpeechRate(0.8);
    tts.setPitch(0.9);
    _initialize();

    if (_paired == true) {
      watch.messageStream.listen((e) => print(e['data']));
    }
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
      _paired = true;
      setState(() {});
      startMessage();
      _startLiveFeed();
    }
  }

  @override
  void dispose() {
    _stopLiveFeed();
    sendContext();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _liveFeedBody(),
    );
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
      setState(() {});
    });
  }

  void _processCameraImage(CameraImage image) async {
    if (DateTime.now().millisecondsSinceEpoch % (1000 ~/ 24) == 0) {
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
        String result = cal.exercise(poses[0], widget.name);
        print("result: $result");
        await tts.speak(result);
        setState(() {
          customPaint = CustomPaint(painter: painter);
        });
      }
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
}
