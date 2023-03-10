import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'display_exercise.dart';
import 'exercise_list_view.dart';
import 'exercise_model.dart';
import 'exercise_provider.dart';
import 'db_provider.dart';
import 'sqflite_db.dart';
import 'dart:async';
import 'create_exercise.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = FitDatabase('fit_database3.db');
  await db.openDB();

  List<Exercise> exercises = await db.getExercises();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => ExerciseList(exercises),
    ),
    ChangeNotifierProvider(create: ((context) => DbProvider(db)))
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'FitDB'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: ExerciseListView(context: context),
      ),
      bottomNavigationBar: BottomAppBar(
          child: Container(
              height: 50,
              child: Row(children: <Widget>[
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ExerciseForm()
                        ));
                  },
                  child: const Icon(Icons.add_circle_outline),
                ),
              ]))),
    );
  }
}
