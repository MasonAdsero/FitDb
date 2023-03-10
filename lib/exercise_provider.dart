import 'package:flutter/material.dart';
import 'exercise_model.dart';

class ExerciseList with ChangeNotifier {
  List<Exercise> _exercises = [];
  bool createMode = true;

  int get id =>
      _exercises.isEmpty ? 0 : _exercises[exercises.length - 1].id + 1;

  List<Exercise> get exercises => _exercises.toList();

  ExerciseList(this._exercises);

  void add(Exercise exercise) {
    _exercises.add(exercise);
    notifyListeners();
  }

  bool addProgress(Exercise exercise, int progressNum, String progressDate) {
    bool update = false;
    final int index = _exercises.indexOf(exercise);
    if (_exercises[index].progressTimes.contains(progressDate)) {
      int progIndex = _exercises[index].progressTimes.indexOf(progressDate);
      _exercises[index].progress[progIndex] = progressNum;
      update = true;
    } else {
      _exercises[index].progressTimes.add(progressDate);
      _exercises[index].progress.add(progressNum);
    }
    notifyListeners();
    return update;
  }

  void remove(Exercise exercise) {
    _exercises.remove(exercise);
    notifyListeners();
  }

  //For now just pass all attributes modifiable via editing page.
  //If something isnt edited pass original value. May want to decompose
  //along the line.
  void modify(
      Exercise exercise, String name, String desc, String video, String image) {
    final int index = _exercises.indexOf(exercise);
    _exercises[index].name = name;
    _exercises[index].desc = desc;
    _exercises[index].video = video;
    _exercises[index].image = image;
    notifyListeners();
  }

  void modifyWithExercise(Exercise oldExercise, Exercise newExercise){
      final int index = _exercises.indexOf(oldExercise);
      _exercises[index] = newExercise;
      notifyListeners();
  }
}
