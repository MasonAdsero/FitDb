import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fit_db_project/main.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../lib/exercise_model.dart';
import '../lib/exercise_provider.dart';
import '../lib/db_provider.dart';
import '../lib/sqflite_db.dart';

void main() {
  setUp(() async {
    WidgetsFlutterBinding.ensureInitialized();
  });

  test("Database insert works as intended", () async {
    final db = FitDatabase('test_insert.db');
    await db.openDB();

    var exerciseOne = Exercise(1, "sit-ups", "10 sit-ups in one minute");
    var exerciseTwo = Exercise(2, "push-ups", "10 push-ups in one minute");

    var exerciseList = await db.getExercises();
    expect(exerciseList.length, 0);

    db.insertExercise(exerciseOne);
    exerciseList = await db.getExercises();
    expect(exerciseList.length, 1);

    db.insertExercise(exerciseTwo);
    exerciseList = await db.getExercises();
    expect(exerciseList.length, 2);

    db.deleteDatabase();
  });

  tearDown(() async {

  });
}
