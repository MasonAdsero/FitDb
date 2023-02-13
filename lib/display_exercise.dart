import 'package:fit_db_project/exercise_model.dart';
import 'package:fit_db_project/video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'create_exercise.dart';

class ExerciseView extends StatelessWidget{
  ExerciseView({super.key, required this.currentExercise});
  final Exercise currentExercise;

  static String myVideoId = "";

  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: myVideoId,
    flags: const YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
    ),
  );

  @override
  Widget build(BuildContext context) {
    //final hasUserVideo = currentExercise.video != null;
    final hasUserVideo = false;
    final hasYouTubeVideo = false;

    BoxDecoration textDisplay(){
      return BoxDecoration(
          color: Colors.grey.shade400,
        borderRadius: const BorderRadius.all(
          Radius.circular(5)
        )
      );
    }

    navigateBack(){
      Navigator.pop(context, currentExercise);
    }

    navigateToEdit(){
      Navigator.push(context,
          MaterialPageRoute(
          builder: (context) => ExerciseForm()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(currentExercise.name),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: textDisplay(),
            child: Column(
                children: <Widget>[
                  const Text(
                      "Details:",
                    style: TextStyle(fontSize: 20)),
                  Text(
                      currentExercise.desc,
                      style: const TextStyle(fontSize: 20)
                  )
            ])
          ),

          //Text(currentExercise.video ?? ""),
          if(hasYouTubeVideo)
            YoutubePlayer(controller: _controller),
          if(hasUserVideo)
            SizedBox(
              height: 500,
              width: 500,
              child: VideoPlayerScreen(link: currentExercise.video ?? "")
            )
          ]
      )
    );
  }
}