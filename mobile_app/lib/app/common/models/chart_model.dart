import 'package:fl_chart/fl_chart.dart';

class ChartModel {
  final String title;
  final String xaxisTitle;
  final String yaxisTitle;
  List<FlSpot>? data;

  ChartModel(
      {required this.title,
      required this.xaxisTitle,
      required this.yaxisTitle,
      this.data});

  @override
  String toString() {
    return "{$title, $xaxisTitle, $yaxisTitle}";
  }
}
