import 'dart:math';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'dart:io';

double translateX(
  double x,
  Size canvasSize,
  Size imageSize,
  InputImageRotation rotation,
  CameraLensDirection cameraLensDirection,
) {
  switch (rotation) {
    case InputImageRotation.rotation90deg:
      return x *
          canvasSize.width /
          (Platform.isIOS ? imageSize.width : imageSize.height);
    case InputImageRotation.rotation270deg:
      return canvasSize.width -
          x *
              canvasSize.width /
              (Platform.isIOS ? imageSize.width : imageSize.height);
    case InputImageRotation.rotation0deg:
    case InputImageRotation.rotation180deg:
      switch (cameraLensDirection) {
        case CameraLensDirection.back:
          return x * canvasSize.width / imageSize.width;
        default:
          return canvasSize.width - x * canvasSize.width / imageSize.width;
      }
  }
}

double translateY(
  double y,
  Size canvasSize,
  Size imageSize,
  InputImageRotation rotation,
  CameraLensDirection cameraLensDirection,
) {
  switch (rotation) {
    case InputImageRotation.rotation90deg:
    case InputImageRotation.rotation270deg:
      return y *
          canvasSize.height /
          (Platform.isIOS ? imageSize.height : imageSize.width);
    case InputImageRotation.rotation0deg:
    case InputImageRotation.rotation180deg:
      return y * canvasSize.height / imageSize.height;
  }
}

class PosePainter extends CustomPainter {
  PosePainter(
      this.poses, this.imageSize, this.rotation, this.cameraLensDirection);

  final Pose poses;
  final Size imageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.green;

    final leftPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.yellow;

    final rightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.blueAccent;

    poses.landmarks.forEach((key, value) {
      //translateX, Y를 통해 이미지 내의 좌표값을 구함
      canvas.drawCircle(
          Offset(
              translateX(
                  value.x, size, imageSize, rotation, cameraLensDirection),
              translateY(
                  value.y, size, imageSize, rotation, cameraLensDirection)),
          1,
          paint);
    });

    paintLine(PoseLandmarkType type1, PoseLandmarkType type2, Paint paintType) {
      final PoseLandmark joint1 = poses.landmarks[type1]!;
      final PoseLandmark joint2 = poses.landmarks[type2]!;

      canvas.drawLine(
          Offset(
              translateX(
                  joint1.x, size, imageSize, rotation, cameraLensDirection),
              translateY(
                  joint1.y, size, imageSize, rotation, cameraLensDirection)),
          Offset(
              translateX(
                  joint2.x, size, imageSize, rotation, cameraLensDirection),
              translateY(
                  joint2.y, size, imageSize, rotation, cameraLensDirection)),
          paintType);
    }

    paintLine(
        PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, leftPaint);
    paintLine(
        PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, leftPaint);
    paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow,
        rightPaint);
    paintLine(
        PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, rightPaint);
    paintLine(
        PoseLandmarkType.rightShoulder, PoseLandmarkType.leftShoulder, paint);
    //다리쪽 선
    paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, leftPaint);
    paintLine(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, leftPaint);
    paintLine(
        PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, rightPaint);
    paintLine(
        PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, rightPaint);
    paintLine(PoseLandmarkType.rightHip, PoseLandmarkType.leftHip, paint);
    paintLine(PoseLandmarkType.rightHip, PoseLandmarkType.rightShoulder, paint);
    paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, paint);

    //운동 종류별로 함수 실행
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.poses != poses;
  }
}
