// ignore_for_file: use_build_context_synchronously

import 'package:fit_db_project/video_player.dart';
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
import 'package:image_picker/image_picker.dart';

class ExerciseForm extends StatefulWidget {
  ExerciseForm({super.key});

  @override
  State<ExerciseForm> createState() => _ExerciseForm();
}

class _ExerciseForm extends State<ExerciseForm> {
  final _formKey = GlobalKey<FormState>();
  final titleField = TextEditingController();
  final descField = TextEditingController();
  final youtubeLinkField = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String? imageLink;
  String? videoLink;

  @override
  void dispose() {
    titleField.dispose();
    descField.dispose();
    youtubeLinkField.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      Exercise exercise = Exercise(
          context.read<ExerciseList>().id,
          titleField.text,
          descField.text,
          videoLink,
          imageLink,
          youtubeLinkField.text);
      context.read<ExerciseList>().add(exercise);
      context.read<DbProvider>().db.insertExercise(exercise);
      Navigator.pop(context);
    }
  }

  _takeImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final imageSaveDirectory = await getApplicationDocumentsDirectory();
      final imageSavePath = imageSaveDirectory.path;
      final imageName = image.name;
      final imageWithPath = '$imageSavePath/$imageName';
      await image.saveTo(imageWithPath);
      setState(() {
        imageLink = imageWithPath;
      });
    }
  }

  _takeVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      final videoSaveDirectory = await getApplicationDocumentsDirectory();
      final videoSavePath = videoSaveDirectory.path;
      final videoName = video.name;
      final videoWithPath = '$videoSavePath/$videoName';
      await video.saveTo(videoWithPath);
      setState(() {
        videoLink = videoWithPath;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Create an exercise"),
        ),
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                  labelText: "Exercise Title",
                  hintText: "Enter the title of the exercise"),
              controller: titleField,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: "Exercise Description",
                  hintText: "Enter a description for the exercise"),
              controller: descField,
              validator: (String? value) {
                if (value == null || value.isEmpty)
                  return 'Please enter a description';
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: "Exercise Youtube Video Link (Optional)",
                  hintText: "Enter a link for a youtubeVideo"),
              controller: youtubeLinkField,
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
            const SizedBox(height: 10),
            if (imageLink != null)
              Image.file(File(imageLink!), width: 300, height: 300),
            const SizedBox(height: 10),
            if (videoLink != null)
              SizedBox(
                  height: 620,
                  width: 300,
                  child: VideoPlayerScreen(link: videoLink ?? "")),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: _takeImage, child: const Text("Take Photo")),
                  const SizedBox(width: 5),
                  ElevatedButton(
                      onPressed: _takeVideo, child: const Text("Take Video")),
                ]),
            ElevatedButton(
                onPressed: _submit,
                child: const Text("Finish exercise creation"))
          ]),
        )));
  }
}
