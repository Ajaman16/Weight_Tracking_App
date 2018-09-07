import 'package:flutter/material.dart';
import '../models/weight_save_model.dart';
import 'package:intl/intl.dart';

class WeightListTile extends StatelessWidget {

  final WeightSave weightSave;
  final double weightDiff;

  WeightListTile({this.weightSave, this.weightDiff});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        ListTile(
          title: Row(
            children: <Widget>[
              buildDateTime(),
              buildWeight(),
              buildDiff()
            ],
          ),
        ),
        Divider()
      ],
    );

  }

  Widget buildDateTime() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            new DateFormat.yMMMMd().format(weightSave.dateTime),
            textScaleFactor: 0.9,
            textAlign: TextAlign.left,
          ),
          Text(
            new DateFormat.EEEE().format(weightSave.dateTime),
            textScaleFactor: 0.8,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.grey
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWeight() {
    return Expanded(
      child: Text(
        weightSave.weight.toString(),
        textScaleFactor: 2.0,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildDiff() {
    return Expanded(
      child: Text(
        weightDiff.toString(),
        textScaleFactor: 1.6,
        textAlign: TextAlign.right,
        style: TextStyle(
          color: weightDiff == 0 ? Colors.grey :(weightDiff < 0 ? Colors.redAccent: Colors.green)
        ),
      ),
    );
  }
}
