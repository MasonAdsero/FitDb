import 'package:fit_db_project/firebase_data.dart';
import 'package:flutter/material.dart';
import 'package:fit_db_project/create_exercise.dart';
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

@GenerateMocks([FitDatabase, FirestoreTaskDataStore, DbProvider])
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

  testWidgets('Exercise form displays all fields and buttons',
      (WidgetTester tester) async {
    final db = MockFitDatabase();
    final fs = MockFirestoreTaskDataStore();
    await tester.pumpWithScaffold(MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => ExerciseList([]),
      ),
      ChangeNotifierProvider(create: ((context) => DbProvider(db, fs)))
    ], child: ExerciseForm()));
    final title = find.byKey(const Key("TitleTextEditor"));
    final desc = find.byKey(const Key("DescTextEditor"));
    final youVideo = find.byKey(const Key("VideoTextEditor"));
    final photo = find.text("Take Photo");
    final video = find.text("Take Video");
    expect(title, findsOneWidget);
    expect(desc, findsOneWidget);
    expect(youVideo, findsOneWidget);
    expect(photo, findsOneWidget);
    expect(video, findsOneWidget);
  });

  testWidgets('Exercise form does not create empty exercise',
      (WidgetTester tester) async {
    final dbprov = MockDbProvider();
    final exerciseList = ExerciseList([]);
    await tester.pumpWithScaffold(MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => exerciseList,
      ),
      ChangeNotifierProvider(create: ((context) => dbprov))
    ], child: ExerciseForm()));

    final submit = find.byKey(const Key("ExerciseSubmitButton"));
    await tester.tap(submit);
    await tester.pump();
    expect(find.byType(ExerciseForm), findsOneWidget);
    expect(exerciseList.exercises.length, 0);
  });

  testWidgets('Exercise form creates exercise', (WidgetTester tester) async {
    final mockdb = MockDbProvider();
    when(mockdb.insertExercise(Exercise(1, "random", "random")))
        .thenAnswer((realInvocation) async {});
    final exerciseList = ExerciseList([]);
    await tester.pumpWithScaffold(MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => exerciseList,
      ),
      ChangeNotifierProvider<DbProvider>(create: ((context) => mockdb))
    ], child: ExerciseForm()));
    final title = find.byKey(const Key("TitleTextEditor"));
    await tester.enterText(title, "random");
    final desc = find.byKey(const Key("DescTextEditor"));
    await tester.enterText(desc, "random");
    final submit = find.byKey(const Key("ExerciseSubmitButton"));
    await tester.tap(submit);
    await tester.pumpAndSettle();
    expect(find.byType(ExerciseForm), findsNothing);
    expect(exerciseList.exercises.length, 1);
  });
}
