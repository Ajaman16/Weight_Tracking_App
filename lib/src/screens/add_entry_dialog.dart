import 'dart:math';
import '../widget/date_time_selector.dart';
import 'package:flutter/material.dart';
import '../models/weight_save_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:numberpicker/numberpicker.dart';

class AddEntryDialog extends StatefulWidget {

  final WeightSave weightSave;

  AddEntryDialog({this.weightSave});

  @override
  _AddEntryDialogState createState() => _AddEntryDialogState(weightSave: weightSave);
}

class _AddEntryDialogState extends State<AddEntryDialog> {

  DateTime _dateTime;
  double _weight = 60.0;
  TextEditingController _textController;
  String _notes = "";

  WeightSave weightSave;

  _AddEntryDialogState({this.weightSave}){
    if(weightSave != null)
      {
        _dateTime = weightSave.dateTime;
        _notes = weightSave.note;
        _weight = weightSave.weight;
      }
  }


  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: _notes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Entry"),
        actions: <Widget>[
          FlatButton(
              onPressed: (){

                if(weightSave == null)
                  {
                    weightSave = WeightSave(
                      weight: _weight,
                      dateTime: _dateTime == null ? DateTime.now() : _dateTime,
                      note: _notes,
                    );
                  } else{

                  weightSave.weight = _weight;
                  weightSave.dateTime = _dateTime == null ? DateTime.now() : _dateTime;
                  weightSave.note = _notes;
                }

                Navigator.of(context).pop(weightSave);
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
        Divider(height: 0.0,),
        buildWeightPicker(),
        Divider(height: 0.0,),
        buildNoteBox(),
        Divider(height: 0.0,),
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

  Widget buildNoteBox() {
    return ListTile(
      leading: Icon(Icons.speaker_notes, color: Colors.grey[500]),
      title: TextField(
        controller: _textController,
        decoration: InputDecoration(
          hintText: "Optional note"
        ),
        onChanged: (value){
          _notes = value;
          print(_notes);
        },
      ),
    );
  }
}
