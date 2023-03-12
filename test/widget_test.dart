import 'package:fit_db_project/chart.dart';
import 'package:fit_db_project/edit_exercise.dart';
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
import 'package:fit_db_project/chart.dart';
import 'package:fit_db_project/drawChart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'widget_test.mocks.dart';

extension WithScaffold on WidgetTester {
  pumpWithScaffold(Widget widget) async =>
      pumpWidget(MaterialApp(home: Scaffold(body: widget)));

  pumpWithProvider(Widget widget) async => pumpWidget(MaterialApp(
          home: Scaffold(
              body: MultiProvider(providers: [
        ChangeNotifierProvider(
          create: (context) => ExerciseList([]),
        ),
        ChangeNotifierProvider<DbProvider>(
            create: ((context) => MockDbProvider()))
      ], child: widget))));

  pumpWithProviderExercise(Widget widget, var prov) async =>
      pumpWidget(MaterialApp(
          home: Scaffold(
              body: MultiProvider(providers: [
        ChangeNotifierProvider<ExerciseList>(
          create: (context) => prov,
        ),
        ChangeNotifierProvider<DbProvider>(
            create: ((context) => MockDbProvider()))
      ], child: widget))));
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

  testWidgets('MyApp displays is displaying MyHomePage',
      (WidgetTester tester) async {
    await tester.pumpWithProvider(MyApp());
    final homePage = find.byType(MyHomePage);
    expect(homePage, findsOneWidget);
  });

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
    final dbmock = MockDbProvider();
    await tester.pumpWithScaffold(MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => ExerciseList([]),
      ),
      ChangeNotifierProvider<DbProvider>(
          create: ((context) => MockDbProvider()))
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

  testWidgets("Exercise Chart show no chart widget with no data",
      (WidgetTester tester) async {
    Exercise exercise = Exercise(0, "Push-Ups", "Strict form push Ups");
    await tester.pumpWithProvider(ExerciseChart(currentExercise: exercise));

    final chart = find.byType(DrawChart);
    expect(chart, findsNothing);

    final addReps = find.byKey(const Key("RepTextEditor"));
    expect(addReps, findsOneWidget);

    final pickDate = find.byKey(const Key("AddDate"));
    expect(addReps, findsOneWidget);

    final addWorkOut = find.byKey(const Key("AddWorkOutGraph"));
    expect(addWorkOut, findsOneWidget);
  });

  testWidgets("Exercise Chart appears after data added",
      (WidgetTester tester) async {
    Exercise exercise = Exercise(0, "Push-Ups", "Strict form push Ups");
    exercise.progress = [1];
    exercise.progressTimes = ["2023-03-14"];
    await tester.pumpWithProvider(ExerciseChart(currentExercise: exercise));

    final addReps = find.byKey(const Key("RepTextEditor"));
    await tester.enterText(addReps, "10");

    expect(find.byType(DrawChart), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const Key("AddWorkOutGraph")),
      50,
    );
    await tester.tap(find.byKey(const Key("AddWorkOutGraph")));
  });

  testWidgets("Daterangepicker shows up when add a date clicked",
      (WidgetTester tester) async {
    Exercise exercise = Exercise(0, "Push-Ups", "Strict form push Ups");
    exercise.progress = [1];
    exercise.progressTimes = ["2023-03-14"];
    await tester.pumpWithProvider(ExerciseChart(currentExercise: exercise));
    final picker = find.byKey(const Key("AddDate"));
    await tester.tap(picker);
    await tester.pump();
    expect(find.byType(SfDateRangePicker), findsOneWidget);
    //Confirm we do not add a date with nothing picked
    await tester.tap(find.text("OK"));
    await tester.pump();
    expect(find.byType(SfDateRangePicker), findsOneWidget);
    //Confirm daterange picker gone when cancel is tapped
    await tester.tap(find.text("Cancel"));
    await tester.pump();
    expect(find.byType(SfDateRangePicker), findsNothing);
  });

  testWidgets("EditExerciseForm shows all buttons and fields",
      (WidgetTester tester) async {
    Exercise exercise = Exercise(0, "Push-Ups", "Strict form push Ups");
    exercise.progress = [1];
    exercise.progressTimes = ["2023-03-14"];
    await tester.pumpWithProvider(EditExerciseForm(exercise));
    final title = find.byKey(const Key("Title"));
    final desc = find.byKey(const Key("Desc"));
    final you = find.byKey(const Key("YouTube"));
    final takePhoto = find.text("Take Photo");
    final takeVideo = find.text("Take Video");
    final removePhoto = find.text("Remove Photo");
    final removeVideo = find.text("Remove Video");
    expect(title, findsOneWidget);
    expect(desc, findsOneWidget);
    expect(you, findsOneWidget);
    expect(takePhoto, findsOneWidget);
    expect(takeVideo, findsOneWidget);
    expect(removePhoto, findsOneWidget);
    expect(removeVideo, findsOneWidget);
  });

  testWidgets("EditExerciseForm confirm navigation on take photo press",
      (WidgetTester tester) async {
    Exercise exercise = Exercise(0, "Push-Ups", "Strict form push Ups");
    exercise.progress = [1];
    exercise.progressTimes = ["2023-03-14"];
    await tester.pumpWithProvider(EditExerciseForm(exercise));
    final takePhoto = find.text("Take Photo");
    await tester.tap(takePhoto);
    await tester.pumpAndSettle();
  });

  testWidgets("EditExerciseForm confirm navigation on take video press",
      (WidgetTester tester) async {
    Exercise exercise = Exercise(0, "Push-Ups", "Strict form push ups");
    exercise.image = "random";
    exercise.video = "random";
    final prov = ExerciseList([exercise]);
    await tester.pumpWithProviderExercise(EditExerciseForm(exercise), prov);
    await tester.dragUntilVisible(find.byKey(const Key("finishEditing")),
        find.byType(SingleChildScrollView), const Offset(0, 50));
    await tester.tap(find.byKey(const Key("finishEditing")));
    await tester.pumpAndSettle();
    expect(find.byType(EditExerciseForm), findsNothing);
  });
}
