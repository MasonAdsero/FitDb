import 'package:flutter/material.dart';
import 'exercise_model.dart';
import 'sqflite_db.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

class DbProvider with ChangeNotifier {
  final FitDatabase db;

  DbProvider(this.db);

  Future<void> insertExercise(Exercise exercise) async {
    await db.insertExercise(exercise);
    notifyListeners();
  }

  Future<void> insertChartData(
      Exercise exercise, int progress, String progressTimes) async {
    await db.insertChartData(exercise, progress, progressTimes);
    notifyListeners();
  }

  Future<void> updateChartData(
      Exercise exercise, int progress, String progressTimes) async {
    await db.updateChartData(exercise, progress, progressTimes);
    notifyListeners();
  }

  Future<List<Exercise>> getExercises() async {
    final exercises = await db.getExercises();
    return exercises;
  }

  Future<void> updateExercise(Exercise exercise) async {
    await db.updateExercise(exercise);
    notifyListeners();
  }

  Future<void> deleteExercise(int id) async {
    await db.deleteExercise(id);
    notifyListeners();
  }

  Future<void> deleteDatabase() async {
    await db.deleteDatabase();
    notifyListeners();
  }


}
