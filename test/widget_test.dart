// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

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

  testWidgets('Home screen displays exercises', (WidgetTester tester) async {
    WidgetsFlutterBinding.ensureInitialized();
    final db = FitDatabase.withName('test_database.db');

    await db.openDB();

    List<Exercise> exercises = await db.getExercises();

    final provider = ExerciseList(exercises);
    await tester.pumpWidget(ChangeNotifierProvider(create: (context) => provider,
    child: myApp()));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
