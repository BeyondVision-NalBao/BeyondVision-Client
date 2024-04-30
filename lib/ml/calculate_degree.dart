import 'dart:math';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class CalculateDegree {
  int count = 0;
  int success = 0;
  bool direction = false;
  bool ready = false;

  String exercise(Pose pose, String name) {
    String result = "";
    double threshold;
    if (ready == true && direction == true) {
      if (name == "스쿼트") {
        threshold = initCalculateAngle(pose, PoseLandmarkType.leftHip,
            PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle);
        if (threshold < 135) {
          count--;
          result = squat(pose);
        } else {
          result = "더 앉아주세요";
        }
      } else if (name == "숄더프레스") {
        threshold = initCalculateAngle(pose, PoseLandmarkType.leftWrist,
            PoseLandmarkType.leftElbow, PoseLandmarkType.leftShoulder);
        if (threshold < 100) {
          count--;
          result = shoulderPress(pose);
        } else {
          result = "팔을 더 구부려주세요";
        }
      } else if (name == "레터럴레이즈") {
        threshold = initCalculateAngle(pose, PoseLandmarkType.leftElbow,
            PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip);
        if (threshold > 45) {
          count--;
          result = lateralRaise(pose);
        }
      } else if (name == "헌드레드") {
      } else if (name == "플랭크") {
        threshold = initCalculateAngle(pose, PoseLandmarkType.leftShoulder,
            PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist);
        if (threshold > 45) {
          count--;
          result = plank(pose);
        } else {
          result = "몸을 뒤로 당겨 어깨와 팔꿈치가 수직이 되게 해주세요";
        }
      } else if (name == "프론트레이즈") {
        threshold = initCalculateAngle(pose, PoseLandmarkType.leftWrist,
            PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip);
        if (threshold > 45) {
          count--;
          result = frontRaise(pose);
        } else {
          result = "팔을 더 들어주세요";
        }
      } else if (name == "제트업") {
      } else if (name == "브릿지") {
        threshold = initCalculateAngle(pose, PoseLandmarkType.leftShoulder,
            PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee);
        if (threshold > 120) {
          result = bridge(pose);
        } else {
          result = "발을 좀 더 아래에 두세요";
        }
      } else if (name == "스트레칭1") {
      } else if (name == "스트레칭2") {
      } else if (name == "스트레칭3") {}
    } else if (direction == false) {
      return setDirection(pose, name);
    } else if (ready == false) {
      return isReady(pose);
    }

    return result;
  }

  void setCount(int countSet) {
    count = countSet;
  }

  String isReady(pose) {
    String result = "";

    //팔길이 생각하기
    double maxHeight = 400;
    double minHeight = 250;
    final PoseLandmark joint1 = pose.landmarks[PoseLandmarkType.leftHeel];
    final PoseLandmark joint2 = pose.landmarks[PoseLandmarkType.leftEye];

    double height = joint1.y - joint2.y;

    //x 좌표로 오른쪽, 왼쪽이 모두 프레임에 들어왔는지 확인하기

    if (maxHeight >= height && minHeight <= height) {
      ready = true;
      result = "운동을 시작합니다.";
    } else if (maxHeight < height) {
      ready = false;
      result = "뒤로 가주세요";
    } else if (minHeight > height) {
      ready = false;
      result = "앞으로 와주세요";
    }
    print(result);
    return result;
  }

  String setDirection(Pose pose, String name) {
    if (name == "스쿼트" ||
        name == "헌드레드" ||
        name == "플랭크" ||
        name == "프론트레이즈" ||
        name == "제트업" ||
        name == "브릿지") {
      //측면

      final PoseLandmark joint1 = pose.landmarks[PoseLandmarkType.leftHip]!;
      final PoseLandmark joint2 = pose.landmarks[PoseLandmarkType.rightHip]!;
      final pelvis = (joint1.x - joint2.x).abs();

      if (pelvis <= 20) {
        direction = true;
        return "측면입니다";
      } else {
        direction = false;
        return "측면으로 서주세요";
      }
    } else if (name == "숄더프레스" || name == "레터럴레이즈") {
      //정면

      final PoseLandmark joint1 = pose.landmarks[PoseLandmarkType.leftHip]!;
      final PoseLandmark joint2 = pose.landmarks[PoseLandmarkType.rightHip]!;
      final pelvis = (joint1.x - joint2.x).abs();

      if (pelvis <= 30) {
        direction = false;
        return "정면으로 서 주세요";
      } else {
        direction = true;
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
    return angle;
  }

  double calculateAngle(a, b, c) {
    var radians = atan2(c.y - b.y, c.x - b.x) - atan2(a.y - b.y, a.x - b.x);
    var angle = (radians * 180.0 / pi).abs();
    if (angle > 180.0) {
      angle = 360 - angle;
    }
    return angle;
  }

  String squat(pose) {
    String result = "";

    //무릎
    final PoseLandmark joint1 = pose.landmarks[PoseLandmarkType.leftHip];
    final PoseLandmark joint2 = pose.landmarks[PoseLandmarkType.leftKnee];
    final PoseLandmark joint3 = pose.landmarks[PoseLandmarkType.leftHeel];
    final firstLimit = calculateAngle(joint1, joint2, joint3);
    //85-95

    //엉덩이 힌지가 불안한 경우: 100~ (무게중심이 앞에 있는경우)

    //힙 각도
    final PoseLandmark joint4 = pose.landmarks[PoseLandmarkType.leftShoulder];
    final PoseLandmark joint5 = pose.landmarks[PoseLandmarkType.leftHip];
    final PoseLandmark joint6 = pose.landmarks[PoseLandmarkType.leftKnee];
    final secondLimit = calculateAngle(joint4, joint5, joint6);
    //70-80
    //등이 구부러진 자세: ~60

    //무릎 100 이상 && 힙 70 미만 => 상체를 바르게 세워야함
    //무릎 100이상 && 힙 100이상 => 무릎이 튀어나옴

    if (firstLimit > 100 && secondLimit > 100) {
      result = "무릎이 발보다 앞으로 나와있습니다.";
    } else if (firstLimit > 100 && secondLimit > 70) {
      result = "발 뒷꿈치에 힘을 주어 무게중심을 뒤로 보내주세요";
    } else if (firstLimit > 100 && secondLimit < 70) {
      result = "상체를 더 세워주세요";
    } else if (firstLimit < 100 && secondLimit < 60) {
      result = "등을 곧게 펴주세요";
    } else if (firstLimit > 80 &&
        firstLimit < 100 &&
        secondLimit > 70 &&
        secondLimit < 80) {
      success++;
      result = "잘하고 있습니다.";
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
      success++;
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
    } else {
      result = "잘하고 있습니다.";
      success++;
    }
    return result;
  }

  String plank(pose) {
    String result = "";
    //귀- 어깨 - 팔꿈치
    final PoseLandmark joint1 = pose.landmarks[PoseLandmarkType.leftEar];
    final PoseLandmark joint2 = pose.landmarks[PoseLandmarkType.leftShoulder];
    final PoseLandmark joint3 = pose.landmarks[PoseLandmarkType.leftElbow];

    double firstLimit = calculateAngle(joint1, joint2, joint3);
    //105~110
    //등이 구부러진 경우: 100도 아래
    //고개가 들린 자세: 130도 이상

    //어깨-골반-무릎
    final PoseLandmark joint4 = pose.landmarks[PoseLandmarkType.leftShoulder];
    final PoseLandmark joint5 = pose.landmarks[PoseLandmarkType.leftHip];
    final PoseLandmark joint6 = pose.landmarks[PoseLandmarkType.leftKnee];

    double secondLimit = calculateAngle(joint4, joint5, joint6);
    //158-162
    //등이 쳐지는 자세: 170도 이상

    //골반-무릎-발목
    final PoseLandmark joint7 = pose.landmarks[PoseLandmarkType.leftHip];
    final PoseLandmark joint8 = pose.landmarks[PoseLandmarkType.leftKnee];
    final PoseLandmark joint9 = pose.landmarks[PoseLandmarkType.leftAnkle];

    double thirdLimit = calculateAngle(joint7, joint8, joint9);
    //171~174

    if (firstLimit < 100) {
      result = "등을 펴주세요";
    } else if (firstLimit > 130) {
      result = "시선을 내려주세요";
    } else if (secondLimit > 170) {
      result = "엉덩이를 들어주세요";
    } else {
      success++;
      result = "잘하고 있습니다";
    }

    return result;
  }

  String frontRaise(pose) {
    String result = "";
    //음수가 되는지 확인
    //어꺠와 손목 높이
    //팔꿈치 구부러지지 않게 확인
    final PoseLandmark joint1 = pose.landmarks[PoseLandmarkType.leftShoulder];
    final PoseLandmark joint2 = pose.landmarks[PoseLandmarkType.leftElbow];

    final PoseLandmark joint3 = pose.landmarks[PoseLandmarkType.leftWrist];
    double firstLimit = joint1.y - joint3.y;
    print("shoulder: $firstLimit");

    double secondLimit = calculateAngle(joint1, joint2, joint3);
    print("secondLimit: $secondLimit");

    if (firstLimit < 5) {
      result = "팔을 더 들어주세요";
    } else if (firstLimit > 30) {
      result = "팔을 어깨 높이까지만 들어주세요";
    } else if (secondLimit < 160) {
      result = "배에 힘을 주고 상체를 곧게 펴세요";
    } else {
      success++;
      result = "잘하고 있습니다.";
    }
    print(result);
    return result;
  }

  String zetUp(pose) {
    String result = "";

    return result;
  }

  String bridge(pose) {
    String result = "";

    //엉덩이 위치
    final PoseLandmark joint1 = pose.landmarks[PoseLandmarkType.leftShoulder];
    final PoseLandmark joint2 = pose.landmarks[PoseLandmarkType.leftHip];
    final PoseLandmark joint3 = pose.landmarks[PoseLandmarkType.leftKnee];
    final firstLimit = calculateAngle(joint1, joint2, joint3);

    print("firstLimit: $firstLimit");
    //170이상

    //등이 굽었는지...
    final PoseLandmark joint4 = pose.landmarks[PoseLandmarkType.leftHip];
    final PoseLandmark joint5 = pose.landmarks[PoseLandmarkType.leftShoulder];
    final PoseLandmark joint6 = pose.landmarks[PoseLandmarkType.leftElbow];
    final secondLimit = calculateAngle(joint4, joint5, joint6);

    print("secondLimit: $secondLimit");
    //30~40

    if (firstLimit < 150 && secondLimit > 50) {
      result = "엉덩이를 좀 더 내려주세요";
    } else if (firstLimit < 150 && secondLimit < 30) {
      result = "엉덩이를 좀 더 올려주세요";
    } else if (secondLimit < 30) {
      result = "상체를 곧게 펴주세요";
    } else if (firstLimit > 170 && secondLimit > 30 && secondLimit < 40) {
      result = "잘하고 있습니다.";
    }

    return result;
  }

  void stretch1(pose) {}

  void stretch2(pose) {}

  void stretch3(pose) {}
}
