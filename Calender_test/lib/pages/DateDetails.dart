import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// ignore: unused_import
import 'package:table_calendar/table_calendar.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:calendertest/pages/Details.dart';
import 'package:calendertest/main.dart';

bool readornot = false;

FocusNode _namefocusNode = FocusNode();
FocusNode _numfocusNode = FocusNode();
FocusNode _invdate_focusNode = FocusNode();
FocusNode _duedate_focusNode = FocusNode();
FocusNode _total_focusNode = FocusNode();
FocusNode _currency_focusNode = FocusNode();

late TextEditingController name_controller;
late TextEditingController invno_controller;
late TextEditingController invdate_controller;
late TextEditingController duedate_controller;
late TextEditingController total_controller;
late TextEditingController currency_controller;

DateTime convert_to_utc(String stringdate) {
  List<String> dateParts = stringdate.split('/');
  if (dateParts.length == 3) {
    DateTime Date = DateTime.utc(
      int.parse(dateParts[2]), // year
      int.parse(dateParts[1]), // month
      int.parse(dateParts[0]), // day
    );
    return Date;
  } else {
    throw FormatException("Invalid date format");
  }
}

DateTime convertdate(String stringdate) {
  List<String> dateParts = stringdate.split('/');
  if (dateParts.length == 3) {
    DateTime Date = DateTime(
      int.parse(dateParts[2]), // year
      int.parse(dateParts[1]), // month
      int.parse(dateParts[0]), // day
    );
    return Date;
  } else {
    throw FormatException("Invalid date format");
  }
}

class DateDetails extends StatefulWidget {
  final DateTime date;
  final TextEditingController controller;
  final bool isdate;
  const DateDetails(
      {super.key,
      required this.date,
      required this.controller,
      required this.isdate});

  @override
  State<DateDetails> createState() => _DateDetailsState();
}

class _DateDetailsState extends State<DateDetails> {
  bool datechanged = false;
  bool sureornot = false;
  String? temp;
  DateTime? newdate;

  Future<void> read_details() async {
    try {
      setState(() {
        name_controller = TextEditingController(text: "Sai Balaji");
        invno_controller = TextEditingController(text: "11021");
        //  invdate_controller = TextEditingController(text: "");
        duedate_controller = TextEditingController(text: "30/06/2024");
        total_controller = TextEditingController(text: "5220.00");
        currency_controller = TextEditingController(text: "INR");
      });
    } catch (error) {
      print("Error reading JSON file: $error");
      // Handle error appropriately (e.g., display an error message to the user)
    }
  }

  Future<void> _showDatePicker(String sdate) async {
    DateTime datee = convertdate(sdate);
    DateTime? _selectedDateTime;

    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: datee,
        firstDate: DateTime(DateTime.now().year.toInt()),
        lastDate: DateTime(DateTime.now().year.toInt() + 1));
    if (pickedDate != null) {
      setState(() {
        _selectedDateTime = pickedDate;
        String formattedDate =
            "${_selectedDateTime!.day}/${_selectedDateTime!.month}/${_selectedDateTime!.year}";
        widget.controller.text = formattedDate;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    read_details();
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(''),
          content: Text('Are you sure you want to change the date?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  temp = widget.controller.text;
                });

                _showDatePicker(widget.controller.text);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Details')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Text("  Date :  ", style: TextStyle(fontSize: 25)),
                  Expanded(
                    child: TextField(
                      controller: widget.controller,
                      readOnly: true,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3D3D3D),
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    width: 60,
                    child: InkWell(
                      onTap: () {
                        _showAlertDialog(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SvgPicture.asset("assets/icons/calendar.svg"),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                "Summary:",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              EditableField(
                  controller: invno_controller,
                  title: "Invoice No.  ",
                  isDate: false),
              EditableField(
                  controller: name_controller, title: "Name  ", isDate: false),
              EditableField(
                  controller: duedate_controller,
                  title: "Due Date ",
                  isDate: true),
              EditableField(
                  controller: total_controller,
                  title: "Amount  ",
                  isDate: false),
              EditableField(
                  controller: currency_controller,
                  title: "Currency ",
                  isDate: false),
              const SizedBox(height: 200),
              Container(
                height: 50,
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    if (temp == widget.controller.text) {
                      Navigator.pop(context, true);
                    } else {
                      Navigator.pop(context, true);
                      newdate = convert_to_utc(widget.controller.text);
                      scheduled_dates.remove(convert_to_utc(temp!));
                      scheduled_dates.add(newdate!);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 119, 218, 122),
                      foregroundColor: Colors.white),
                  child: const Text("Confirm"),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
        floatingActionButton: DraggableFab(
            child: SizedBox(
          height: 55,
          width: 55,
          child: FloatingActionButton(
            onPressed: () {
              showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                        insetPadding: EdgeInsets.all(10),
                        backgroundColor: Colors.transparent,
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                testinvoice, // Replace with your image path
                                fit: BoxFit.cover,
                              ),
                            )));
                  });
            },
            tooltip: "Console message",
            backgroundColor: const Color.fromARGB(255, 127, 212, 130),
            child: SvgPicture.asset(
              "assets/icons/doc.svg",
              height: 40,
              width: 40,
            ),
          ),
        )));
  }
}

//
//
//
//

class EditableField extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final bool isDate;
  const EditableField(
      {super.key,
      required this.controller,
      required this.title,
      required this.isDate});

  @override
  State<EditableField> createState() => _EditableFieldState();
}

class _EditableFieldState extends State<EditableField> {
  Future<void> _showDatePicker(String sdate) async {
    DateTime datee = convertdate(sdate);
    DateTime? _selectedDateTime;

    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: datee,
        firstDate: DateTime(DateTime.now().year.toInt()),
        lastDate: DateTime(DateTime.now().year.toInt() + 1));
    if (pickedDate != null) {
      setState(() {
        _selectedDateTime = pickedDate;
        String formattedDate =
            "${_selectedDateTime!.day}/${_selectedDateTime!.month}/${_selectedDateTime!.year}";
        widget.controller.text = formattedDate;
      });
    }
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(''),
          content: Text('Are you sure you want to change the date?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();

                _showDatePicker(widget.controller.text);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 220,
      child: Row(
        children: [
          Text(widget.title + ":  ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
          Expanded(
            child: TextField(
              controller: widget.controller,
              readOnly: widget.isDate ? true : false,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3D3D3D),
              ),
              onTap: () {
                if (widget.isDate == true) {
                  _showAlertDialog(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
