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
  final Map<String, dynamic> data;

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
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rodTrack = isDark ? Colors.grey.shade800 : Colors.grey.shade100;

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
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        show: true,
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) => getBottomTitles(
              value,
              meta,
              filter,
              showFirstHalf,
              data,
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
            ),
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
                      color: rodTrack,
                    ))
              ]))
          .toList(),
    ));
  }
}

Widget getBottomTitles(
  double value,
  TitleMeta meta,
  String filter,
  bool showFirstHalf,
  Map<String, dynamic> data,
  Color labelColor,
) {
  final style = TextStyle(
    color: labelColor,
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );
  Widget text;
  if (filter == 'Yearly') {
    final years =
        data['years'] as List<String>? ?? ['', '', '', '', '', '', ''];
    text = value.toInt() < years.length
        ? Text("'${years[value.toInt()].substring(2)}", style: style)
        : Text('', style: style);
  } else if (filter == 'Monthly') {
    final months = showFirstHalf
        ? ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun']
        : ['Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    text = value.toInt() < months.length
        ? Text(months[value.toInt()], style: style)
        : Text('', style: style);
  } else {
    // Weekly
    switch (value.toInt()) {
      case 0:
        text = Text('Sun', style: style);
        break;
      case 1:
        text = Text('Mon', style: style);
        break;
      case 2:
        text = Text('Tue', style: style);
        break;
      case 3:
        text = Text('Wed', style: style);
        break;
      case 4:
        text = Text('Thu', style: style);
        break;
      case 5:
        text = Text('Fri', style: style);
        break;
      case 6:
        text = Text('Sat', style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }
  }

  return SideTitleWidget(
    space: 8.0,
    meta: meta,
    child: text,
  );
}
