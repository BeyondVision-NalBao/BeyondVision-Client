import 'dart:io';

import 'package:beyond_vision/ml/posenet.dart';
import 'package:beyond_vision/ui/workout/widgets/workout_camera_view.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:image_picker/image_picker.dart';

class FaceDetectorApp extends StatefulWidget {
  const FaceDetectorApp({super.key});

  @override
  State<FaceDetectorApp> createState() => _FaceDetectorAppState();
}

class _FaceDetectorAppState extends State<FaceDetectorApp> {
  final PoseDetector poseDetector = PoseDetector(
    options: PoseDetectorOptions(
        mode: PoseDetectionMode.single, model: PoseDetectionModel.base),
  );
  @override
  void dispose() {
    poseDetector.close();
    super.dispose();
  }

  CustomPaint? customPaint;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("자세 인식 앱"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: CameraView(customPaint: customPaint, name: ""),
    );
  }

  Future _getImage(ImageSource source) async {}

  Future _processFile(String path) async {}

  Future<void> _processImage(InputImage inputImage) async {
    String resultText;
    setState(() {
      resultText = '';
    });
    final poses = await poseDetector.processImage(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = PosePainter(poses, inputImage.metadata!.size,
          inputImage.metadata!.rotation, CameraLensDirection.back);
      setState(() {
        customPaint = CustomPaint(painter: painter);
      });
    } else {
      resultText = "pose";
      setState(() {});
    }
  }
}
