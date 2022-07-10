import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class SummaryChartView extends StatelessWidget {
  const SummaryChartView({Key? key, required this.chart}) : super(key: key);

  final List<FlSpot> chart;
  @override
  Widget build(BuildContext context) {
    List<Color> _gradientAccentColor =
        context.select((ThemeProvider _model) => _model.gradientAccentColor);
    List<FlSpot> _spots =
        (chart.length < 10) ? (chart) : chart.sublist(chart.length - 10);
    return Expanded(
      child: LineChart(LineChartData(
        minX: _spots.first.x + 10,
        maxX: _spots.last.x - 100,
        minY: -100,
        lineTouchData: LineTouchData(
          enabled: false,
        ),
        gridData: FlGridData(
          show: false,
        ),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: _spots,
            isCurved: false,
            gradient: LinearGradient(colors: _gradientAccentColor),
            belowBarData: BarAreaData(
              show: true,
              applyCutOffY: false,
              gradient: LinearGradient(
                colors: _gradientAccentColor
                    .map((color) => color.withOpacity(0.3))
                    .toList(),
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: false,
            ),
          ),
        ],
      )),
    );
  }
}
