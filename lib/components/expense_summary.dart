import 'package:fintrack_app/Data/expense_data.dart';
import 'package:fintrack_app/Datetime/date_time_helper.dart';
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
  // weekly filter
  late DateTime _currentWeekStart;
  String _selectedFilter = 'Weekly';
  // monthly filter
  DateTime? _currentMonthStart;
  bool _showFirstHalf = true;

  @override
  void initState() {
    super.initState();
    _currentWeekStart = widget.startOfweek;
    _currentMonthStart = DateTime(DateTime.now().year, DateTime.now().month, 1);
  }

  double calculateWeeklyMax(
      ExpenseData value,
      String sunday,
      String monday,
      String tuesday,
      String wednesday,
      String thursday,
      String friday,
      String saturday) {
    double max = 100;

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

  // String calculateWeekTotal(
  //   ExpenseData value,
  //   String sunday,
  //   String monday,
  //   String tuesday,
  //   String wednesday,
  //   String thursday,
  //   String friday,
  //   String saturday,
  // ) {
  //   List<double> values = [
  //     value.calculateDailyExpenseSummary()[sunday] ?? 0,
  //     value.calculateDailyExpenseSummary()[monday] ?? 0,
  //     value.calculateDailyExpenseSummary()[tuesday] ?? 0,
  //     value.calculateDailyExpenseSummary()[wednesday] ?? 0,
  //     value.calculateDailyExpenseSummary()[thursday] ?? 0,
  //     value.calculateDailyExpenseSummary()[friday] ?? 0,
  //     value.calculateDailyExpenseSummary()[saturday] ?? 0,
  //   ];

  //   double total = values.reduce((a, b) => a + b);
  //   return total.toStringAsFixed(2);
  // }

  @override
  Widget build(BuildContext context) {
    String sunday = convertDateTimeToString(_currentWeekStart);
    String monday =
        convertDateTimeToString(_currentWeekStart.add(const Duration(days: 1)));
    String tuesday =
        convertDateTimeToString(_currentWeekStart.add(const Duration(days: 2)));
    String wednesday =
        convertDateTimeToString(_currentWeekStart.add(const Duration(days: 3)));
    String thursday =
        convertDateTimeToString(_currentWeekStart.add(const Duration(days: 4)));
    String friday =
        convertDateTimeToString(_currentWeekStart.add(const Duration(days: 5)));
    String saturday =
        convertDateTimeToString(_currentWeekStart.add(const Duration(days: 6)));

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
                      _selectedFilter == 'Weekly'
                          // ? 'GHC ${calculateWeekTotal(value, sunday, monday, tuesday, wednesday, thursday, friday, saturday)}'
                          ? 'GHC ${value.calculateWeekTotal(_currentWeekStart)}'
                          : 'GHC ${calculateHalfYearTotal(value, _currentMonthStart!.year, _showFirstHalf).toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _selectedFilter == 'Weekly'
                          ? 'Total Weekly expense'
                          : 'Total Monthly expenses',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                    color: isDarkMode ? Colors.grey[800] : Colors.white,
                  ),
                  child: DropdownButton<String>(
                    value: _selectedFilter,
                    underline: const SizedBox(),
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
                        if (_selectedFilter == 'Monthly') {
                          _showFirstHalf = true;
                          _currentMonthStart =
                              DateTime(_currentMonthStart!.year, 1, 1);
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDarkMode ? Colors.grey[800]! : Colors.white,
                  width: 3.0,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (_selectedFilter == 'Weekly') {
                          _currentWeekStart = _currentWeekStart
                              .subtract(const Duration(days: 7));
                        } else if (_selectedFilter == 'Monthly') {
                          _showFirstHalf = !_showFirstHalf;
                          _currentMonthStart = DateTime(
                            _currentMonthStart!.year,
                            _showFirstHalf ? 1 : 7,
                            1,
                          );
                        }
                      });
                    },
                    icon: const Icon(Icons.arrow_back_ios_new),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      _selectedFilter == 'Weekly'
                          ? getWeekRange(_currentWeekStart)
                          : getMonthRange(_showFirstHalf),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (_selectedFilter == 'Weekly') {
                          _currentWeekStart =
                              _currentWeekStart.add(const Duration(days: 7));
                        } else if (_selectedFilter == 'Monthly') {
                          _showFirstHalf = !_showFirstHalf;
                          _currentMonthStart = DateTime(
                              _currentMonthStart!.year,
                              _showFirstHalf ? 1 : 7,
                              1);
                        }
                      });
                    },
                    icon: const Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: _selectedFilter == 'Weekly'
                // weekly bar graph ui
                ? MyBarGraph(
                    maxY: calculateWeeklyMax(value, sunday, monday, tuesday,
                        wednesday, thursday, friday, saturday),
                    sunAmount:
                        value.calculateDailyExpenseSummary()[sunday] ?? 0,
                    monAmount:
                        value.calculateDailyExpenseSummary()[monday] ?? 0,
                    tueAmount:
                        value.calculateDailyExpenseSummary()[tuesday] ?? 0,
                    wedAmount:
                        value.calculateDailyExpenseSummary()[wednesday] ?? 0,
                    thuAmount:
                        value.calculateDailyExpenseSummary()[thursday] ?? 0,
                    friAmount:
                        value.calculateDailyExpenseSummary()[friday] ?? 0,
                    satAmount:
                        value.calculateDailyExpenseSummary()[saturday] ?? 0,
                    filter: _selectedFilter, // New
                    showFirstHalf: _showFirstHalf, // New
                    data: {},
                  )
                // Monthly bar graph ui
                : MyBarGraph(
                    maxY: calculateMonthlyMax(
                        value, _currentMonthStart!.year, _showFirstHalf),
                    sunAmount: _showFirstHalf
                        ? calculateMonthTotal(
                            value, _currentMonthStart!.year, 1)
                        : calculateMonthTotal(
                            value, _currentMonthStart!.year, 7),
                    monAmount: _showFirstHalf
                        ? calculateMonthTotal(
                            value, _currentMonthStart!.year, 2)
                        : calculateMonthTotal(
                            value, _currentMonthStart!.year, 8),
                    tueAmount: _showFirstHalf
                        ? calculateMonthTotal(
                            value, _currentMonthStart!.year, 3)
                        : calculateMonthTotal(
                            value, _currentMonthStart!.year, 9),
                    wedAmount: _showFirstHalf
                        ? calculateMonthTotal(
                            value, _currentMonthStart!.year, 4)
                        : calculateMonthTotal(
                            value, _currentMonthStart!.year, 10),
                    thuAmount: _showFirstHalf
                        ? calculateMonthTotal(
                            value, _currentMonthStart!.year, 5)
                        : calculateMonthTotal(
                            value, _currentMonthStart!.year, 11),
                    friAmount: _showFirstHalf
                        ? calculateMonthTotal(
                            value, _currentMonthStart!.year, 6)
                        : calculateMonthTotal(
                            value, _currentMonthStart!.year, 12),
                    satAmount: 0,
                    filter: _selectedFilter,
                    showFirstHalf: _showFirstHalf,
                    data: {},
                  ),
          ),
        ],
      ),
    );
  }

  String getWeekRange(DateTime startDate) {
    DateTime endDate = startDate.add(const Duration(days: 6));
    return "${startDate.day} ${_getMonthName(startDate.month)} - ${endDate.day} ${_getMonthName(endDate.month)} ${endDate.year}";
  }

  String _getMonthName(int month) {
    const months = [
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

// Monthly filter logic
  double calculateMonthTotal(ExpenseData value, int year, int month) {
    double total = 0;
    DateTime startOfMonth = DateTime(year, month, 1);
    DateTime endOfMonth =
        DateTime(year, month + 1, 1).subtract(const Duration(days: 1));

    for (var expense in value.getExpenseList()) {
      if (expense.expenseDate
              .isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
          expense.expenseDate
              .isBefore(endOfMonth.add(const Duration(days: 1)))) {
        total += expense.expenseAmount;
      }
    }
    return total;
  }

  double calculateMonthlyMax(ExpenseData value, int year, bool firstHalf) {
    double max = 100;
    List<double> values = [];

    int startMonth = firstHalf ? 1 : 7;
    int endMonth = firstHalf ? 6 : 12;

    for (int month = startMonth; month <= endMonth; month++) {
      double total = calculateMonthTotal(value, year, month);
      values.add(total);
    }

    values.sort();
    max = values.last * 1.1;

    return max == 0 ? 100 : max;
  }

  String getMonthRange(bool firstHalf) {
    if (firstHalf) {
      return "Jan - Jun ${_currentMonthStart!.year}";
    } else {
      return "Jul - Dec ${_currentMonthStart!.year}";
    }
  }

  double calculateHalfYearTotal(ExpenseData value, int year, bool firstHalf) {
    double total = 0;
    int startMonth = firstHalf ? 1 : 7;
    int endMonth = firstHalf ? 6 : 12;

    for (int month = startMonth; month <= endMonth; month++) {
      total += calculateMonthTotal(value, year, month);
    }

    return total;
  }
}
