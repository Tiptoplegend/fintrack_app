import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  final Function(String) onCycleSelected;

  const CalendarPage({super.key, required this.onCycleSelected});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String _selectedFrequency = 'Daily';

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
                              selectedDayPredicate: (day) {
                                return isSameDay(_selectedDay, day);
                              },
                              onDaySelected: (selectedDay, focusedDay) {
                                setState(() {
                                  _selectedDay = selectedDay;
                                  _focusedDay = focusedDay; // update `_focusedDay` here as well
                                });
                              },
                              calendarFormat: CalendarFormat.month,
                              onFormatChanged: (format) {
                                // Handle format change if needed
                              },
                              onPageChanged: (focusedDay) {
                                _focusedDay = focusedDay;
                              },
                              calendarStyle: CalendarStyle(
                                defaultTextStyle: TextStyle(color: Colors.black, fontSize: 18),
                                weekendTextStyle: TextStyle(color: Colors.black, fontSize: 18),
                                outsideTextStyle: TextStyle(color: Colors.grey, fontSize: 18),
                                todayTextStyle: TextStyle(color: Colors.white, fontSize: 18),
                                selectedTextStyle: TextStyle(color: Colors.white, fontSize: 18),
                                selectedDecoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                todayDecoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              headerStyle: HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true,
                                titleTextStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                                leftChevronIcon: const Icon(
                                  Icons.chevron_left,
                                  color: Colors.black,
                                ),
                                rightChevronIcon: const Icon(
                                  Icons.chevron_right,
                                  color: Colors.black,
                                ),
                              ),
                              calendarBuilders: CalendarBuilders(
                                defaultBuilder: (context, day, focusedDay) {
                                  if (_selectedFrequency == 'Weekly' && _selectedDay != null) {
                                    final startOfWeek = _selectedDay!.subtract(Duration(days: _selectedDay!.weekday - 1));
                                    final endOfWeek = startOfWeek.add(Duration(days: 6));

                                    if (day.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
                                        day.isBefore(endOfWeek.add(Duration(days: 1)))) {
                                      return Container(
                                        margin: const EdgeInsets.all(4.0),
                                        decoration: BoxDecoration(
                                          color: Colors.lightGreen.withOpacity(0.5),
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${day.day}',
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Handle set cycle action
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
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
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

Widget _FrequencyDropdown({required String selectedFrequency, required ValueChanged<String?> onChanged}) {
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
