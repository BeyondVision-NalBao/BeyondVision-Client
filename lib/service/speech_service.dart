import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Speech {
  late SpeechToText speechText;
  String lastWords = '';
  bool speechEnabled = false;
  String notice = "설명과 이동 중 하나를 선택해주세요";

  Speech(SpeechToText speechToText) {
    speechText = speechToText;
  }

  void initSpeech(SpeechToText speechText) async {
    speechEnabled = await speechText.initialize();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    lastWords = result.recognizedWords;
  }

  void speechString(String words) {}
  void startListening() async {
    await speechText.listen(onResult: _onSpeechResult);
  }

  void stopListening() async {
    await speechText.stop().then((value) => {
          if (lastWords.contains("이동"))
            {}
          else if (lastWords.contains("설명"))
            {}
          else
            {}
        });
  }
}
