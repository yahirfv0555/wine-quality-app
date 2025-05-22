
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class BarChart extends StatelessWidget {
  late List<charts.Series> seriesList;
  late bool animate;

  BarChart({required this.seriesList, required this.animate});

  factory BarChart.withSampleData() {
    return BarChart(
      seriesList: _createSampleData(),
      animate: false,
    );
  }

  static List<charts.Series<BarData, String>> _createSampleData() {
    final data = [
      BarData('Var 1', 9),
      BarData('Var 2', 4),
      BarData('Var 3', 1.3242),
    ];

    return [
      charts.Series<BarData, String>(
        id: 'Variables',
        domainFn: (BarData data, _) => data.variable,
        measureFn: (BarData data, _) => data.value,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList as List<charts.Series<dynamic,String>>,
      animate: animate,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
    );
  }
}

class BarData {
  final String variable;
  final double value;

  BarData(this.variable, this.value);
}