import 'package:beyond_vision/core/constants.dart';
import 'package:beyond_vision/service/tts_service.dart';
import 'package:beyond_vision/service/user_service.dart';
import 'package:beyond_vision/ui/home/home.dart';
import 'package:beyond_vision/ui/login/newInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:beyond_vision/model/user_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    // TODO: implement initState
    TtsService ttsService = TtsService();
    FlutterTts tts = FlutterTts();
    tts.setLanguage('ko-KR');
    tts.setSpeechRate(0.4);
    tts.setPitch(0.9);
    tts.speak(ttsService.InitExplain);
    super.initState();
  }

  void signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final UserService userService = UserService();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final String? accessToken = googleAuth.accessToken;

        User currentUser = await userService.getUserData(accessToken);

        if (currentUser.isNewMember!) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => NewInfo(
                      currentUser: currentUser,
                    )),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      memberId: currentUser.memberId!,
                      exerciseGoal: currentUser.exerciseGoal,
                    )),
          );
        }
      }
    } catch (error) {
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     Future.delayed(const Duration(seconds: 2), () {
      //       Navigator.pop(context);
      //     });

      //     return AlertDialog(
      //       shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(8.0)),
      //       backgroundColor: const Color(boxColor), // 원하는 배경 색상으로 변경
      //       content: const SizedBox(
      //         height: 100,
      //         child: Center(
      //           child: Text(
      //             "로그인 오류",
      //             style: TextStyle(
      //                 color: Color(fontYellowColor),
      //                 fontSize: 40,
      //                 fontWeight: FontWeight.bold),
      //           ),
      //         ),
      //       ),
      //     );
      //   },
      // );
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Column(
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('lib/config/assets/Logo.png'),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 55),
                  child: Image(
                    image: AssetImage('lib/config/assets/logo3.png'),
                  ),
                ),
              ],
            ),
            Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _loginButton(
                  signInWithGoogle,
                )
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget _loginButton(VoidCallback onTap) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: const Color(boxColor),
      ),
      onPressed: onTap,
      child: const Padding(
        padding: EdgeInsets.all(5.0),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: Image(
                image: AssetImage('lib/config/assets/google.png'),
              ),
            ),
            Text(
              " 구글 아이디로 로그인",
              style: TextStyle(
                  color: Color(fontYellowColor),
                  fontSize: 36,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
