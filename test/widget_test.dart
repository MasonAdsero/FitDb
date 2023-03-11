import 'package:flutter/material.dart';
import 'package:fit_db_project/main.dart';
import 'package:provider/provider.dart';
import 'package:fit_db_project/exercise_model.dart';
import 'package:fit_db_project/exercise_provider.dart';
import 'package:fit_db_project/db_provider.dart';
import 'package:fit_db_project/sqflite_db.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'widget_test.mocks.dart';

extension WithScaffold on WidgetTester {
  pumpWithScaffold(Widget widget) async =>
      pumpWidget(MaterialApp(home: Scaffold(body: widget)));
}

@GenerateMocks([FitDatabase])
void main() {
  setUp(() async {
    WidgetsFlutterBinding.ensureInitialized();
  });

  /*test("Database insert works as intended", () async {
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
  });*/

  testWidgets('Home screen displays exercises', (WidgetTester tester) async {
    var exerciseOne = Exercise(1, "sit-ups", "10 sit-ups in one minute");
    var exerciseTwo = Exercise(2, "push-ups", "10 push-ups in one minute");

    List<Exercise> exercises = [];
    exercises.add(exerciseOne);
    exercises.add(exerciseTwo);

    final exerciseProvider = ExerciseList(exercises);

    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ChangeNotifierProvider(
                create: (context) => exerciseProvider,
                child: MyHomePage(title: 'FitDB')))));
    expect(find.byType(ListTile), findsNWidgets(2));
    expect(find.byType(BottomAppBar), findsOneWidget);
  });

  testWidgets('Exercise form displays all fields', (widgetTester) async {
    final exerciseProvider = ExerciseList([]);
    final db = MockFitDatabase();
  });
}
