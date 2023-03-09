import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fit_db_project/db_provider.dart';
import 'package:fit_db_project/exercise_model.dart';
import 'package:fit_db_project/exercise_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class ExerciseChart extends StatefulWidget {
  ExerciseChart({super.key, required this.currentExercise});
  final Exercise currentExercise;
  @override
  State<ExerciseChart> createState() => _ExerciseChartState();
}

class _ExerciseChartState extends State<ExerciseChart> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController reps = TextEditingController();
  String? _selected;
  String? _date;

  @override
  void dispose() {
    reps.dispose();
    super.dispose();
  }

  _onSelectionChange(DateRangePickerSelectionChangedArgs args) {
    _selected = DateFormat('MM-dd-yyyy').format(args.value);
    setState(() {});
  }

  _addToGraph() {
    setState(() {
      if (_formKey.currentState!.validate()) {
        context
            .read<ExerciseList>()
            .addProgress(widget.currentExercise, int.parse(reps.text), _date!);
        _date = null;
        _formKey.currentState!.reset();
        reps.text = "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        const Text("Exercise Graph", style: TextStyle(fontSize: 20)),
        //if (widget.progress.isNotEmpty) Container(),
        Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: reps,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter the number of repetitions',
              ),
              validator: ((value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a number";
                }
                return null;
              }),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.deny(RegExp(r'^0+'))
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              child: Container(child: const Text("pick a date")),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Container(
                            height: 350,
                            width: 300,
                            child: Column(
                              children: <Widget>[
                                Container(
                                    height: 250,
                                    child: SfDateRangePicker(
                                      view: DateRangePickerView.month,
                                      onSelectionChanged: _onSelectionChange,
                                      selectionMode:
                                          DateRangePickerSelectionMode.single,
                                    )),
                                MaterialButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    setState(() {
                                      _date = _selected!;
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                                MaterialButton(
                                  child: Text("Cancel"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            )),
                      );
                    });
              },
            ),
            const SizedBox(
              height: 15,
            ),
            if (_date != null)
              Text("Workout date: ${_date}",
                  style: const TextStyle(fontSize: 20)),
          ]),
        ),
        ElevatedButton(
            onPressed: _addToGraph,
            child: const Text(
              "Add workout to graph",
              style: TextStyle(fontSize: 20),
            ))
      ]),
    );
  }
}
