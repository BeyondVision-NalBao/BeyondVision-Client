import 'dart:math';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'dart:io';

class CalculateDegree {
  int count = 0;
  bool direction = false;
  bool ready = false;

  String exercise(Pose pose, String exercise) {
    String result = "";
    double threshold;

    if (ready == true && direction == true) {
      if (exercise == "스쿼트") {
      } else if (exercise == "숄더프레스") {
        threshold = initCalculateAngle(pose, PoseLandmarkType.leftElbow,
            PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip);
        print(threshold);
        if (threshold > 45) {
          print('여기서?');
          result = shoulderPress(pose);
        }
      } else if (exercise == "레터럴레이즈") {
      } else if (exercise == "헌드레드") {
      } else if (exercise == "플랭크") {
      } else if (exercise == "프론트레이즈") {
      } else if (exercise == "제트업") {
      } else if (exercise == "브릿지") {
      } else if (exercise == "스트레칭1") {
      } else if (exercise == "스트레칭2") {
      } else if (exercise == "스트레칭3") {}
    } else if (ready == false) {
      isReady(pose);
    } else if (direction == false) {
      setDirection(pose, exercise);
    } else {
      isReady(pose);
    }

    return result;
  }

  String isReady(pose) {
    double maxHeight = 300;
    double minHeight = 150;
    final PoseLandmark joint1 = pose.landmarks[PoseLandmarkType.leftHeel];
    final PoseLandmark joint2 = pose.landmarks[PoseLandmarkType.leftEye];

    double height = joint2.y - joint1.y;

    if (maxHeight >= height && minHeight <= height) {
      ready = true;
      return "운동을 시작합니다.";
    } else if (maxHeight < height) {
      ready = false;
      return "뒤로 가주세요";
    } else if (minHeight > height) {
      ready = false;
      return "앞으로 와주세요";
    }
    return "";
  }

  String setDirection(Pose pose, String name) {
    if (exercise == "스쿼트" ||
        exercise == "헌드레드" ||
        exercise == "플랭크" ||
        exercise == "프론트레이즈" ||
        exercise == "제트업" ||
        exercise == "브릿지") {
      //측면

      final PoseLandmark joint1 = pose.landmarks[PoseLandmarkType.leftHip]!;
      final PoseLandmark joint2 = pose.landmarks[PoseLandmarkType.rightHip]!;
      final pelvis = (joint1.x - joint2.x).abs();

      if (pelvis <= 20) {
        direction = false;
        return "측면입니다";
      } else {
        return "측면으로 서주세요";
      }
    } else if (exercise == "숄더프레스" || exercise == "레터럴레이즈") {
      //정면

      final PoseLandmark joint1 = pose.landmarks[PoseLandmarkType.leftHip]!;
      final PoseLandmark joint2 = pose.landmarks[PoseLandmarkType.rightHip]!;
      final pelvis = (joint1.x - joint2.x).abs();

      if (pelvis <= 30) {
        direction = false;
        return "정면으로 서 주세요";
      } else {
        return "정면입니다.";
      }
    } else if (exercise == "스트레칭1") {
    } else if (exercise == "스트레칭2") {
    } else if (exercise == "스트레칭3") {}

    return "";
  }

  double initCalculateAngle(pose, a, b, c) {
    final PoseLandmark joint1 = pose.landmarks[a];
    final PoseLandmark joint2 = pose.landmarks[b];

    final PoseLandmark joint3 = pose.landmarks[c];

    var radians = atan2(joint3.y - joint2.y, joint3.x - joint2.x) -
        atan2(joint1.y - joint2.y, joint1.x - joint2.x);
    var angle = (radians * 180.0 / pi).abs();
    if (angle > 180.0) {
      angle = 360 - angle;
    }
    print(angle);
    return angle;
  }

  double calculateAngle(a, b, c) {
    var radians = atan2(c.y - b.y, c.x - b.x) - atan2(a.y - b.y, a.x - b.x);
    var angle = (radians * 180.0 / pi).abs();
    if (angle > 180.0) {
      angle = 360 - angle;
    }
    print(angle);
    return angle;
  }

