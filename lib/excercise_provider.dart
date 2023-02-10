import 'package:flutter/material.dart';
import 'excercise_model.dart';

class ExcerciseList with ChangeNotifier {
  final List<Excercise> _excercises = [];

  List<Excercise> get excercises => _excercises.toList();

  void add(Excercise excercise) {
    _excercises.add(excercise);
    notifyListeners();
  }

  void remove(Excercise excercise) {
    _excercises.remove(excercise);
    notifyListeners();
  }

  //For now just pass all attributes modifiable via editing page.
  //If something isnt edited pass original value. May want to decompose
  //along the line.
  void modify(Excercise excercise, String name, String desc, String video,
      String image) {
    final int index = _excercises.indexOf(excercise);
    _excercises[index].name = name;
    _excercises[index].desc = desc;
    _excercises[index].video = video;
    _excercises[index].image = image;
    notifyListeners();
  }
}
