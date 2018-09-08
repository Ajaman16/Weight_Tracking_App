import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../widget/weight_list_tile.dart';
import '../models/weight_save_model.dart';
import 'add_entry_dialog.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<WeightSave> list = List<WeightSave>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weight Tracker"),
      ),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _openEntryDialog,
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

        return WeightListTile(
          weightSave: list[index],
          weightDiff: weightDiff,
        );
      }
    );
  }

  void addWeights(WeightSave weightSave) {
    setState(() {
      list.add(weightSave);
    });
  }

  Future _openEntryDialog()async {
    WeightSave weightSave = await Navigator.of(context).push(
        MaterialPageRoute<WeightSave>(
          builder: (BuildContext context){
            return AddEntryDialog();
          },
          fullscreenDialog: true
      )
    );

    if(weightSave != null)
      {
        addWeights(weightSave);
      }
  }
}

