import 'dart:math';
import '../widget/date_time_selector.dart';
import 'package:flutter/material.dart';
import '../models/weight_save_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:numberpicker/numberpicker.dart';

class AddEntryDialog extends StatefulWidget {
  @override
  _AddEntryDialogState createState() => _AddEntryDialogState();
}

class _AddEntryDialogState extends State<AddEntryDialog> {

  DateTime _dateTime;
  double _weight = 60.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Entry"),
        actions: <Widget>[
          FlatButton(
              onPressed: (){
                Navigator.of(context).pop(WeightSave(
                    weight: _weight,
                    dateTime: _dateTime == null ? DateTime.now() : _dateTime
                ));
              },
              child: Text(
                "SAVE",
                style: Theme
                    .of(context)
                    .textTheme
                    .subhead
                    .copyWith(color: Colors.white)
              )
          )
        ],
      ),
      body: buildBody()
    );
  }

  Widget buildBody() {

    return Column(
      children: <Widget>[
        buildDateNtimePicker(),
        Divider(),
        buildWeightPicker(),
        Divider(),
      ],
    );

  }

  Widget buildDateNtimePicker() {
    return ListTile(
      leading: Icon(FontAwesomeIcons.calendarCheck, color: Colors.grey[500]
      ),
      title: DateTimeSelector(
              onChanged: (dateTime){
                setState(() {
                  _dateTime = dateTime;
                });
              },
              dateTime: _dateTime
          ),
    );
  }

  Widget buildWeightPicker() {
    return ListTile(
      leading: Icon(FontAwesomeIcons.weight, color: Colors.grey[500]),
      title: Text("$_weight kg"),
      onTap: () => showWeightPicker(context),
    );
  }

  showWeightPicker(BuildContext context) {
    showDialog(
      context: context,
      child: NumberPickerDialog.decimal(
          minValue: 1,
          maxValue: 150,
          initialDoubleValue: _weight,
          title: Text("Enter your weight"),
      ),
    ).then((value){
      if(value != null)
        {
          setState(() {
            _weight = value;
          });
        }
    });
  }
}
