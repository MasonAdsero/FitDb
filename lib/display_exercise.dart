import 'package:fit_db_project/exercise_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'create_exercise.dart';

class ExerciseView extends StatelessWidget{
  const ExerciseView({super.key, required this.currentExercise});
  final Exercise currentExercise;


  @override
  Widget build(BuildContext context) {
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
    );
  }
}