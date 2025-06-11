import 'package:fintrack_app/bar%20Graph/bar_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarGraph extends StatelessWidget {
  final double? maxY;
  final double sunAmount;
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thuAmount;
  final double friAmount;
  final double satAmount;
  final String filter;
  final bool showFirstHalf;

  const MyBarGraph({
    super.key,
    required this.maxY,
    required this.sunAmount,
    required this.monAmount,
    required this.tueAmount,
    required this.wedAmount,
    required this.thuAmount,
    required this.friAmount,
    required this.satAmount,
    required this.filter,
    required this.showFirstHalf,
    required Map<int, double> data,
  });

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
      sunAmount: sunAmount,
      monAmount: monAmount,
      tueAmount: tueAmount,
      wedAmount: wedAmount,
      thuAmount: thuAmount,
      friAmount: friAmount,
      satAmount: satAmount,
      filter: filter,
    );

    myBarData.initializedBarData();

    return BarChart(BarChartData(
      maxY: maxY,
      minY: 0,
      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        show: true,
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) =>
                getBottomTitles(value, meta, filter, showFirstHalf),
          ),
        ),
      ),
      barGroups: myBarData.barData
          .map((data) => BarChartGroupData(x: data.x, barRods: [
                BarChartRodData(
                    toY: data.y,
                    width: 25,
                    borderRadius: BorderRadius.circular(4),
                    color: data.y > 0 ? Colors.green : Colors.transparent,
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: maxY,
                      color: Colors.grey[100],
                    ))
              ]))
          .toList(),
    ));
  }
}

Widget getBottomTitles(
    double value, TitleMeta meta, String filter, bool showFirstHalf) {
  const style = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  Widget text;
  if (filter == 'Monthly') {
    final months = showFirstHalf
        ? ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun']
        : ['Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    text = value.toInt() < months.length
        ? Text(months[value.toInt()], style: style)
        : const Text('', style: style);
  } else {
    switch (value.toInt()) {
      case 0:
        text = const Text('Sun', style: style);
        break;
      case 1:
        text = const Text('Mon', style: style);
        break;
      case 2:
        text = const Text('Tue', style: style);
        break;
      case 3:
        text = const Text('Wed', style: style);
        break;
      case 4:
        text = const Text('Thu', style: style);
        break;
      case 5:
        text = const Text('Fri', style: style);
        break;
      case 6:
        text = const Text('Sat', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
  }

  return SideTitleWidget(
    meta: meta,
    child: text,
  );
}
