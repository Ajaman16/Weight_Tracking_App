import 'package:firebase_database/firebase_database.dart';

class WeightSave{

  String key;
  DateTime dateTime;
  double weight;
  String note;

  WeightSave({this.weight, this.dateTime, this.note});

  WeightSave.fromSnapshot(DataSnapshot snapshot):
      key = snapshot.key,
      dateTime = DateTime.fromMillisecondsSinceEpoch(snapshot.value["timestamp"]),
      weight = snapshot.value["weight"].toDouble(),
      note = snapshot.value["note"];

  toJSON(){
    return {
      "weight": weight,
      "timestamp": dateTime.millisecondsSinceEpoch,
      "note": note
    };
  }
}