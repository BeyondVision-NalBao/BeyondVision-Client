import 'package:beyond_vision/core/core.dart';
import 'package:beyond_vision/service/speech_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Speaker extends StatefulWidget {
  const Speaker({super.key});

  @override
  State<Speaker> createState() => _SpeakerState();
}

class _SpeakerState extends State<Speaker> {
  late SpeechToText _speechToText;
  late Speech speech;
  bool isListening = false;

  @override
  void initState() {
    // TODO: implement initState
    _speechToText = SpeechToText();
    speech = Speech(_speechToText);
    speech.initSpeech(_speechToText);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            const SizedBox(height: 70),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                    color: const Color(boxColor),
                    borderRadius: BorderRadius.circular(30)),
                child: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    "무엇을 하고\n싶으신가요?",
                    style: TextStyle(
                      fontSize: 40,
                      color: Color(fontYellowColor),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            CustomPaint(
              size: const Size(50, 50), // 원하는 크기로 조절
              painter: InvertedTrianglePainter(),
            ),
            const SizedBox(
              height: 350,
            ),
            CircleAvatar(
              radius: 50,
              backgroundColor: const Color(boxColor),
              child: IconButton(
                onPressed: () {
                  // 상태 변경 및 setState() 호출
                  setState(() {
                    if (isListening) {
                      speech.stopListening();
                    } else {
                      speech.startListening();
                    }
                    isListening = !isListening;
                  });
                },
                tooltip: 'Listen',
                icon: Icon(
                  // 상태에 따라 아이콘 변경
                  isListening ? Icons.stop : Icons.mic,
                  size: 50,
                  color: const Color(fontYellowColor),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                _speechToText.isListening
                    ? speech.lastWords
                    : speech.speechEnabled
                        ? 'Tap the microphone to start listening...'
                        : 'Speech not available',
              ),
            ),
          ],
        ));
  }
}

class InvertedTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(boxColor)
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 0); // 왼쪽 하단
    path.lineTo(size.width, 0); // 상단 중앙
    path.lineTo(size.width / 2, size.height); // 오른쪽 하단
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
