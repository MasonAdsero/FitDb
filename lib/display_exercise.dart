import 'package:fit_db_project/chart.dart';
import 'package:fit_db_project/exercise_model.dart';
import 'package:fit_db_project/video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:io';
import 'create_exercise.dart';

class ExerciseView extends StatelessWidget {
  ExerciseView({super.key, required this.currentExercise});
  final Exercise currentExercise;



  @override
  Widget build(BuildContext context) {
    String youtubeLink = "";
    if(currentExercise.youtubeLink != null) {
      youtubeLink = YoutubePlayer.convertUrlToId(currentExercise.youtubeLink ?? "") ?? "";
    }

    final YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: youtubeLink,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );


    final hasUserImage =
        currentExercise.image != null && currentExercise.image != "";
    final hasUserVideo =
        currentExercise.video != null && currentExercise.video != "";
    final hasYouTubeVideo = currentExercise.youtubeLink != null &&
        currentExercise.youtubeLink != "";

    BoxDecoration textDisplay() {
      return BoxDecoration(
          color: Colors.grey.shade400,
          borderRadius: const BorderRadius.all(Radius.circular(5)));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(currentExercise.name),
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Column(children: [
          Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: textDisplay(),
              child: Column(children: <Widget>[
                const Text("Details:", style: TextStyle(fontSize: 20)),
                Text(currentExercise.desc, style: const TextStyle(fontSize: 20))
              ])),
          Column(children: [
            if (hasYouTubeVideo) YoutubePlayer(controller: _controller),
            if (hasUserImage)
               Image.file(File(currentExercise.image!), width: 300, height: 300),
            const SizedBox(
              height: 10,
            ),
            if (hasUserVideo)
              SizedBox(
                  height: 620,
                  width: 300,
                  child: VideoPlayerScreen(link: currentExercise.video ?? "")),
            SizedBox(
              height: 600,
              width: 300,
              child: ExerciseChart(
                currentExercise: currentExercise,
              ),
            )
          ])
        ]))));
  }
}
