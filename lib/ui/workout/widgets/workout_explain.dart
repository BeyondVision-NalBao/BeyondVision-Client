import 'package:beyond_vision/core/constants.dart';
import 'package:beyond_vision/model/workout_model.dart';
import 'package:beyond_vision/provider/login_provider.dart';
import 'package:beyond_vision/ui/workout/widgets/camera_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class WorkOutExplain extends StatefulWidget {
  final WorkOut workout;

  final bool pop;
  const WorkOutExplain({super.key, required this.workout, required this.pop});

  @override
  State<WorkOutExplain> createState() => _WorkOutExplainState();
}

class _WorkOutExplainState extends State<WorkOutExplain> {
  final FlutterTts tts = FlutterTts();
  late YoutubePlayerController _controller;
  bool isListening = true;
  int isResult = 1;
  String networkUrl = "";
  String description = "";
  @override
  void initState() {
    int endIndex = widget.workout.description.length - 11;
    int lastIndex = widget.workout.description.lastIndexOf("5");
    description = widget.workout.description
        .replaceAll('\\n', '\n')
        .substring(0, lastIndex - 4);
    // 맨 뒤에서부터 11번째 글자까지의 인덱스
    String youtube = widget.workout.description.substring(endIndex);

    String videoId = YoutubePlayer.convertUrlToId(youtube)!;

    // TODO: implement initState

    _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
            mute: false,
            autoPlay: false,
            disableDragSeek: false,
            loop: false,
            isLive: false,
            forceHD: false,
            enableCaption: true))
      ..addListener(_videoPlayerListener);
    tts.setSpeechRate(0.4);
    tts.setPitch(0.9);
    if (isListening == true) {
      tts.speak(widget.workout.description);
    }
    super.initState();
    networkUrl = widget.workout.exerciseImageUrl;
  }

  _videoPlayerListener() {
    if (_controller.value.isPlaying) {
      // 플레이어가 재생 중일 때
      if (isListening == true) {
        tts.stop();
        setState(() {
          isListening = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tts.stop();
    _controller.removeListener(_videoPlayerListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    return Dialog(
      backgroundColor: const Color(boxColor),
      elevation: 5,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.9,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(children: [
                  Text(
                    widget.workout.name,
                    style: const TextStyle(
                        color: Color(fontYellowColor),
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(isListening ? Icons.pause : speakerIcon,
                        color: const Color(fontYellowColor), size: 50),
                    onPressed: () {
                      if (isListening == false) {
                        isListening = true;
                        _controller.pause();
                        tts.speak(widget.workout.description);
                      } else {
                        isListening = false;
                        tts.stop();
                      }
                      setState(() {});
                    },
                  ),
                ]),
                SizedBox(
                  height: 520,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Image.network(networkUrl),
                        YoutubePlayerBuilder(
                            player: YoutubePlayer(controller: _controller),
                            builder: (context, player) {
                              return Container(child: player);
                            }),
                        Text(description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 28)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                widget.pop
                    ? TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("닫기",
                            style:
                                TextStyle(color: Colors.white, fontSize: 24)))
                    : Column(
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CameraView(
                                            workout: widget.workout,
                                            memberId: auth.memberId,
                                            weight: auth.weight,
                                            count: 30)));
                              },
                              child: const Text("확인 후 운동하기",
                                  style: TextStyle(
                                      color: Color(fontYellowColor),
                                      fontSize: 24))),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("닫기",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24))),
                        ],
                      )
              ]),
        ),
      ),
    );
  }
}
