import 'package:fit_db_project/exercise_model.dart';
import 'package:fit_db_project/video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'create_exercise.dart';

class ExerciseView extends StatelessWidget{
  ExerciseView({super.key, required this.currentExercise});
  final Exercise currentExercise;

  static String myVideoId = "IODxDxX7oi4";
  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: myVideoId,
    flags: const YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final hasVideo = currentExercise.video != null;

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
          Text(currentExercise.desc),
          //Text(currentExercise.video ?? ""),
          YoutubePlayer(controller: _controller),
          //if(hasVideo)
            //SizedBox(
            //  height: 500,
            //  width: 500,
            //  child: VideoPlayerScreen(link: currentExercise.video ?? "")
            //)

          ]
      )
    );
  }
}