  String squart(pose) {
    double leftThreshold = 65.0;
    double rightThreshold = 65.0;
    String result = "";
    final PoseLandmark joint1 = pose.landmarks[PoseLandmarkType.leftHip];
    final PoseLandmark joint2 = pose.landmarks[PoseLandmarkType.leftKnee];
    final PoseLandmark joint3 = pose.landmarks[PoseLandmarkType.leftHeel];

    final PoseLandmark joint4 = pose.landmarks[PoseLandmarkType.rightHip];
    final PoseLandmark joint5 = pose.landmarks[PoseLandmarkType.rightKnee];
    final PoseLandmark joint6 = pose.landmarks[PoseLandmarkType.rightHeel];

    final leftDegree = calculateAngle(joint1, joint2, joint3);
    final rightDegree = calculateAngle(joint4, joint5, joint6);

    if (leftThreshold <= leftDegree && rightThreshold <= rightDegree) {
      print("잘하고 있습니다.");
      result = "잘하고 있습니다.";
    } else if (leftThreshold <= leftDegree) {
      print("오른팔을 조금 더 들어주세요");
      result = "오른팔을 조금 더 들어주세요.";
    } else if (leftThreshold > leftDegree) {
      print("왼쪽 팔을 조금 더 들어주세요");
      result = "왼쪽 팔을 조금 더 들어주세요.";
    } else {
      result = "양쪽 팔을 조금 더 들어주세요.";
      print("exercise result: $result");
    }

    return result;
  }

  String shoulderPress(pose) {
    String result = "";
    double leftThreshold = 85;
    double rightThreshold = 85;
    final PoseLandmark joint1 = pose.landmarks[PoseLandmarkType.leftShoulder];
    final PoseLandmark joint2 = pose.landmarks[PoseLandmarkType.leftElbow];
    final PoseLandmark joint3 = pose.landmarks[PoseLandmarkType.leftWrist];

    final PoseLandmark joint4 = pose.landmarks[PoseLandmarkType.rightShoulder];
    final PoseLandmark joint5 = pose.landmarks[PoseLandmarkType.rightElbow];
    final PoseLandmark joint6 = pose.landmarks[PoseLandmarkType.rightWrist];

    final leftDegree = calculateAngle(joint1, joint2, joint3);
    final rightDegree = calculateAngle(joint4, joint5, joint6);
    final leftHeight = joint1.y - joint2.y;
    final rightHeight = joint4.y - joint5.y;

    if (leftThreshold <= leftDegree && rightThreshold <= rightDegree) {
      result = "잘하고 있습니다.";
    } else if (leftThreshold <= leftDegree && rightThreshold > rightDegree) {
      result = "오른팔을 90도로 만들어주세요";
    } else if (leftThreshold > leftDegree && rightThreshold <= rightDegree) {
      result = "왼쪽 팔을 90도로 만들어주세요";
    } else if (leftHeight > 10) {
      result = "왼쪽 팔꿈치가 너무 내려갔습니다.";
    } else if (leftHeight < -10) {
      result = "왼쪽 팔을 더 구부려주세요";
    } else if (rightHeight > 10) {
      result = "오른쪽 팔꿈치가 너무 내려갔습니다.";
    } else if (leftHeight < -10) {
      result = "오른쪽 팔을 더 구부려주세요";
    }
    return result;
  }

  String lateralRaise(pose) {
    //양팔을 들어올리기 좌우로
    //어깨 - 손목 높이
    String result = "";
    double leftThreshold = 85;
    double rightThreshold = 85;
    final PoseLandmark joint1 = pose.landmarks[PoseLandmarkType.leftShoulder];
    final PoseLandmark joint3 = pose.landmarks[PoseLandmarkType.leftWrist];

    final PoseLandmark joint4 = pose.landmarks[PoseLandmarkType.rightShoulder];
    final PoseLandmark joint6 = pose.landmarks[PoseLandmarkType.rightWrist];

    //어깨 - 손목
    //양수면 어깨가 위
    final leftHeight = joint1.y - joint3.y;
    final rightHeight = joint4.y - joint6.y;

    if (leftHeight > 20) {
      result = "왼쪽 팔을 더 들어주세요";
    } else if (leftHeight < -20) {
      result = "왼쪽 팔이 너무 올라갔습니다.";
    } else if (rightHeight > 20) {
      result = "오른쪽 팔을 더 들어주세요";
    } else if (leftHeight < -20) {
      result = "오른쪽 팔이 너무 올라갔습니다.";
    }
    return result;
  }

  void hundred() {}

  void plank() {}

  void frontRaise() {}

  void zetUp() {}

  void bridge() {}

  void stretch1() {}

  void stretch2() {}

  void stretch3() {}
}
