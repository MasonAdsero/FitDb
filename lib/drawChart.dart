import 'package:fit_db_project/ChartData.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DrawChart extends StatefulWidget {
  DrawChart({super.key, required this.progress, required this.progressTimes});

  List<int> progress;
  List<String> progressTimes;

  @override
  State<DrawChart> createState() => _DrawChartState();
}

class _DrawChartState extends State<DrawChart> {
  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = List<ChartData>.generate(
        widget.progress.length,
        (index) => ChartData(DateTime.parse(widget.progressTimes[index]),
            widget.progress[index]));
    return Container(
      child: SfCartesianChart(
        isTransposed: true,
        primaryXAxis: DateTimeAxis(
            borderColor: Colors.black, intervalType: DateTimeIntervalType.days),
        series: <ChartSeries<ChartData, DateTime>>[
          BarSeries<ChartData, DateTime>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y)
        ],
      ),
    );
  }
}
