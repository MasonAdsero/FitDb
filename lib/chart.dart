import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class ExerciseChart extends StatefulWidget {
  ExerciseChart(
      {super.key, required this.progress, required this.progressTimes});
  List<int> progress;
  List<String> progressTimes;
  @override
  State<ExerciseChart> createState() => _ExerciseChartState();
}

class _ExerciseChartState extends State<ExerciseChart> {
  final _formKey = GlobalKey<FormState>();

  _selectDate() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        const Text("Exercise Graph", style: TextStyle(fontSize: 20)),
        if (widget.progress.isNotEmpty) Container(),
        Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter the number of repetitions',
              ),
              validator: ((value) {
                if (value == null) {
                  return "Please enter a number";
                }
                return null;
              }),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton.icon(
                onPressed: _selectDate,
                icon: const Icon(Icons.calendar_today),
                label: const Text("Pick a date"))
          ]),
        )
      ]),
    );
  }
}
