import 'package:sqflite/sqflite.dart';
import 'excercise_model.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';

class FitDatabase {
  static const dbName = 'fit_database.db';

  late final database;

  FitDatabase() {
    _openDB();
  }

  Future<void> _openDB() async {
    database = openDatabase(join(await getDatabasesPath(), dbName),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE excercises(id INTEGER PRIMARY KEY, name TEXT, desc TEXT, video TEXT, image TEXT)');
    }, version: 1);
  }

  Future<void> insertExcercise(Excercise excercise) async {
    final db = await database;
    await db.insert('excercises', excercise.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //Returns a list of excercise stored locally to the db.
  Future<List<Excercise>> getExcercises() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = db.query("excercises");
    return List.generate(maps.length, (i) {
      return Excercise(maps[i]['id'], maps[i]['name'], maps[i]['desc'],
          maps[i]['video'], maps[i]['image']);
    });
  }

  Future<void> updateExcercise(Excercise excercise) async {
    final db = await database;
    await db.update('excercises', excercise.toMap(),
        where: 'id = ?', whereArgs: [excercise.id]);
  }

  Future<void> deleteExcercise(int id) async {
    final db = await database;
    await db.delete('excercises', where: 'id = ?', whereArgs: [id]);
  }
}
