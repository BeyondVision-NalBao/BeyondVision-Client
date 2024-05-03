import 'package:beyond_vision/core/constants.dart';
import 'package:beyond_vision/model/user_model.dart';
import 'package:beyond_vision/service/tts_service.dart';
import 'package:beyond_vision/service/user_service.dart';
import 'package:beyond_vision/ui/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum SingingCharacter { lafayette, jefferson }

class NewInfo extends StatefulWidget {
  final User currentUser;
  const NewInfo({super.key, required this.currentUser});

  @override
  State<NewInfo> createState() => _NewInfoState();
}

class _NewInfoState extends State<NewInfo> {
  SingingCharacter? _character = SingingCharacter.lafayette;
  TextEditingController ageController = TextEditingController();
  TextEditingController goalController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  UserService userService = UserService();
  @override
  void initState() {
    // TODO: implement initState
    TtsService ttsService = TtsService();
    FlutterTts tts = FlutterTts();

    tts.setSpeechRate(0.4);
    tts.setPitch(0.9);
    tts.speak(ttsService.newInfoExplain);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "성별 선택",
                  style: TextStyle(
                      fontSize: 40,
                      color: Color(fontYellowColor),
                      fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      title: const Text(
                        '남성',
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                      leading: Radio<SingingCharacter>(
                        value: SingingCharacter.lafayette,
                        groupValue: _character,
                        activeColor: const Color(fontYellowColor),
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text(
                        '여성',
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                      leading: Radio<SingingCharacter>(
                        value: SingingCharacter.jefferson,
                        groupValue: _character,
                        activeColor: const Color(fontYellowColor),
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "나이 입력",
                  style: TextStyle(
                      fontSize: 40,
                      color: Color(fontYellowColor),
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  style: const TextStyle(
                      color: Color(fontYellowColor), fontSize: 40),
                  keyboardType: TextInputType.number,
                  controller: ageController,
                  // onSubmitted: (String value) async{await showDialog()},
                ),
              ),
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "운동 목표 입력(분)",
                  style: TextStyle(
                      fontSize: 40,
                      color: Color(fontYellowColor),
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  style: const TextStyle(
                      color: Color(fontYellowColor), fontSize: 40),
                  keyboardType: TextInputType.number,
                  controller: goalController,
                  // onSubmitted: (String value) async{await showDialog()},
                ),
              ),
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "몸무게 입력",
                  style: TextStyle(
                      fontSize: 40,
                      color: Color(fontYellowColor),
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  style: const TextStyle(
                      color: Color(fontYellowColor), fontSize: 40),
                  keyboardType: TextInputType.number,
                  controller: weightController,
                  // onSubmitted: (String value) async{await showDialog()},
                ),
              ),
              Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(boxColor)),
                    onPressed: () async {
                      String gender;
                      _character == SingingCharacter.lafayette
                          ? gender = '남성'
                          : gender = '여성';
                      User user = await userService.postUserInfo(
                          int.parse(ageController.text),
                          gender,
                          int.parse(goalController.text),
                          int.parse(weightController.text),
                          widget.currentUser);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(
                                  exerciseGoal: int.parse(goalController.text),
                                  weight: int.parse(weightController.text),
                                  isFirst: true)));
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('작성완료',
                          style: TextStyle(
                              fontSize: 40,
                              color: Color(fontYellowColor),
                              fontWeight: FontWeight.bold)),
                    )),
              ),
            ],
          ),
        ));
  }
}
