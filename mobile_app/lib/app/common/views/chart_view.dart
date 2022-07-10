import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/chart_model.dart';

class ChartView extends StatefulWidget {
  ChartView(
      {Key? key,
      required this.title,
      required this.charts,
      required this.chartTimeButton})
      : super(key: key);

  final String title;
  final List<ChartModel> charts;

  final List<ChartTimeButton> chartTimeButton;

  /// <Widget>[
  ///   const Text("7D"),
  ///   const Text("1M"),
  ///   const Text("1Y"),
  /// ];
  late final List<Widget> _timeButtonList =
      chartTimeButton.map((e) => e.title).toList();

  /// <DateTimeRange>[
  ///     DateTimeRange(
  ///         start: DateTime(
  ///             _now.year, _now.month, _now.day - 7),
  ///         end: _now)),
  ///     DateTimeRange(
  ///         start: DateTime(
  ///             _now.year, _now.month - 1, _now.day),
  ///         end: _now)),
  ///     DateTimeRange(
  ///         start: DateTime(
  ///             _now.year - 1, _now.month, _now.day),
  ///         end: _now)),
  /// ];
  late final List<DateTimeRange> _timeNumList =
      chartTimeButton.map((e) => e.dateTimeRange).toList();

  @override
  State<ChartView> createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  int _selected = 0;
  List<bool> _timeTypeList = <bool>[false, false, false];

  final List<Color> colors = [
    Color.fromARGB(255, 231, 111, 255),
    Color(0xFF0087FF),
    Color.fromARGB(255, 32, 248, 255),
  ];

  double? _currentMinX;

  @override
  void initState() {
    _changeTimeScale(_selected);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LineChartData _summaryChartData = LineChartData(
      gridData: FlGridData(show: true, drawVerticalLine: false),
      borderData: FlBorderData(show: false),
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          // customize tooltip
          tooltipPadding: const EdgeInsets.all(8),
          tooltipBgColor: Color(0xff2e3747).withOpacity(0.8),
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((touchedSpot) {
              String formattedDate = DateFormat('yyyy-MM-dd').format(
                  DateTime.fromMillisecondsSinceEpoch(widget
                      .charts.first.data![touchedSpot.x.toInt()].x
                      .toInt()));
              return LineTooltipItem(
                  '${formattedDate}\n${touchedSpot.y.round()}',
                  const TextStyle(color: Colors.white, fontSize: 12.0),
                  textAlign: TextAlign.left);
            }).toList();
          },
        ),
        handleBuiltInTouches: true,
      ),
      clipData: FlClipData.all(),
      titlesData: FlTitlesData(
        show: true,
        topTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: false,
                reservedSize: 20,
                getTitlesWidget: null,
                interval: widget.charts.first.data!.length.toDouble() + 2)),
        bottomTitles: AxisTitles(
            sideTitles: SideTitles(
          reservedSize: 30,
          showTitles: true,
          interval: widget.charts.first.data!.length /
              ((MediaQuery.of(context).size.width < 200)
                  ? 1
                  : (MediaQuery.of(context).size.width ~/ 200)),
          getTitlesWidget: (value, meta) {
            //value from x point
            String formattedDate = DateFormat('MM-dd').format(
                DateTime.fromMillisecondsSinceEpoch(
                    widget.charts.first.data![value.toInt()].x.toInt()));
            return Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(formattedDate,
                    style: Theme.of(context).textTheme.bodySmall));
          },
        )),
        leftTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 50,
          interval: (0 ==
                  widget.charts
                      .map((_chartModel) => _chartModel.data!
                          .sublist(_currentMinX!.toInt())
                          .asMap()
                          .entries
                          .map((e) => e.value.y)
                          .toList()
                          .reduce(max))
                      .toList()
                      .reduce(max))
              ? 1
              : widget.charts
                      .map((_chartModel) => _chartModel.data!
                          .sublist(_currentMinX!.toInt())
                          .asMap()
                          .entries
                          .map((e) => e.value.y)
                          .toList()
                          .reduce(max))
                      .toList()
                      .reduce(max) /
                  2,
        )),
        rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false, reservedSize: 80)),
      ),
      lineBarsData: widget.charts
          .asMap()
          .entries
          .map((chart) => LineChartBarData(
                shadow: Shadow(
                    color: Theme.of(context).colorScheme.primary,
                    blurRadius: 10),
                isCurved: true,
                color: colors[chart.key],
                // gradient: LinearGradient(colors: [colors[chart.key]]),
                barWidth: 1.5,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
                spots: chart.value.data!
                    .asMap()
                    .entries
                    .map(
                      (e) => FlSpot(e.key.toDouble(), e.value.y),
                    )
                    .toList(),
              ))
          .toList(),
      minX: _currentMinX,
      maxX: widget.charts
              .map((e) => e.data!.length)
              .toList()
              .reduce(max)
              .toDouble() -
          1, //length of data set
      minY: widget.charts
              .map((_chartModel) => _chartModel.data!
                  .sublist(_currentMinX!.toInt())
                  .asMap()
                  .entries
                  .map((e) => e.value.y)
                  .toList()
                  .reduce(min))
              .toList()
              .reduce(min)
              .toDouble() *
          0.9,
      maxY: widget.charts
                  .map((_chartModel) => _chartModel.data!
                      .sublist(_currentMinX!.toInt())
                      .asMap()
                      .entries
                      .map((e) => e.value.y)
                      .toList()
                      .reduce(max))
                  .toList()
                  .reduce(max)
                  .toDouble() *
              1.1 +
          1,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.headline5,
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            height: 320,
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(children: [
              FittedBox(
                  child: ToggleButtons(
                splashColor: Color.fromARGB(255, 251, 206, 255),
                children: widget._timeButtonList,
                isSelected: _timeTypeList,
                onPressed: (index) {
                  _changeTimeScale(index);
                },
              )),
              const SizedBox(height: 9),
              if (widget.charts.first.data!.isNotEmpty)
                Expanded(
                    child: LineChart(
                  _summaryChartData,
                  swapAnimationDuration: const Duration(milliseconds: 250),
                ))
            ]))
      ],
    );
  }

  _changeTimeScale(int __selected) {
    setState(() {
      _selected = __selected;
      _timeTypeList = _timeTypeList.map((e) => false).toList();
      _timeTypeList[_selected] = true;

      _currentMinX = _minX(widget._timeNumList[_selected].start);
    });
  }

  double _minX(DateTime _date) {
    double _minDate = _date.millisecondsSinceEpoch.toDouble();
    double _ret = widget.charts.first.data!.length.toDouble();

    for (var i = 0; i < widget.charts.first.data!.length; i++) {
      if (_minDate < widget.charts.first.data![i].x) {
        _ret = i.toDouble();
        break;
      }
    }
    return _ret;
  }

  double _maxX(DateTime _date) {
    double _maxDate = _date.millisecondsSinceEpoch.toDouble();
    double _ret = widget.charts.first.data!.length.toDouble();

    for (var i = 0; i < widget.charts.first.data!.length; i++) {
      if (widget.charts.first.data![i].x <= _maxDate) {
        _ret = i.toDouble();
        break;
      }
    }
    return _ret;
  }
}

class ChartTimeButton {
  final Widget title;
  final DateTimeRange dateTimeRange;

  ChartTimeButton({required this.title, required this.dateTimeRange});
}
