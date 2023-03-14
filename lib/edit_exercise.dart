import 'package:fit_db_project/video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'db_provider.dart';
import 'exercise_model.dart';
import 'exercise_provider.dart';

class EditExerciseForm extends StatefulWidget {
  final Exercise exercise;

  late final exerciseCopy = exercise;
  EditExerciseForm(this.exercise, {super.key});

  @override
  State<EditExerciseForm> createState() => _EditExerciseForm();
}

class _EditExerciseForm extends State<EditExerciseForm> {
  final _formKey = GlobalKey<FormState>();
  final titleField = TextEditingController();
  final descField = TextEditingController();
  final youtubeLinkField = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String? imageLink;
  String? videoLink;

  @override
  void initState() {
    super.initState();
    setFields();
  }

  @override
  void dispose() {
    titleField.dispose();
    descField.dispose();
    youtubeLinkField.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      Exercise exercise = Exercise(widget.exerciseCopy.id, titleField.text,
          descField.text, videoLink, imageLink, youtubeLinkField.text);
      exercise.progress = widget.exerciseCopy.progress;
      exercise.progressTimes = widget.exerciseCopy.progressTimes;

      context
          .read<ExerciseList>()
          .modifyWithExercise(widget.exerciseCopy, exercise);
      context.read<DbProvider>().updateExercise(exercise);
      Navigator.pop(context);
    }
  }

  _captureMedia(bool isImage) async {
    if(isImage)
      _removeMedia(true);
    else
      _removeMedia(false);
    XFile? media;
    if(isImage) {
      media = await _picker.pickImage(source: ImageSource.camera);
    }
    else{
      media = await _picker.pickVideo(source: ImageSource.camera);
    }
    if (media != null) {
      final mediaSaveDirectory = await getApplicationDocumentsDirectory();
      final mediaSavePath = mediaSaveDirectory.path;
      final mediaName = media.name;
      final mediaWithPath = '$mediaSavePath/$mediaName';
      await media.saveTo(mediaWithPath);
      setState(() {
        if(isImage)
          imageLink = mediaWithPath;
        else
          videoLink = mediaWithPath;
      });
    }
  }

  void _removeMedia(bool isImage) {
    setState(() {
      if(isImage)
        imageLink = null;
      else
        videoLink = null;
    });
  }

  void setFields() {
    setState(() {
      titleField.text = widget.exercise.name;
      descField.text = widget.exercise.desc;
      youtubeLinkField.text = widget.exercise.youtubeLink ?? '';
      imageLink = widget.exercise.image;
      videoLink = widget.exercise.video;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit your exercise"),
        ),
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            TextFormField(
              key: const Key("Title"),
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
              key: const Key("Desc"),
              decoration: const InputDecoration(
                  labelText: "Exercise Description",
                  hintText: "Enter a description for the exercise"),
              controller: descField,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            TextFormField(
              key: const Key("YouTube"),
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
            if (imageLink != null && imageLink != "")
              Image.file(File(imageLink!), width: 300, height: 300),
            const SizedBox(height: 10),
            if (videoLink != null && videoLink != "")
              SizedBox(
                  height: 620,
                  width: 300,
                  child: VideoPlayerScreen(link: videoLink ?? "")),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () => _captureMedia(true), child: const Text("Take Photo")),
                  const SizedBox(width: 5),
                  ElevatedButton(
                      onPressed: () => _captureMedia(false), child: const Text("Take Video")),
                ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () => _removeMedia(true),
                      child: const Text("Remove Photo")),
                  const SizedBox(width: 5),
                  ElevatedButton(
                      onPressed: () => _removeMedia(false),
                      child: const Text("Remove Video")),
                ]),
            ElevatedButton(
                key: const Key("finishEditing"),
                onPressed: _submit,
                child: const Text("Finish Editing"))
          ]),
        )));
  }
}
