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
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE exercises(id INTEGER PRIMARY KEY, name TEXT, desc TEXT, video TEXT, image TEXT)');
    }, version: 1);
  }

  Future<void> insertExercise(Exercise exercise) async {
    final db = await database;
    await db.insert('exercises', exercise.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //Returns a list of excercise stored locally to the db.
  Future<List<Exercise>> getExercises() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("exercises");
    return List.generate(maps.length, (i) {
      return Exercise(maps[i]['id'], maps[i]['name'], maps[i]['desc'],
          maps[i]['video'], maps[i]['image']);
    });
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

  Future<void> deleteDatabase() async =>
      databaseFactory.deleteDatabase(join(await getDatabasesPath(), dbName));
}
