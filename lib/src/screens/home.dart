import 'dart:math';
import 'package:flutter/material.dart';
import '../widget/weight_list_tile.dart';
import '../models/weight_save_model.dart';

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
        onPressed: addWeights,
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

  void addWeights() {
    setState(() {
      list.add(WeightSave(dateTime: DateTime.now(), weight: Random().nextInt(100).toDouble()));
    });
  }
}

