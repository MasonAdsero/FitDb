import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'db_provider.dart';
import 'display_exercise.dart';
import 'edit_exercise.dart';
import 'exercise_model.dart';
import 'exercise_provider.dart';

class ExerciseListView extends StatefulWidget {
  late final BuildContext context;

  ExerciseListView({super.key, required this.context});

  @override
  State<ExerciseListView> createState() => _ExerciseListViewState();
}

class _ExerciseListViewState extends State<ExerciseListView> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    ExerciseList exerciseList = context.watch<ExerciseList>();

    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              value: _isEditing,
              onChanged: (value) {
                setState(() {
                  _isEditing = value!;
                });
              },
            ),
            const Text('Edit mode'),
          ],
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: exerciseList.exercises.length,
            itemBuilder: (BuildContext context, int index) {
              final exercise = exerciseList.exercises[index];
              return Card(
                color: Colors.grey.shade500,
                child: ListTile(
                  title: Text(exercise.name),
                  trailing: _isEditing
                      ? IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                        exerciseList.remove(exercise);
                        context.read<DbProvider>().db.deleteExercise(exercise.id);
                    },
                  ) : null,
                  onTap: () {
                    if (!_isEditing) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ExerciseView(currentExercise: exercise),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditExerciseForm(exercise, context),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
