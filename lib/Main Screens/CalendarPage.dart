import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart' as intl;

class CalendarPage extends StatefulWidget {
  final Function(String) onCycleSelected;

  const CalendarPage({super.key, required this.onCycleSelected});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _startDate;
  DateTime? _endDate;
  String _selectedFrequency = 'Daily';


  final intl.DateFormat _dateFormatter = intl.DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Header(context),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Edit budget cycle',
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'inter',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _FrequencyDropdown(
                    selectedFrequency: _selectedFrequency,
                    onChanged: (value) {
                      setState(() {
                        _selectedFrequency = value!;
                        _startDate = null;
                        _endDate = null;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _PickStartDateText(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            TableCalendar(
                              firstDay: DateTime.utc(2000, 1, 1),
                              lastDay: DateTime.utc(2100, 12, 31),
                              focusedDay: _focusedDay,
                              calendarFormat: CalendarFormat.month,
                              rangeStartDay: _startDate,
                              rangeEndDay: _endDate,
                              onDaySelected: (selectedDay, focusedDay) {
                                setState(() {
                                  if (_startDate == null ||
                                      (_startDate != null && _endDate != null)) {
                                    _startDate = selectedDay;
                                    _endDate = null;
                                  } else if (_startDate != null &&
                                      _endDate == null) {
                                    if (selectedDay.isAfter(_startDate!)) {
                                      _endDate = selectedDay;
                                    } else {
                                      _startDate = selectedDay;
                                    }
                                  }
                                  _focusedDay = focusedDay;
                                });
                              },
                              selectedDayPredicate: (day) {
                                return (_startDate != null &&
                                        day.isAtSameMomentAs(_startDate!)) ||
                                    (_endDate != null &&
                                        day.isAtSameMomentAs(_endDate!));
                              },
                              onPageChanged: (focusedDay) {
                                setState(() {
                                  _focusedDay = focusedDay;
                                });
                              },
                              calendarStyle: CalendarStyle(
                                rangeHighlightColor:
                                    Colors.lightGreen.withOpacity(0.5),
                                defaultTextStyle: const TextStyle(
                                    color: Colors.black, fontSize: 18),
                                weekendTextStyle: const TextStyle(
                                    color: Colors.black, fontSize: 18),
                                todayTextStyle: const TextStyle(
                                    color: Colors.black, fontSize: 18),
                                selectedTextStyle: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                                selectedDecoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                todayDecoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                rangeStartDecoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                rangeEndDecoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                withinRangeTextStyle: const TextStyle(
                                    color: Colors.redAccent, fontSize: 18),
                              ),
                              headerStyle: const HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true,
                                titleTextStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                                leftChevronIcon: Icon(
                                  Icons.chevron_left,
                                  color: Colors.black,
                                ),
                                rightChevronIcon: Icon(
                                  Icons.chevron_right,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  // For Daily frequency
                                  if (_selectedFrequency == 'Daily') {
                                    if (_startDate != null && _endDate != null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          backgroundColor: Colors.white,
                                          content: Text(
                                            'This action is wrong.',
                                            style: TextStyle(
                                              fontFamily: 'inter',
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      );
                                    } else if (_startDate == null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          backgroundColor: Colors.white,
                                          content: Text(
                                            'Please select a start date for Daily cycle.',
                                            style: TextStyle(
                                              fontFamily: 'inter',
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      final selectedCycle =
                                          _dateFormatter.format(_startDate!);
                                      widget.onCycleSelected(selectedCycle);
                                    }
                                  }
                                  // For Weekly or Monthly frequency
                                  else {
                                    if (_startDate == null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          backgroundColor: Colors.white,
                                          content: Text(
                                            'Please select a start date for Weekly or Monthly.',
                                            style: TextStyle(
                                              fontFamily: 'inter',
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      );
                                    } else if (_endDate == null) {
                                      // Require both start and end dates for Weekly/Monthly
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          backgroundColor: Colors.white,
                                          content: Text(
                                            'Please select both a start date and an end date for Weekly or Monthly.',
                                            style: TextStyle(
                                              fontFamily: 'inter',
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      // Both start and end dates are selected for Weekly/Monthly
                                      final selectedCycle =
                                          '${_dateFormatter.format(_startDate!)} -> ${_dateFormatter.format(_endDate!)}';
                                      widget.onCycleSelected(selectedCycle);
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: const Text(
                                  'Set cycle',
                                  style: TextStyle(
                                    fontFamily: 'inter',
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _Header(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

Widget _FrequencyDropdown({
  required String selectedFrequency,
  required ValueChanged<String?> onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Frequency',
          style: TextStyle(
            fontFamily: 'inter',
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        DropdownButton<String>(
          value: selectedFrequency,
          iconEnabledColor: Colors.black,
          dropdownColor: Colors.white,
          items: const [
            DropdownMenuItem(
              value: 'Daily',
              child: Text(
                'Daily',
                style: TextStyle(color: Colors.black),
              ),
            ),
            DropdownMenuItem(
              value: 'Weekly',
              child: Text(
                'Weekly',
                style: TextStyle(color: Colors.black),
              ),
            ),
            DropdownMenuItem(
              value: 'Monthly',
              child: Text(
                'Monthly',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
          onChanged: onChanged,
        ),
      ],
    ),
  );
}

Widget _PickStartDateText() {
  return const Padding(
    padding: EdgeInsets.only(left: 16.0, top: 16.0),
    child: Text(
      'Pick a start date',
      style: TextStyle(
        fontSize: 16,
        fontFamily: 'inter',
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
  );
}