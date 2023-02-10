import 'package:sqflite/sqflite.dart';
import 'excercise_model.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';

class Database {
  static const dbName = 'fit_database.db';

  late var database;

  Future<void> openDB() async {
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
}