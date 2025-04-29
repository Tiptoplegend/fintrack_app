import 'package:fintrack_app/Data/expense_data.dart';
import 'package:fintrack_app/Datetime/date_time_helper.dart';
import 'package:fintrack_app/Models/expense_Item.dart';
import 'package:fintrack_app/bar%20Graph/bar_graph.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseSummary extends StatefulWidget {
  final DateTime startOfweek;
  const ExpenseSummary({
    super.key,
    required this.startOfweek,
  });

  @override
  _ExpenseSummaryState createState() => _ExpenseSummaryState();
}

class _ExpenseSummaryState extends State<ExpenseSummary> {
  // DateTime _currentWeekStart = DateTime.now();
  late DateTime _currentWeekStart;
  String _selectedFilter = 'Weekly';

  @override
  void initState() {
    super.initState();
    _currentWeekStart =
        widget.startOfweek; // Initialize with the provided startOfweek
  }

  double calculateMax(
      ExpenseData value,
      String sunday,
      String monday,
      String tuesday,
      String wednesday,
      String thursday,
      String friday,
      String saturday) {
    double? max = 100;

    List<double> values = [
      value.calculateDailyExpenseSummary()[sunday] ?? 0,
      value.calculateDailyExpenseSummary()[monday] ?? 0,
      value.calculateDailyExpenseSummary()[tuesday] ?? 0,
      value.calculateDailyExpenseSummary()[wednesday] ?? 0,
      value.calculateDailyExpenseSummary()[thursday] ?? 0,
      value.calculateDailyExpenseSummary()[friday] ?? 0,
      value.calculateDailyExpenseSummary()[saturday] ?? 0,
    ];

    values.sort();

    max = values.last * 1.1;

    return max == 0 ? 100 : max;
  }

  String calculateweekTotal(
    ExpenseData value,
    String sunday,
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
  ) {
    List<double> values = [
      value.calculateDailyExpenseSummary()[sunday] ?? 0,
      value.calculateDailyExpenseSummary()[monday] ?? 0,
      value.calculateDailyExpenseSummary()[tuesday] ?? 0,
      value.calculateDailyExpenseSummary()[wednesday] ?? 0,
      value.calculateDailyExpenseSummary()[thursday] ?? 0,
      value.calculateDailyExpenseSummary()[friday] ?? 0,
      value.calculateDailyExpenseSummary()[saturday] ?? 0,
    ];

    double total = 0;
    for (int i = 0; i < values.length; i++) {
      total += values[i];
    }
    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    String sunday = convertDateTimeToString(
        widget.startOfweek.add(const Duration(days: 0)));
    String monday =
        convertDateTimeToString(widget.startOfweek.add(Duration(days: 1)));
    String tuesday = convertDateTimeToString(
        widget.startOfweek.add(const Duration(days: 2)));
    String wednesday = convertDateTimeToString(
        widget.startOfweek.add(const Duration(days: 3)));
    String thursday = convertDateTimeToString(
        widget.startOfweek.add(const Duration(days: 4)));
    String friday = convertDateTimeToString(
        widget.startOfweek.add(const Duration(days: 5)));
    String saturday = convertDateTimeToString(
        widget.startOfweek.add(const Duration(days: 6)));

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Consumer<ExpenseData>(
      builder: (context, value, child) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 10, left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GHC ${calculateweekTotal(value, sunday, monday, tuesday, wednesday, thursday, friday, saturday)}',
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Total expense',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),

                // Dropdown
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                    color: isDarkMode ? Colors.grey[800] : Colors.white,
                  ),
                  child: DropdownButton<String>(
                    value: _selectedFilter,
                    underline: SizedBox(),
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    items: <String>['Weekly', 'Monthly', 'Yearly']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedFilter = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // week total summary
          SizedBox(
            height: 10,
          ),

          //  Navigator for the week,month and year
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(
                    color: isDarkMode ? Colors.grey[800]! : Colors.white,
                    width: 3.0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _currentWeekStart = _currentWeekStart
                              .subtract(const Duration(days: 7));
                        });
                      },
                      icon: Icon(Icons.arrow_back_ios_new)),
                  SizedBox(width: 20), // Adjust the width as needed
                  Expanded(
                    child: Text(
                      getWeekRange(_currentWeekStart),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(width: 20), // Adjust the width as needed
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _currentWeekStart =
                              _currentWeekStart.add(const Duration(days: 7));
                        });
                      },
                      icon: Icon(Icons.arrow_forward_ios)),
                ],
              ),
            ),
          ),

          SizedBox(
            height: 20,
          ),
          // Bar Graph
          SizedBox(
            height: 220,
            child: MyBarGraph(
              maxY: calculateMax(value, sunday, monday, tuesday, wednesday,
                  thursday, friday, saturday),
              sunAmount: value.calculateDailyExpenseSummary()[sunday] ?? 0,
              monAmount: value.calculateDailyExpenseSummary()[monday] ?? 0,
              tueAmount: value.calculateDailyExpenseSummary()[tuesday] ?? 0,
              wedAmount: value.calculateDailyExpenseSummary()[wednesday] ?? 0,
              thuAmount: value.calculateDailyExpenseSummary()[thursday] ?? 0,
              friAmount: value.calculateDailyExpenseSummary()[friday] ?? 0,
              satAmount: value.calculateDailyExpenseSummary()[saturday] ?? 0,
              data: {},
            ),
          ),
        ],
      ),
    );
  }

  // Weekly expense summary
  String getWeekRange(DateTime startDate) {
    DateTime endDate = startDate.add(Duration(days: 6));
    return "${startDate.day} ${_getMonthName(startDate.month)} - ${endDate.day} ${_getMonthName(endDate.month)} ${endDate.year}";
  }

  String _getMonthName(int month) {
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[month - 1];
  }

  List<ExpenseItem> getWeeklyExpenses(List<ExpenseItem> allExpenses) {
    DateTime weekEnd = _currentWeekStart.add(Duration(days: 6));

    return allExpenses.where((expense) {
      return expense.expenseDate
              .isAfter(_currentWeekStart.subtract(Duration(seconds: 1))) &&
          expense.expenseDate.isBefore(weekEnd.add(Duration(seconds: 1)));
    }).toList();
  }
}
