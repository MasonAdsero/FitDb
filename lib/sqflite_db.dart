import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'exercise_model.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';

class FitDatabase {
  late var dbName = 'fit_database.db';

  late final database;

  FitDatabase(this.dbName);

  Future<void> openDB() async {
    database = openDatabase(join(await getDatabasesPath(), dbName),
        onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE exercises(id INTEGER PRIMARY KEY, name TEXT, desc TEXT, video TEXT, image TEXT, youtubeLink TEXT)');
      await db.execute(
          'CREATE TABLE charts(id INTEGER PRIMARY KEY, exercise_id INTEGER NOT NULL, progress INTEGER, progressTimes TEXT, FOREIGN KEY (exercise_id) REFERENCES exercises (id))');
    }, version: 1);
  }

  Future<void> insertExercise(Exercise exercise) async {
    final db = await database;
    await db.insert('exercises', exercise.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertChartData(
      Exercise exercise, int progress, String progressTimes) async {
    final db = await database;
    await db.insert('charts', mapChart(exercise.id, progress, progressTimes));
  }

  Future<void> updateChartData(
      Exercise exercise, int progress, String progressTimes) async {
    final db = await database;
    await db.update('charts', mapChart(exercise.id, progress, progressTimes),
        where: "exercise_id = ? and progressTimes = ?",
        whereArgs: [exercise.id, progressTimes]);
  }

  //Returns a list of excercise stored locally to the db.
  Future<List<Exercise>> getExercises() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("exercises");

    List<Exercise> exercises = [];
    for (int i = 0; i < maps.length; i++) {
      List<Map<String, dynamic>> chartMaps = await db
          .query("charts", where: 'exercise_id=?', whereArgs: [maps[i]['id']]);
      Exercise exercise = Exercise(
          maps[i]['id'],
          maps[i]['name'],
          maps[i]['desc'],
          maps[i]['video'],
          maps[i]['image'],
          maps[i]['youtubeLink']);
      for (int j = 0; j < chartMaps.length; j++) {
        exercise.progress.add(chartMaps[j]['progress']);
        exercise.progressTimes.add(chartMaps[j]['progressTimes']);
      }
      exercises.add(exercise);
    }
    return exercises;
  }

  Future<void> updateExercise(Exercise exercise) async {
    final db = await database;
    await db.update('exercises', exercise.toMap(),
        where: 'id = ?', whereArgs: [exercise.id]);
  }

  Future<void> deleteExercise(int id) async {
    final db = await database;
    await db.delete('exercises', where: 'id = ?', whereArgs: [id]);
  }

  Map<String, dynamic> mapChart(
      int exercise, int progress, String progressTimes) {
    return {
      'exercise_id': exercise,
      'progress': progress,
      'progressTimes': progressTimes
    };
  }

  Future<void> deleteDatabase() async =>
      databaseFactory.deleteDatabase(join(await getDatabasesPath(), dbName));
}
