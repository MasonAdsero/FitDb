import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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
  final TextEditingController reps = TextEditingController();
  String? date;

  @override
  void dispose() {
    reps.dispose();
    super.dispose();
  }

  _onSelectionChange(DateRangePickerSelectionChangedArgs args) {
    date = args.value;
    setState(() {});
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
                if (value == null) {
                  return "Please enter a number";
                }
                return null;
              }),
              keyboardType: TextInputType.number,
            ),
            SfDateRangePicker(
              view: DateRangePickerView.month,
              onSelectionChanged: _onSelectionChange,
              selectionMode: DateRangePickerSelectionMode.single,
            )
          ]),
        )
      ]),
    );
  }
}
