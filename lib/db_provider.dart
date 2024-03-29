import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'exercise_model.dart';
import 'firebase_data.dart';
import 'sqflite_db.dart';

class DbProvider with ChangeNotifier {
  FitDatabase db;

  DbProvider(this.db);

  final FirestoreTaskDataStore fs = FirestoreTaskDataStore();

  // get exercises from firebase, sync with local db
  Future<void> syncFirebaseWithLocal() async{
    await FirebaseAuth.instance.signInAnonymously();
    List<Exercise> fb_exercises = await fs.getForUser();
    var db_exercises = await db.getExercises();

    for (int i = 0; i < fb_exercises.length; i++){
      if(!db_exercises.contains(fb_exercises[i])){
        await syncExercises(fb_exercises, db_exercises);
      }
    }
    notifyListeners();
  }

  Future<void> syncExercises(List<Exercise> fb_exercises, List<Exercise> db_exercises) async{
    await db.resetTables();
    for (var i = 0; i < fb_exercises.length; i++) {
      var currentExercise = fb_exercises[i];
      await insertExercise(currentExercise);
      for (var j = 0; j < currentExercise.progress.length; j++) {
        int progressInt = currentExercise.progress[j].toInt();
        await insertChartData(currentExercise, progressInt, currentExercise.progressTimes[j]);
      }
    }
    notifyListeners();
  }

  Future<void> insertExercise(Exercise exercise) async {
    await db.insertExercise(exercise);
    FirebaseFirestore.instance.collection('exercises').doc(exercise.id.toString()).set(exercise.toMap());
    notifyListeners();
  }

  Future<void> insertOrUpdateFBChartData(Exercise exercise, int progress, String progressTimes) async {
    final DocumentReference docRef = FirebaseFirestore.instance.collection('exercises').doc(exercise.id.toString());
    FirebaseFirestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot docSnapshot = await tx.get(docRef);
      if (docSnapshot.exists) {
        if (docSnapshot.data().toString().contains("progress")){
          tx.update(docRef, <String, dynamic>{'progress': FieldValue.arrayUnion([progress])});
          tx.update(docRef, <String, dynamic>{'progressTimes': FieldValue.arrayUnion([progressTimes])});
        } else {
          tx.update(docRef, <String, dynamic>{'progress': [progress]});
          tx.update(docRef, <String, dynamic>{'progressTimes': [progressTimes]});
        }
      }
    });
    notifyListeners();
  }

  Future<void> insertChartData(
      Exercise exercise, int progress, String progressTimes) async {
    await db.insertChartData(exercise, progress, progressTimes);
    await insertOrUpdateFBChartData(exercise, progress, progressTimes);
    notifyListeners();
  }

  Future<void> updateChartData(
      Exercise exercise, int progress, String progressTimes) async {
    await db.updateChartData(exercise, progress, progressTimes);
    await insertOrUpdateFBChartData(exercise, progress, progressTimes);
    notifyListeners();
  }

  Future<List<Exercise>> getExercises() async {
    await syncFirebaseWithLocal();
    final exercises = await db.getExercises();
    return exercises;
  }

  Future<void> updateExercise(Exercise exercise) async {
    await db.updateExercise(exercise);
    FirebaseFirestore.instance.runTransaction((Transaction tx) async =>
    tx.update(FirebaseFirestore.instance.collection('exercises').doc(exercise.id.toString()),
      {
        "name": exercise.name,
        "desc": exercise.desc,
        "image": exercise.image,
        "video": exercise.video,
        "id": exercise.id,
        "youtubeLink": exercise.youtubeLink
      }
    ));
    notifyListeners();
  }

  Future<void> deleteExercise(int id) async {
    await db.deleteExercise(id);
    FirebaseFirestore.instance.runTransaction((Transaction tx) async =>
    await tx.delete(FirebaseFirestore.instance.collection('exercises').doc(id.toString())));
    notifyListeners();
  }

  Future<void> deleteDatabase() async {
    await db.deleteDatabase();
    notifyListeners();
  }
}
