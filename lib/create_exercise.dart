import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'exercise_model.dart';
import 'exercise_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'db_provider.dart';
import 'sqflite_db.dart';
import 'dart:async';
import 'package:dio/dio.dart';

class ExerciseForm extends StatefulWidget {
  ExerciseForm({super.key});

  @override
  State<ExerciseForm> createState() => _ExerciseForm();
}

class _ExerciseForm extends State<ExerciseForm> {
  final _formKey = GlobalKey<FormState>();
  final titleField = TextEditingController();
  final descField = TextEditingController();
  final videoField = TextEditingController();
  final imageField = TextEditingController();

  @override
  void dispose() {
    titleField.dispose();
    descField.dispose();
    videoField.dispose();
    imageField.dispose();
    super.dispose();
  }

  void _submit() async {
    String? vidPath;
    String? imgPath;
    if (_formKey.currentState!.validate()) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      if (videoField.text.isNotEmpty) {
        vidPath = '$appDocPath/${titleField.text}/vid.mp4';
        await Dio().download(videoField.text, vidPath);
      }
      if (imageField.text.isNotEmpty) {
        imgPath = '$appDocPath/${titleField.text}/img.mp4';
        await Dio().download(imageField.text, imgPath);
      }
      // ignore: use_build_context_synchronously
      Exercise exercise = Exercise(context.read<ExerciseList>().id,
          titleField.text, descField.text, vidPath, imgPath);
      // ignore: use_build_context_synchronously
      context.read<ExerciseList>().add(exercise);
      // ignore: use_build_context_synchronously
      context.read<DbProvider>().db.insertExercise(exercise);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Create an exercise"),
        ),
        body: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                  labelText: "Exercise Title",
                  hintText: "Enter the title of the exercise"),
              controller: titleField,
              validator: (String? value) {
                if (value == null) return 'Please enter a title';
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: "Exercise Description",
                  hintText: "Enter a description for the exercise"),
              controller: descField,
              validator: (String? value) {
                if (value == null) return 'Please enter a description';
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: "Exercise video (Optional)",
                  hintText: "Enter a link for a video"),
              controller: videoField,
              validator: (String? value) {
                if (value != null && value.isNotEmpty) {
                  Uri url = Uri.parse(value);
                  if (!url.isAbsolute) {
                    return 'Enter a valid link';
                  }
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: "Exercise Image (Optional)",
                  hintText: "Enter a link for a image"),
              controller: imageField,
              validator: (String? value) {
                if (value != null && value.isNotEmpty) {
                  Uri url = Uri.parse(value);
                  if (!url.isAbsolute) {
                    return 'Enter a valid link';
                  }
                }
                return null;
              },
            ),
            ElevatedButton(
                onPressed: _submit,
                child: const Text("Finish exercise creation"))
          ]),
        ));
  }
}
