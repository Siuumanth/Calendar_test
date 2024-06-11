import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// ignore: unused_import
import 'package:table_calendar/table_calendar.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:calendertest/pages/Details.dart';
import 'package:calendertest/pages/DateDetails.dart';

List<DateTime> scheduled_dates = [
  DateTime.utc(2024, 6, 14),
  DateTime.utc(2024, 6, 18)
];

List<Map<String, dynamic>> duedates2 = [];

String testinvoice = "assets/images/testinvoice.png";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calendar(),
    );
  }
}

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late TextEditingController date_controller;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  DateTime convertdate(String stringdate) {
    List<String> dateParts = stringdate.split('/');
    if (dateParts.length == 3) {
      DateTime Date = DateTime(
        int.parse(dateParts[0]), // year
        int.parse(dateParts[1]), // month
        int.parse(dateParts[2]), // day
      );
      return Date;
    } else {
      throw FormatException("Invalid date format");
    }
  }

  void _navigate(DateTime selectedDay) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DateDetails(
            date: selectedDay,
            controller: date_controller,
            isdate: true,
          ),
        ));
    if (result == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Calendar")),
        body: Column(
          children: [
            const Text("124"),
            Container(
                child: TableCalendar(
              headerStyle: const HeaderStyle(
                  formatButtonVisible: false, titleCentered: true),
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2024),
              lastDay: DateTime.utc(2025),
              onDaySelected: (selectedDay, focusedDay) {
                if (scheduled_dates.contains(selectedDay)) {
                  setState(() {
                    date_controller = TextEditingController(
                        text: DateFormat('dd/MM/yyyy').format(selectedDay));
                    _navigate(selectedDay);
                  });
                }
              },
              calendarBuilders:
                  CalendarBuilders(defaultBuilder: (context, day, focusedDay) {
                if (scheduled_dates.contains(day)) {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: scheduled_dates.contains(day)
                          ? const Color.fromARGB(255, 147, 237, 150)
                          : Color.fromARGB(255, 255, 242, 128),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      '${day.day}',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                } else {
                  return null;
                }
              }),
            )),
          ],
        ));
  }
}
