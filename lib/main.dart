import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'exercise_model.dart';
import 'exercise_provider.dart';
import 'db_provider.dart';
import 'sqflite_db.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //final db = FitDatabase.withName('fit_database.db');
  final db = FitDatabase('fit_database.db');
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
    var exerciseList = context.read<ExerciseList>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: exerciseList.exercises.length,
              itemBuilder: (BuildContext context, int index){
                return Card(
                color: Colors.grey,
                child: ListTile(
                  title: Text(exerciseList.exercises[index].name),
                onTap: (){
                  print("Go to exercise");
                })
              );
      }
        ),
      ])
    )
    );
    }
}
