import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'exercise_model.dart';
import 'exercise_provider.dart';
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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Exercise exercise = Exercise(
          context.read<ExerciseList>().id, titleField.text, descField.text);
      context.read<ExerciseList>().add(exercise);
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
                  hintText: "Enter A link for a video"),
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
                  hintText: "Enter A link for a image"),
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
