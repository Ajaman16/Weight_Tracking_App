import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../widget/weight_list_tile.dart';
import '../models/weight_save_model.dart';
import 'add_entry_dialog.dart';
import 'package:firebase_database/firebase_database.dart';

final mainReference = FirebaseDatabase.instance.reference();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<WeightSave> list = List<WeightSave>();

  _HomeState(){
    mainReference.child("users/user_1").onChildAdded.listen(_onDataAdded);
    mainReference.child("users/user_1").onChildChanged.listen(_onDataEdited);
  }

  _onDataAdded(Event event){
    setState(() {
      list.add(WeightSave.fromSnapshot(event.snapshot));
    });
  }

  _onDataEdited(Event event){

    WeightSave wv = list.singleWhere((wv){
      return wv.key == event.snapshot.key;
    });

    setState(() {
      list[list.indexOf(wv)] = WeightSave.fromSnapshot(event.snapshot);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weight Tracker"),
      ),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEntryDialog(null),
        child: Icon(Icons.add),
        tooltip: "Add Weight",
      ),
    );
  }

  Widget buildBody() {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index){

        double weightDiff = index == 0 ? 0.0 : (list[index].weight - list[index-1].weight);

        return GestureDetector(
          onTap: () => _openEntryDialog(list[index]),
          child: WeightListTile(
            weightSave: list[index],
            weightDiff: weightDiff,
          ),
        );

      }
    );
  }

  /*void addWeights(WeightSave weightSave) {
    setState(() {
      list.add(weightSave);
    });
  }*/

  Future _openEntryDialog(WeightSave wv)async {
    WeightSave weightSave = await Navigator.of(context).push(
        MaterialPageRoute<WeightSave>(
          builder: (BuildContext context){
            return AddEntryDialog(weightSave: wv);
          },
          fullscreenDialog: true
      )
    );

    if(weightSave != null)
      {
        //addWeights(weightSave);
        //print(weightSave.toJSON());

        if(weightSave.key == null)
          mainReference.child("users/user_1").push().set(weightSave.toJSON());
        else
          mainReference.child("users/user_1/${weightSave.key}").set(weightSave.toJSON());
      }
  }
}

