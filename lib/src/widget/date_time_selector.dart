import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeSelector extends StatelessWidget {

  final DateTime date;
  final TimeOfDay time;
  final ValueChanged<DateTime> onChanged;

  DateTimeSelector({Key key, DateTime dateTime, @required this.onChanged}):
      assert(onChanged != null),
      date = dateTime == null
             ? DateTime.now()
             : DateTime(dateTime.year, dateTime.month, dateTime.day),

      time = dateTime == null
             ? TimeOfDay.now()
             : TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),

      super(key: key);


  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: InkWell(
              onTap: () => _showDatePicker(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  DateFormat.MMMMEEEEd().format(date),
                ),
              ),
            )
        ),

        InkWell(
          onTap: () => _showTimePicker(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "${time.format(context)}"
            ),
          ),
        )
      ],
    );
  }

  Future _showDatePicker(BuildContext context) async {
    DateTime dateTimePicked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: date.subtract(const Duration(days: 7)),
        lastDate: new DateTime.now());

    if (dateTimePicked != null) {
      onChanged(new DateTime(dateTimePicked.year, dateTimePicked.month,
          dateTimePicked.day, time.hour, time.minute));
    }
  }

  Future _showTimePicker(BuildContext context) async {
    TimeOfDay timeOfDay =
    await showTimePicker(context: context, initialTime: time);

    if (timeOfDay != null) {
      onChanged(new DateTime(
          date.year, date.month, date.day, timeOfDay.hour, timeOfDay.minute));
    }
  }
}
