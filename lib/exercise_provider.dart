import 'package:flutter/material.dart';
import 'exercise_model.dart';

class ExerciseList with ChangeNotifier {
  List<Exercise> _exercises = [];

  int get id =>
      _exercises.isEmpty ? 0 : _exercises[exercises.length - 1].id + 1;

  List<Exercise> get exercises => _exercises.toList();

  ExerciseList(this._exercises);

  void add(Exercise exercise) {
    _exercises.add(exercise);
    notifyListeners();
  }

  void addProgress(Exercise exercise, int progressNum, String progressDate) {
    final int index = _exercises.indexOf(exercise);
    _exercises[index].progress.add(progressNum);
    _exercises[index].progressTimes.add(progressDate);
    notifyListeners();
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
}
